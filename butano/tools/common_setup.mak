
#---------------------------------------------------------------------------------------------------------------------
 
export OUTPUT	:=	$(CURDIR)/$(TARGET)
 
export VPATH	:=  $(foreach dir,	$(SOURCES),	$(CURDIR)/$(dir)) \
                        $(foreach dir,	$(BNSOURCES),	$(dir)) \
                        $(foreach dir,	$(DATA),	$(CURDIR)/$(dir)) \
                        $(foreach dir,	$(DMGAUDIO),	$(CURDIR)/$(dir)) \
                        $(foreach dir,	$(GRAPHICS),	$(CURDIR)/$(dir))

export DEPSDIR	:=  $(CURDIR)/$(BUILD)

CFILES          :=  $(foreach dir,	$(SOURCES),	$(notdir $(wildcard $(dir)/*.c))) \
						$(foreach dir,	$(BNSOURCES),	$(notdir $(wildcard $(dir)/*.c)))
						
CPPFILES        :=	$(foreach dir,	$(SOURCES),	$(notdir $(wildcard $(dir)/*.cpp))) \
						$(foreach dir,	$(BNSOURCES),	$(notdir $(wildcard $(dir)/*.cpp)))
						
SFILES          :=	$(foreach dir,	$(SOURCES),	$(notdir $(wildcard $(dir)/*.s))) \
						$(foreach dir,	$(BNSOURCES),	$(notdir $(wildcard $(dir)/*.s)))
						
BINFILES        :=	$(foreach dir,	$(DATA),	$(notdir $(wildcard $(dir)/*.*))) \
						_bn_audio_soundbank.bin
						
DMGMODFILES		:=	$(foreach dir,	$(DMGAUDIO),	$(notdir $(wildcard $(dir)/*.mod)))
						
DMGS3MFILES		:=	$(foreach dir,	$(DMGAUDIO),	$(notdir $(wildcard $(dir)/*.s3m)))
						
DMGVGMFILES		:=	$(foreach dir,	$(DMGAUDIO),	$(notdir $(wildcard $(dir)/*.vgm)))
						
GRAPHICSFILES	:=	$(foreach dir,	$(GRAPHICS),	$(notdir $(wildcard $(dir)/*.bmp)))

#---------------------------------------------------------------------------------------------------------------------
# Use CXX for linking C++ projects, CC for standard C:
#---------------------------------------------------------------------------------------------------------------------
ifeq ($(strip $(CPPFILES)),)
#---------------------------------------------------------------------------------------------------------------------
    export LD   :=  $(CC)
#---------------------------------------------------------------------------------------------------------------------
else
#---------------------------------------------------------------------------------------------------------------------
    export LD	:=  $(CXX)
#---------------------------------------------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------------------------------------------

export OFILES_BIN       :=  $(addsuffix .o,$(BINFILES))

export OFILES_DMG		:=  $(DMGMODFILES:.mod=_bn_dmg.o) $(DMGS3MFILES:.s3m=_bn_dmg.o) $(DMGVGMFILES:.vgm=_bn_dmg.o)

export OFILES_GRAPHICS	:=  $(GRAPHICSFILES:.bmp=_bn_gfx.o)

export OFILES_SOURCES   :=  $(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(SFILES:.s=.o)
 
export OFILES           :=  $(OFILES_BIN) $(OFILES_DMG) $(OFILES_GRAPHICS) $(OFILES_SOURCES)

#---------------------------------------------------------------------------------------------------------------------
# Don't generate header files from audio soundbank (avoid rebuilding all sources when audio files are updated):
#---------------------------------------------------------------------------------------------------------------------
export HFILES           :=  $(filter-out audio_data.h,$(addsuffix .h,$(subst .,_,$(BINFILES))))

export INCLUDE          :=  $(foreach dir,$(INCLUDES),-iquote $(CURDIR)/$(dir)) \
                                $(foreach dir,$(LIBDIRS),-I$(dir)/include) \
                                -I$(CURDIR)/$(BUILD)
 
export LIBPATHS         :=  $(foreach dir,$(LIBDIRS),-L$(dir)/lib)

.PHONY: $(BUILD) clean
 
#---------------------------------------------------------------------------------
all:
	@[ -d $(BUILD) ] || mkdir -p $(BUILD)
	@$(EXTTOOL)
	@$(MAKE) --no-print-directory $(BUILD)
	
#---------------------------------------------------------------------------------
$(BUILD):
	$(SILENTCMD)export CUSTOM_SONGS_FORMAT_VERSION=1 && $(MAKE) --no-print-directory -C $(AAS) -f Makefile conv2aas 
	@$(PYTHON) -B $(BN_TOOLS)/butano_assets_tool.py --grit="$(BN_GRIT)" --mmutil="$(BN_MMUTIL)" \
			--dmg_audio="$(DMGAUDIO)" --graphics="$(GRAPHICS)" --build=$(BUILD) --audio="" #--audio="$(AUDIO)" 
	@find $(AUDIO)/sources -name "*.wav" -exec bash -c 'BASENAME=$$(basename "$$1"); $(SOX) "$$1" -S -b 8 -c 1 -r $(SAMPLE_RATE) $(AUDIO)/$${BASENAME%.*}.wav' sh {} \;
	@$(CONV2AAS) $(AUDIO)
	@rm audio_data.bin
	@rm audio_data.h
	@mv audio_data.s $(_SRC)/audio_data.s
	$(SILENTCMD)$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

#---------------------------------------------------------------------------------------------------------------------
clean:
	@echo clean ...
	@rm -fr $(BUILD) $(TARGET).elf $(TARGET).elf.* $(TARGET).gba $(USERBUILD)
	$(SILENTCMD)$(MAKE) --no-print-directory -C $(AAS) -f Makefile clean
