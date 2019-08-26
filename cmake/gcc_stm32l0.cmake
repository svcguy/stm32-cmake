SET(CMAKE_C_FLAGS "-mthumb -fno-builtin -mcpu=cortex-m0 -Wall -std=gnu99 -ffunction-sections -fdata-sections -fomit-frame-pointer -mabi=aapcs -fno-unroll-loops -ffast-math -ftree-vectorize" CACHE INTERNAL "c compiler flags")
SET(CMAKE_CXX_FLAGS "-mthumb -fno-builtin -mcpu=cortex-m0 -Wall -std=c++11 -ffunction-sections -fdata-sections -fomit-frame-pointer -mabi=aapcs -fno-unroll-loops -ffast-math -ftree-vectorize" CACHE INTERNAL "cxx compiler flags")
SET(CMAKE_ASM_FLAGS "-mthumb -mcpu=cortex-m0 -x assembler-with-cpp" CACHE INTERNAL "asm compiler flags")

SET(CMAKE_EXE_LINKER_FLAGS "-Wl,--gc-sections -mthumb -specs=nano.specs -specs=nosys.specs -mcpu=cortex-m0 -mabi=aapcs" CACHE INTERNAL "executable linker flags")
SET(CMAKE_MODULE_LINKER_FLAGS "-mthumb -mcpu=cortex-m0 -mabi=aapcs" CACHE INTERNAL "module linker flags")
SET(CMAKE_SHARED_LINKER_FLAGS "-mthumb -mcpu=cortex-m0 -mabi=aapcs" CACHE INTERNAL "shared linker flags")

SET(STM32_CHIP_TYPES 011xx 021xx 031xx 041xx 051xx 052xx 053xx 061xx 062xx 063xx 071xx 072xx 073xx 081xx 082xx 083xx CACHE INTERNAL "stm32l0 chip types")
SET(STM32_CODES "011.[34]" "021.4" "031.[46]" "041.6" "051.[68]" "052.[68]" "053.[68]" "061.8" "062.8" "063.8" "071.[BZ]" "072.[BZ]" "073.[8BZ]" "081.Z" "082.[BZ]" "083.[8BZ]")

MACRO(STM32_GET_CHIP_TYPE CHIP CHIP_TYPE)
    STRING(REGEX REPLACE "^[sS][tT][mM]32[lL]((011.[34])|(021.4)|(031.[46])|(041.6)|(05[123].[68])|(06[123].8)|(07[123].[8BZ])|(08[123].[8BZ])).+$" "\\1" STM32_CODE ${CHIP})
    SET(INDEX 0)
    FOREACH(C_TYPE ${STM32_CHIP_TYPES})
        LIST(GET STM32_CODES ${INDEX} CHIP_TYPE_REGEXP)
        IF(STM32_CODE MATCHES ${CHIP_TYPE_REGEXP})
            SET(RESULT_TYPE ${C_TYPE})
        ENDIF()
        MATH(EXPR INDEX "${INDEX}+1")
    ENDFOREACH()
    SET(${CHIP_TYPE} ${RESULT_TYPE})
ENDMACRO()

MACRO(STM32_GET_CHIP_PARAMETERS CHIP FLASH_SIZE RAM_SIZE CCRAM_SIZE)
    STRING(REGEX REPLACE "^[sS][tT][mM]32[lL](0[12345678][123]).[3468BZ]" "\\1" STM32_CODE ${CHIP})
    STRING(REGEX REPLACE "^[sS][tT][mM]32[lL]0[12345678][123].([3468BZ])" "\\1" STM32_SIZE_CODE ${CHIP})

    IF(STM32_SIZE_CODE STREQUAL "3")
        SET(FLASH "8K")
    ELSEIF(STM32_SIZE_CODE STREQUAL "4")
        SET(FLASH "16K")
    ELSEIF(STM32_SIZE_CODE STREQUAL "6")
        SET(FLASH "32K")
    ELSEIF(STM32_SIZE_CODE STREQUAL "8")
        SET(FLASH "64K")
    ELSEIF(STM32_SIZE_CODE STREQUAL "B")
        SET(FLASH "128K")
    ELSEIF(STM32_SIZE_CODE STREQUAL "Z")
        SET(FLASH "192K")
    ENDIF()

    STM32_GET_CHIP_TYPE(${CHIP} TYPE)
    
    IF(${TYPE} STREQUAL 011xx)
        SET(RAM "2K")
    ELSEIF(${TYPE} STREQUAL 021xx)
        SET(RAM "2K")
    ELSEIF(${TYPE} STREQUAL 031xx)
        SET(RAM "8K")
    ELSEIF(${TYPE} STREQUAL 041xx)
        SET(RAM "8K")
    ELSEIF(${TYPE} STREQUAL 051xx)
        SET(RAM "8K")
    ELSEIF(${TYPE} STREQUAL 052xx)
        SET(RAM "8K")
    ELSEIF(${TYPE} STREQUAL 053xx)
        SET(RAM "8K")
    ELSEIF(${TYPE} STREQUAL 061xx)
        SET(RAM "8K")
    ELSEIF(${TYPE} STREQUAL 062xx)
        SET(RAM "8K")
    ELSEIF(${TYPE} STREQUAL 063xx)
        SET(RAM "8K")
    ELSEIF(${TYPE} STREQUAL 071xx)
        SET(RAM "20K")
    ELSEIF(${TYPE} STREQUAL 072xx)
        SET(RAM "20K")
    ELSEIF(${TYPE} STREQUAL 073xx)
        SET(RAM "20K")
    ELSEIF(${TYPE} STREQUAL 081xx)
        SET(RAM "20K")
    ELSEIF(${TYPE} STREQUAL 082xx)
        SET(RAM "20K")
    ELSEIF(${TYPE} STREQUAL 083xx)
        SET(RAM "20K")
    ENDIF()

    SET(${FLASH_SIZE} ${FLASH})
    SET(${RAM_SIZE} ${RAM})
    SET(${CCRAM_SIZE} "0K")
ENDMACRO()

FUNCTION(STM32_SET_CHIP_DEFINITIONS TARGET CHIP_TYPE)
    LIST(FIND STM32_CHIP_TYPES ${CHIP_TYPE} TYPE_INDEX)
    IF(TYPE_INDEX EQUAL -1)
        MESSAGE(FATAL_ERROR "Invalid/unsupported STM32L0 chip type: ${CHIP_TYPE}")
    ENDIF()
    GET_TARGET_PROPERTY(TARGET_DEFS ${TARGET} COMPILE_DEFINITIONS)
    IF(TARGET_DEFS)
        SET(TARGET_DEFS "STM32L0;STM32L${CHIP_TYPE};${TARGET_DEFS}")
    ELSE()
        SET(TARGET_DEFS "STM32L0;STM32L${CHIP_TYPE}")
    ENDIF()
    SET_TARGET_PROPERTIES(${TARGET} PROPERTIES COMPILE_DEFINITIONS "${TARGET_DEFS}")
ENDFUNCTION()
