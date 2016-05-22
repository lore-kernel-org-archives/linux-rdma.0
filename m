From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH, mstflint] Fix compiler warnings about set-but-not-used
 variables
Date: Sun, 22 May 2016 11:05:38 -0700
Message-ID: <5741F4F2.9080007@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adrian Chiris <adrianc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Recent gcc versions emit a warning if a variable is set but not used.
Suppress these warnings by removing dummy assignments to unused arguments.
Additionally, enable the compiler command-line option -Wno-unused-parameter
and remove the '(void)arg' statements that thereby became superfluous.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
---
 cmdif/tools_cif.c                            |   1 -
 cmdparser/my_getopt.c                        |   3 -
 common/compatibility.h                       |   7 +
 flint/Makefile.am                            |   2 +-
 flint/subcommands.cpp                        |   7 -
 mflash/Makefile.am                           |   2 +-
 mflash/mflash.c                              |  20 +-
 mlxconfig/Makefile.am                        |   2 +-
 mlxconfig/mlxcfg_param_lib.cpp               |  22 -
 mlxconfig/mlxcfg_param_lib.h                 |  15 +-
 mlxconfig/mlxcfg_ui.cpp                      |   2 +-
 mlxfwops/lib/Makefile.am                     |   2 +-
 mlxfwops/lib/aux_tlv_ops.cpp                 |   1 -
 mlxfwops/lib/flint_io.cpp                    |   9 +-
 mlxfwops/lib/fs2_ops.cpp                     |  33 +-
 mlxfwops/lib/fs3_ops.cpp                     |  24 +-
 mlxfwops/lib/fw_ops.cpp                      |  10 -
 mtcr_ul/Makefile.am                          |   2 +-
 mtcr_ul/mtcr_ib_ofed.c                       |   1 -
 mtcr_ul/mtcr_ib_res_mgt.c                    |  12 -
 mtcr_ul/mtcr_ul.c                            |  22 +-
 small_utils/mcra.c                           |   1 -
 tools_layouts/cibfw_layouts.c                | 249 --------
 tools_layouts/connectib_layouts.c            |  32 -
 tools_layouts/cx4fw_layouts.c                |  95 ---
 tools_layouts/register_access_open_layouts.c |  49 --
 tools_layouts/register_access_sib_layouts.c  |  97 ---
 tools_layouts/tools_open_layouts.c           | 895 ---------------------------
 28 files changed, 35 insertions(+), 1582 deletions(-)

diff --git a/cmdif/tools_cif.c b/cmdif/tools_cif.c
index c6afc68..d767ada 100644
--- a/cmdif/tools_cif.c
+++ b/cmdif/tools_cif.c
@@ -132,7 +132,6 @@ const char* tcif_err2str(MError rc) {
 MError tcif_cr_mbox_supported(mfile* dev)
 {
 #if defined(__FreeBSD__) || defined(UEFI_BUILD)
-    (void)dev;
     return ME_NOT_IMPLEMENTED;
 #else
     return tools_cmdif_is_cr_mbox_supported(dev);
diff --git a/cmdparser/my_getopt.c b/cmdparser/my_getopt.c
index be6281d..6e64b35 100755
--- a/cmdparser/my_getopt.c
+++ b/cmdparser/my_getopt.c
@@ -394,9 +394,6 @@
    /* Start processing options with ARGV-element 1 (since ARGV-element 0
       is the program name); the sequence of previously skipped
       non-option ARGV-elements is empty.  */
-   // avoid compiler warnings
-   (void) argc;
-   (void) argv;
    first_nonopt = last_nonopt = tools_optind;
 
    nextchar = NULL;
diff --git a/common/compatibility.h b/common/compatibility.h
index 8dc85e3..8f3b4d5 100644
--- a/common/compatibility.h
+++ b/common/compatibility.h
@@ -215,6 +215,13 @@
 #endif
 
 /*
+ * Windows (Microsoft C Compiler)
+ */
+#ifdef _MSC_VER
+#pragma warning (disable: 4100) // 'identifier' : unreferenced formal parameter
+#endif
+
+/*
  * Windows (CYGWIN)
  */
 #if defined(__CYGWIN32__)
diff --git a/flint/Makefile.am b/flint/Makefile.am
index d2cb8c5..74ac507 100755
--- a/flint/Makefile.am
+++ b/flint/Makefile.am
@@ -42,7 +42,7 @@ CMDIF_DIR   = $(top_srcdir)/cmdif
 AM_CPPFLAGS = -I$(top_srcdir) -I$(srcdir) -I$(MTCR_DIR) -I$(MFLASH_DIR) -I$(COMMON_DIR) \
            -I$(LAYOUTS_DIR) -I$(MFT_UTILS_DIR) -I$(MTCR_INC_DIR)
 
-mstflint_CXXFLAGS = -Wall -W -g -MP -MD -pipe -DEXTERNAL
+mstflint_CXXFLAGS = -Wall -Wextra -Wno-unused-parameter -g -MP -MD -pipe -DEXTERNAL
 bin_PROGRAMS = mstflint
 
 mstflint_SOURCES = flint.cpp flint.h subcommands.cpp subcommands.h\
diff --git a/flint/subcommands.cpp b/flint/subcommands.cpp
index 0bcc4ee..6d9e470 100644
--- a/flint/subcommands.cpp
+++ b/flint/subcommands.cpp
@@ -930,10 +930,6 @@ bool SubCommand::unzipDataFile (std::vector<u_int8_t> data, std::vector<u_int8_t
     newData.resize(destLen + 1);
     return true;
 #else
-    // avoid warnings
-    (void) data;
-    (void) newData;
-    (void) sectionName;
     reportErr(true, FLINT_NO_ZLIB_ERROR);
     return false;
 #endif
@@ -966,7 +962,6 @@ bool SubCommand::dumpFile(const char* confFile, std::vector<u_int8_t>& data, con
 
 bool SubCommand::checkGuidsFlags (u_int16_t devType, u_int8_t fwType,
                             bool guidsSpecified, bool macsSpecified, bool uidSpecified, bool ibDev, bool ethDev) {
-    (void)ibDev;
     if (guidsSpecified || macsSpecified || uidSpecified) {
         if (uidSpecified && fwType != FIT_FS3) {
             reportErr(true, "-uid flag is applicable only for FS3 FW Only.\n");
@@ -4282,8 +4277,6 @@ FlintStatus TimeStampSubCommand::executeCommand()
     if (preFwOps() == FLINT_FAILED) {
         return FLINT_FAILED;
     }
-    _ops = _flintParams.device_specified ? _fwOps : _imgOps;
-    (void)_ops;
     switch (_operation) {
     case TimeStampSubCommand::TS_Set:
         rc = setTs();
diff --git a/mflash/Makefile.am b/mflash/Makefile.am
index c45351a..12da860 100644
--- a/mflash/Makefile.am
+++ b/mflash/Makefile.am
@@ -34,7 +34,7 @@
 AM_CPPFLAGS= -I. -I$(top_srcdir)/include/mtcr_ul -I$(top_srcdir)/common -I$(top_srcdir)/tools_layouts -I$(top_srcdir)/reg_access \
           -I$(top_srcdir)/cmdif -I$(top_srcdir)/tools_res_mgmt
 
-AM_CFLAGS = -MD -pipe -Wall -W -DMST_UL -g ${MFLASH_INBAND_FLAG}
+AM_CFLAGS = -MD -pipe -Wall -Wextra -Wno-unused-parameter -DMST_UL -g ${MFLASH_INBAND_FLAG}
 
 noinst_LIBRARIES = libmflash.a
 
diff --git a/mflash/mflash.c b/mflash/mflash.c
index 1c37b35..dbfb870 100644
--- a/mflash/mflash.c
+++ b/mflash/mflash.c
@@ -102,9 +102,7 @@
 #include <windows.h>
 #define TIMER_INIT()\
     SYSTEMTIME _start, _end;\
-    int _diff_in_sec, _diff_in_ms;\
-    (void)_diff_in_sec;\
-    (void)_diff_in_ms
+    int _diff_in_sec, _diff_in_ms;
 #define TIMER_START()\
     GetSystemTime(&_start)
 #define TIMER_STOP()\
@@ -1017,7 +1015,6 @@ enum CrConstans {
 int gw_wait_ready(mflash* mfl, const char* msg) {
     u_int32_t gw_cmd;
     u_int32_t cnt = 0;
-    (void)msg; // NOT USED FOR NOW
     do {
         // Timeout checks
         if (++cnt > FLASH_CMD_CNT) {
@@ -1034,7 +1031,6 @@ int gw_wait_ready(mflash* mfl, const char* msg) {
 
 
 int empty_reset          (mflash* mfl) {
-    (void)mfl; /* avoid compiler warning */
     return MFE_OK;
 }
 
@@ -1088,8 +1084,6 @@ enum CntxCrConstants{
 
 int empty_set_bank(mflash* mfl, u_int32_t bank) {
     // NULL function - No actual work here - in ConnectX the curr_bank is written in the command word.
-    (void)mfl; // Avoid Compiler warning
-    (void)bank;   // Avoid Compiler warning
     return MFE_OK;
 }
 
@@ -1415,7 +1409,6 @@ int spi_update_num_of_banks(mflash* mfl, int prev_num_of_flashes)
 
 
 int cntx_st_spi_reset          (mflash* mfl) {
-    (void)mfl;
     return MFE_OK;
 }
 
@@ -1826,7 +1819,6 @@ int cntx_flash_init_direct_access(mflash* mfl, flash_params_t* flash_params) {
 // InfiniScale 4 (IS4) functions:
 
 int is4_init_gpios(mflash* mfl) {
-    (void)mfl;
     return MFE_NOT_IMPLEMENTED;
 }
 
@@ -2107,11 +2099,6 @@ int sx_erase_sect(mflash* mfl, u_int32_t addr)
 
 int empty_get_status(mflash* mfl, u_int8_t op_type, u_int8_t* status)
 {
-    // Avoid warnings
-    (void)mfl;
-    (void)op_type;
-    (void)status;
-
     return MFE_NOT_SUPPORTED_OPERATION;
 }
 
@@ -2569,7 +2556,7 @@ void     mf_close       (mflash* mfl) {
     }
 
     if (mfl->f_set_bank) {
-        (void)set_bank(mfl, 0);
+        set_bank(mfl, 0);
     }
     // we release if we have writer_lock or not doesnt matter on close ...
     release_semaphore(mfl, 1);
@@ -3034,8 +3021,6 @@ int mf_enable_hw_access(mflash* mfl, u_int64_t key)
     rc = tcif_hw_access(mfl->mf, key, 0 /* Unlock */);
     return (rc == ME_CMDIF_UNKN_TLV) ? MFE_MISMATCH_KEY : MError2MfError(rc);
 #else
-    (void)mfl;
-    (void)key;
     return MFE_NOT_SUPPORTED_OPERATION;
 #endif
 }
@@ -3049,7 +3034,6 @@ int mf_disable_hw_access(mflash* mfl)
     rc = tcif_hw_access(mfl->mf, 0, 1 /* Lock */);
     return (rc == ME_CMDIF_UNKN_TLV) ? MFE_MISMATCH_KEY : MError2MfError(rc);
 #else
-    (void)mfl;
     return MFE_NOT_SUPPORTED_OPERATION;
 #endif
 }
diff --git a/mlxconfig/Makefile.am b/mlxconfig/Makefile.am
index c9189aa..11865a4 100755
--- a/mlxconfig/Makefile.am
+++ b/mlxconfig/Makefile.am
@@ -45,7 +45,7 @@ CMDIF_DIR = $(USER_DIR)/cmdif
 AM_CPPFLAGS = -I. -I$(USER_DIR) -I$(top_srcdir)/include/mtcr_ul -I$(MTCR_DIR) -I$(COMMON_DIR) $(WIN64_INC)\
            -I $(LAYOUTS_DIR) -I $(UTILS_DIR) -I$(DEV_MGT_DIR) -I$(CMDIF_DIR)
 
-AM_CXXFLAGS = -Wall -W -g -MP -MD -pipe
+AM_CXXFLAGS = -Wall -Wextra -Wno-unused-parameter -g -MP -MD -pipe
 bin_PROGRAMS = mstconfig
 
 mstconfig_LDADD = $(CMDIF_DIR)/libcmdif.a ../reg_access/libreg_access.a $(LAYOUTS_LIB) $(MTCR_DIR)/libmtcr_ul.a $(MLNXOS_PPC_LIBS) $(LIBSTD_CPP) $(UTILS_LIB) $(DEV_MGT_DIR)/libdev_mgt.a -ldl
diff --git a/mlxconfig/mlxcfg_param_lib.cpp b/mlxconfig/mlxcfg_param_lib.cpp
index b247ea0..ae82423 100644
--- a/mlxconfig/mlxcfg_param_lib.cpp
+++ b/mlxconfig/mlxcfg_param_lib.cpp
@@ -433,7 +433,6 @@ bool CfgParams::checkCfg(mfile* mf)
 bool CfgParams::softLimitCheck(mfile* mf)
 {
     // by default not implemented
-    (void)mf;
     return true;
 }
 
@@ -495,7 +494,6 @@ u_int32_t BootSettingsExtParams4thGen::getParam(mlxCfgParam paramType)
 
 bool BootSettingsExtParams4thGen::cfgSupported(mfile* mf, mlxCfgParam param)
 {
-    (void)param;
     struct tools_open_query_def_params_global params;
     int rc;
     rc = getDefaultParams4thGen(mf, &params);
@@ -621,7 +619,6 @@ u_int32_t BootSettingsExtParams5thGen::getBootSettingsExtCapabilitiesTlvTypeBe()
 bool BootSettingsExtParams5thGen::cfgSupported(mfile* mf, mlxCfgParam param)
 {
     MError rc;
-    (void)param;
     u_int8_t tlvCapBuff[TOOLS_OPEN_OPTION_ROM_CAPABILITY_SIZE] = {0};
     struct tools_open_option_rom_capability optionRomCapabilitesTlv;
     bool suppRead, suppWrite;
@@ -754,8 +751,6 @@ bool SriovParams4thGen::hardLimitCheck()
 
 bool SriovParams4thGen::cfgSupported(mfile* mf, mlxCfgParam param)
 {
-    (void)mf;
-    (void)param;
     return _devCapVec & SRIOV_MASK;
 }
 
@@ -941,8 +936,6 @@ u_int32_t WolParams4thGen::getDefaultParam(mlxCfgParam paramType)
 
 bool WolParams4thGen::cfgSupported(mfile* mf, mlxCfgParam param)
 {
-    (void)mf;
-    (void)param;
     return ((_devCapVec & WOL_P1_MASK) && _port == 1) || ((_devCapVec & WOL_P2_MASK) && _port == 2 );
 }
 
@@ -1048,7 +1041,6 @@ u_int32_t WolParams5thGen::getDefaultParam(mlxCfgParam paramType)
 bool WolParams5thGen::cfgSupported(mfile* mf, mlxCfgParam param)
 {
     MError rc;
-    (void)param;
     bool suppRead, suppWrite;
     rc = nvqcCom5thGen(mf, getTlvTypeBe(), suppRead, suppWrite);
     if (rc) {
@@ -1157,8 +1149,6 @@ void BarSzParams::setParams(u_int32_t logBarSz)
 
 bool BarSzParams4thGen::cfgSupported(mfile* mf, mlxCfgParam param)
 {
-    (void)mf;
-    (void)param;
     return _devCapVec & BAR_SZ_MASK ;
 }
 
@@ -1390,8 +1380,6 @@ u_int32_t VpiParams4thGen::getDefaultParam(mlxCfgParam paramType)
 
 bool VpiParams4thGen::cfgSupported(mfile* mf, mlxCfgParam param)
 {
-    (void)mf;
-    (void)param;
     return ((_devCapVec & VPI_P1_MASK) && _port == 1) || ((_devCapVec & VPI_P2_MASK) && _port == 2);
 }
 
@@ -1489,7 +1477,6 @@ bool VpiParams5thGen::cfgSupported(mfile* mf, mlxCfgParam param)
     // get mtcr functions for this device (physical)
     // compare with port
     // send nvqc and check
-    (void)param;
     MError rc;
     bool suppRead, suppWrite;
     rc = nvqcCom5thGen(mf, getTlvTypeBe(), suppRead, suppWrite);
@@ -2013,7 +2000,6 @@ u_int32_t PciParams5thGen::calcTotalBar()
 
 bool PciParams5thGen::softLimitCheck(mfile* mf)
 {
-    (void)mf;
     if (_maxTotalBarValid == 1 && _maxTotalBar != 0 && _sriovEn == 1) {
         if(_userSpecifiedSRIOV || _userSpecifiedPfLogBarSize || _userSpecifiedVfLogBarSize){
             if(_fppEn == 1){
@@ -2078,7 +2064,6 @@ bool PciParams5thGen::softLimitCheck(mfile* mf)
 bool TptParams5thGen::cfgSupported(mfile* mf, mlxCfgParam param)
 {
     MError rc;
-    (void)param;
     bool suppRead, suppWrite;
     rc = nvqcCom5thGen(mf, getTptCapabilitiesTlvTypeBe(), suppRead, suppWrite);
     if (rc) {
@@ -2271,7 +2256,6 @@ bool TptParams5thGen::hardLimitCheck()
 
 bool InfinibandBootSettingsParams4thGen::cfgSupported(mfile* mf, mlxCfgParam param)
 {
-    (void)param;
     struct tools_open_query_def_params_per_port portParams;
     int rc;
     rc = getDefaultParams4thGen(mf, _port, &portParams);
@@ -2393,7 +2377,6 @@ bool InfinibandBootSettingsParams4thGen::hardLimitCheck()
 bool IBDCParams5thGen::cfgSupported(mfile* mf, mlxCfgParam param)
 {
     MError rc;
-    (void)param;
     bool suppRead, suppWrite;
     rc = nvqcCom5thGen(mf, getDcCapabilitiesTlvTypeBe(), suppRead, suppWrite);
     if (rc) {
@@ -2562,7 +2545,6 @@ void IBDCParams5thGen::updateClassDefaultAttrFromTlv(void* tlv)
 bool RoCENextProtocolParams5thGen::cfgSupported(mfile* mf, mlxCfgParam param)
 {
     MError rc;
-    (void)param;
     bool suppRead, suppWrite;
     rc = nvqcCom5thGen(mf, getTlvTypeBe(), suppRead, suppWrite);
     if (rc) {
@@ -2673,7 +2655,6 @@ void RoCENextProtocolParams5thGen::updateClassDefaultAttrFromTlv(void* tlv)
 bool RoCECCParams5thGen::cfgSupported(mfile* mf, mlxCfgParam param)
 {
     MError rc;
-    (void)param;
     bool suppRead, suppWrite;
     rc = nvqcCom5thGen(mf, getTlvTypeBe(), suppRead, suppWrite);
     if (rc) {
@@ -2802,7 +2783,6 @@ void RoCECCParams5thGen::updateClassDefaultAttrFromTlv(void* tlv)
 bool RoCECCEcnParams5thGen::cfgSupported(mfile* mf, mlxCfgParam param)
 {
     MError rc;
-    (void)param;
     bool suppRead, suppWrite;
     rc = nvqcCom5thGen(mf, getTlvTypeBe(), suppRead, suppWrite);
     if (rc) {
@@ -3389,7 +3369,6 @@ void RoCECCEcnParams5thGen::updateClassDefaultAttrFromTlv(void* tlv)
 
 bool PrebootBootSettingsParams4thGen::cfgSupported(mfile* mf, mlxCfgParam param)
 {
-    (void)param;
     struct tools_open_query_def_params_per_port portParams;
     int rc;
     rc = getDefaultParams4thGen(mf, _port, &portParams);
@@ -3581,7 +3560,6 @@ bool PrebootBootSettingsParams4thGen::hardLimitCheck()
 bool ExternalPort5thGen::cfgSupported(mfile* mf, mlxCfgParam param)
 {
     MError rc;
-    (void)param;
     bool suppRead, suppWrite;
     rc = nvqcCom5thGen(mf, getTlvTypeBe(), suppRead, suppWrite);
     if (rc) {
diff --git a/mlxconfig/mlxcfg_param_lib.h b/mlxconfig/mlxcfg_param_lib.h
index dbc87bc..09b8766 100644
--- a/mlxconfig/mlxcfg_param_lib.h
+++ b/mlxconfig/mlxcfg_param_lib.h
@@ -264,9 +264,18 @@ protected:
     int getDefaultParams4thGen(mfile* mf, struct tools_open_query_def_params_global* global_params);
     int getDefaultParams4thGen(mfile* mf, int port, struct tools_open_query_def_params_per_port* port_params);
 
-    virtual void updateTlvFromClassAttr(void* tlv) {(void)tlv; throw std::logic_error("Function Not Implemented");}
-    virtual void updateClassAttrFromTlv(void* tlv) {(void)tlv; throw std::logic_error("Function Not Implemented");}
-    virtual void updateClassDefaultAttrFromTlv(void* tlv) {(void)tlv; throw std::logic_error("Function Not Implemented");}
+    virtual void updateTlvFromClassAttr(void* tlv)
+    {
+        throw std::logic_error("Function Not Implemented");
+    }
+    virtual void updateClassAttrFromTlv(void* tlv)
+    {
+        throw std::logic_error("Function Not Implemented");
+    }
+    virtual void updateClassDefaultAttrFromTlv(void* tlv)
+    {
+        throw std::logic_error("Function Not Implemented");
+    }
 
     u_int64_t _devCapVec; // relevant for 4th gen devices
     bool _updated; // set true on get and false on set
diff --git a/mlxconfig/mlxcfg_ui.cpp b/mlxconfig/mlxcfg_ui.cpp
index 1e86d53..451cf84 100644
--- a/mlxconfig/mlxcfg_ui.cpp
+++ b/mlxconfig/mlxcfg_ui.cpp
@@ -326,7 +326,7 @@ mlxCfgStatus MlxCfg::queryDevCfg(const char* dev,const char* pci, int devIndex,
     bool failedToGetCfg = false;
     bool nothingSupported = true;
     bool isParamsDiffer = false;
-    (void) pci;
+
     // print opening
     printf("\nDevice #%d:\n", devIndex);
     printf("----------\n\n");
diff --git a/mlxfwops/lib/Makefile.am b/mlxfwops/lib/Makefile.am
index c309507..8df3185 100755
--- a/mlxfwops/lib/Makefile.am
+++ b/mlxfwops/lib/Makefile.am
@@ -45,7 +45,7 @@ AM_CPPFLAGS = -I$(srcdir) -I$(MTCR_INC_DIR) -I$(MFLASH_DIR) -I$(top_srcdir)/ext_
 
 MLXFWOPS_VERSION = 1
 
-AM_CXXFLAGS = -Wall -W -g -MP -MD -pipe -DNO_MFA_SUPPORT
+AM_CXXFLAGS = -Wall -Wextra -Wno-unused-parameter -g -MP -MD -pipe -DNO_MFA_SUPPORT
 
 if ENABLE_OPENSSL
 else
diff --git a/mlxfwops/lib/aux_tlv_ops.cpp b/mlxfwops/lib/aux_tlv_ops.cpp
index a580c78..7ed0978 100644
--- a/mlxfwops/lib/aux_tlv_ops.cpp
+++ b/mlxfwops/lib/aux_tlv_ops.cpp
@@ -433,7 +433,6 @@ Tlv_Status_t ImageTimeStamp::setTimeStamp(struct tools_open_ts_entry& timestamp,
 
 Tlv_Status_t ImageTimeStamp::queryTimeStamp(struct tools_open_ts_entry& timestamp, struct tools_open_fw_version& fwVer, bool queryRunning)
 {
-    (void)queryRunning;
     aux_tlv tsTlv;
     struct tools_open_timestamp tsData;
     memset(&tsTlv, 0, sizeof(tsTlv));
diff --git a/mlxfwops/lib/flint_io.cpp b/mlxfwops/lib/flint_io.cpp
index 3ed215e..329b4ed 100755
--- a/mlxfwops/lib/flint_io.cpp
+++ b/mlxfwops/lib/flint_io.cpp
@@ -67,7 +67,6 @@ bool FImage::open(const char *fname, bool read_only, bool advErr)
     int                r_cnt;
     FILE              *fh;
 
-    (void)read_only;  // FImage can be opened only for read so we ignore compiler warnings
     _advErrors = advErr;
 
     fh = fopen(fname, "rb");
@@ -274,9 +273,9 @@ bool Flash::open(const char *device, bool force_lock, bool read_only, int num_of
 {
     // Open device
     int rc;
+
     _advErrors = advErr;
     _ignore_cache_replacement = ignore_cashe_replacement ? true : false;
-    (void)read_only; // not used , avoid compiler warnings TODO: remove this var from function def
     rc = mf_open_adv(&_mfl, device, num_of_banks, flash_params, ignore_cashe_replacement, cx3_fw_access);
     //printf("device: %s , forceLock: %s , read only: %s, num of banks: %d, flash params is null: %s, ocr: %d, rc: %d\n",
     //		device, force_lock? "true":"false", read_only?"true":"false", num_of_banks, flash_params? "no":"yes", ignore_cashe_replacement, rc);
@@ -419,22 +418,16 @@ bool Flash::write_phy(u_int32_t phy_addr, u_int32_t data)
 
 bool Flash::write_phy(u_int32_t phy_addr, void* data, int cnt, bool noerase)
 {
-    // Avoid warning
-    (void)noerase;
     NATIVE_PHY_ADDR_FUNC(write, (phy_addr, data, cnt));
 }
 
 bool Flash::read_modify_write_phy(u_int32_t phy_addr, void* data, int cnt, bool noerase)
 {
-    // Avoid warning
-    (void)noerase;
     NATIVE_PHY_ADDR_FUNC(write_with_erase, (phy_addr, data, cnt));
 }
 
 bool Flash::read_modify_write(u_int32_t phy_addr, void* data, int cnt, bool noerase)
 {
-    // Avoid warning
-    (void)noerase;
     return write_with_erase(phy_addr, data, cnt);
 }
 
diff --git a/mlxfwops/lib/fs2_ops.cpp b/mlxfwops/lib/fs2_ops.cpp
index 785fa00..14ad15f 100644
--- a/mlxfwops/lib/fs2_ops.cpp
+++ b/mlxfwops/lib/fs2_ops.cpp
@@ -575,9 +575,6 @@ bool Fs2Operations::Fs2Verify(VerifyCallBack verifyCallBackFunc, bool is_striped
 }
 bool Fs2Operations::FwVerify(VerifyCallBack verifyCallBackFunc, bool isStripedImage, bool showItoc)
 {
-    // avoid compiler warrning (showItoc is not used in fs2)
-    (void)showItoc;
-
     initSectToRead(FULL_VERIFY);
     if (!Fs2Verify(verifyCallBackFunc, isStripedImage)) {
         // empty the initSectToRead
@@ -900,10 +897,6 @@ bool Fs2Operations::Fs2FailSafeBurn(Fs2Operations &imageOps,
                                   bool      allow_nofs,
                                   const char* pre_message,
                                   ProgressCallBack progressFunc) {
-    //we do not use pre_message, avoid warrning
-	//TODO: remove pre_message from function definition
-    (void)pre_message;
-
     Flash  *f = (Flash*)(this->_ioAccess);
     FImage *fim = (FImage*)(imageOps._ioAccess);
 
@@ -1503,17 +1496,11 @@ bool Fs2Operations::FwReadRom(std::vector<u_int8_t>& romSect)
 
 bool Fs2Operations::FwSetMFG(fs3_uid_t baseGuid, PrintCallBack callBackFunc)
 {
-    // avoid compiler warrnings
-    (void)baseGuid;
-    (void)callBackFunc;
     return errmsg("This command is not supported for FS2 FW image.");
 }
 
 bool Fs2Operations::FwSetMFG(guid_t baseGuid, PrintCallBack callBackFunc)
 {
-    // avoid compiler warrnings
-    (void)baseGuid;
-    (void)callBackFunc;
     return errmsg("This command is not supported for FS2 FW image.");
 }
 
@@ -1539,7 +1526,6 @@ bool Fs2Operations::FwGetSection (u_int32_t sectType, std::vector<u_int8_t>& sec
 
 bool Fs2Operations::ModifyVSDSection(const char *vsd, ProgressCallBack callBackFunc)
 {
-	(void)callBackFunc; /* avoid compiler warning*/
     u_int32_t length = _fwImgInfo.lastImageAddr;
     vector<u_int8_t> data(length);
 
@@ -1737,10 +1723,8 @@ bool Fs2Operations::Fs2SetGuidsForBlank(sg_params_t& sgParam)
 
 bool Fs2Operations::Fs2SetGuids(sg_params_t& sgParam, PrintCallBack callBackFunc, ProgressCallBack progressFunc)
 {
-    // avoid compiler warrnings
-    (void)callBackFunc;
-    //
     bool ib_dev, eth_dev;
+
     // Get the FW types
     SetDevFlags(_fwImgInfo.ext_info.chip_type, _fwImgInfo.ext_info.dev_type, FIT_FS2, ib_dev, eth_dev);
     guid_t* old_guids = _fwImgInfo.imageOk ? _fs2ImgInfo.ext_info.guids : (guid_t*)NULL;
@@ -1766,10 +1750,6 @@ bool Fs2Operations::Fs2SetGuids(sg_params_t& sgParam, PrintCallBack callBackFunc
 bool Fs2Operations::FwSetGuids(sg_params_t& sgParam, PrintCallBack callBackFunc,
         ProgressCallBack progressFunc)
 {
-	/* avoid annoying mingw warnings*/
-	(void)callBackFunc;
-	(void)progressFunc;
-
     if (!Fs2IntQuery(true, sgParam.stripedImage)) {
         return false;
     }
@@ -1928,9 +1908,6 @@ bool Fs2Operations::FwDeleteRom(bool ignoreProdIdCheck, ProgressCallBack progres
 
 bool Fs2Operations::FwSetVSD(char* vsdStr, ProgressCallBack progressFunc, PrintCallBack printFunc)
 {
-    // avoid compiler warrnings
-    (void)printFunc;
-    //
     if (!Fs2IntQuery()) {
         return false;
     }
@@ -1955,16 +1932,11 @@ bool Fs2Operations::FwSetVSD(char* vsdStr, ProgressCallBack progressFunc, PrintC
 
 bool Fs2Operations::FwSetVPD(char* vpdFileStr, PrintCallBack callBackFunc)
 {
-    // avoid compiler warrnings
-    (void)vpdFileStr;
-    (void)callBackFunc;
     return errmsg("Setting VPD is not supported in FS2 image format.");
 }
 
 bool Fs2Operations::FwSetAccessKey(hw_key_t userKey, ProgressCallBack progressFunc)
 {
-	/*avoid compiler warning*/
-	(void)progressFunc;
     if (!Fs2IntQuery()) {
         return false;
     }
@@ -2045,8 +2017,6 @@ bool Fs2Operations::FwResetNvData()
 
 bool Fs2Operations::FwShiftDevData(PrintCallBack progressFunc)
 {
-    // avoid compiler warrnings
-    (void)progressFunc;
     return errmsg("Shifting device data sections is not supported in FS2 image format.");
 }
 
@@ -2061,7 +2031,6 @@ const char* Fs2Operations::FwGetResetRecommandationStr()
 bool Fs2Operations::FwCalcMD5(u_int8_t md5sum[16])
 {
 #if defined(UEFI_BUILD) || defined(NO_OPEN_SSL)
-    (void)md5sum;
     return errmsg("Operation not supported");
 #else
     // no support for striped image ATM
diff --git a/mlxfwops/lib/fs3_ops.cpp b/mlxfwops/lib/fs3_ops.cpp
index 344279a..efa4f15 100644
--- a/mlxfwops/lib/fs3_ops.cpp
+++ b/mlxfwops/lib/fs3_ops.cpp
@@ -237,7 +237,6 @@ bool Fs3Operations::GetImageInfo(u_int8_t *buff)
 
     // TODO: adrianc: use the version fields once they are available in tools layouts
     GET_IMAGE_INFO_VERSION(buff, IIMajor, IIMinor);
-    (void)IIMinor;
     if (!CHECK_IMAGE_INFO_VERSION(IIMajor)) {
         return errmsg(MLXFW_UNKNOWN_SECT_VER_ERR, "Unknown IMAGE_INFO format version (%d.%d).", IIMajor, IIMinor);
     }
@@ -501,9 +500,6 @@ bool Fs3Operations::VerifyTOC(u_int32_t dtoc_addr, bool& bad_signature, VerifyCa
 
 
 bool Fs3Operations::FwVerify(VerifyCallBack verifyCallBackFunc, bool isStripedImage, bool showItoc) {
-    //dummy assignment to avoid compiler warrning (isStripedImage is not used in fs3)
-    (void)isStripedImage;
-
     struct QueryOptions queryOptions;
     queryOptions.readRom = true;
     queryOptions.quickQuery = false;
@@ -684,8 +680,6 @@ bool Fs3Operations::getRunningFwVersion()
 bool Fs3Operations::FwQuery(fw_info_t *fwInfo, bool readRom, bool isStripedImage)
 {
     //isStripedImage flag is not needed in FS3 image format
-    // Avoid warning - no striped image in FS3
-    (void)isStripedImage;
     if (!Fs3IntQuery(readRom)) {
         return false;
     }
@@ -1208,9 +1202,6 @@ bool Fs3Operations::FwBurnAdvanced(FwOperations *imageOps, ExtBurnParams& burnPa
 
 bool Fs3Operations::FwBurnBlock(FwOperations *imageOps, ProgressCallBack progressFunc)
 {
-    // Avoid Warning!
-    (void)imageOps;
-    (void)progressFunc;
     return errmsg("FwBurnBlock is not supported anymore in FS3 image.");
 }
 
@@ -1256,7 +1247,6 @@ bool Fs3Operations::FwReadRom(std::vector<u_int8_t>& romSect)
 
 bool Fs3Operations::FwGetSection (u_int32_t sectType, std::vector<u_int8_t>& sectInfo, bool stripedImage)
 {
-    (void) stripedImage; // unused for FS3
     //FwGetSection only supports retrieving FS3_DBG_FW_INI section atm.
     if (sectType != FS3_DBG_FW_INI) {
         return errmsg("Unsupported section type.");
@@ -1312,9 +1302,8 @@ bool Fs3Operations::FwSetMFG(guid_t baseGuid, PrintCallBack callBackFunc)
 bool Fs3Operations::FwSetGuids(sg_params_t& sgParam, PrintCallBack callBackFunc, ProgressCallBack progressFunc)
 {
     fs3_uid_t usrGuid;
+
     memset(&usrGuid, 0, sizeof(usrGuid));
-    // Avoid Warning because there is no need for progressFunc
-    (void)progressFunc;
     if (sgParam.userGuids.empty()) {
         return errmsg("Base GUID not found.");
     }
@@ -1650,7 +1639,7 @@ bool Fs3Operations::Fs3UpdateMfgUidsSection(struct toc_info *curr_toc, std::vect
 {
     struct cibfw_mfg_info cib_mfg_info;
     struct cx4fw_mfg_info cx4_mfg_info;
-    (void)curr_toc;
+
     cibfw_mfg_info_unpack(&cib_mfg_info, (u_int8_t*)&section_data[0]);
 
     if (CHECK_MFG_OLD_FORMAT(cib_mfg_info)) {
@@ -1742,7 +1731,7 @@ bool Fs3Operations::Fs3UpdateUidsSection(struct toc_info *curr_toc, std::vector<
 {
     struct cibfw_device_info cib_dev_info;
     struct cx4fw_device_info cx4_dev_info;
-    (void)curr_toc;
+
     cibfw_device_info_unpack(&cib_dev_info, (u_int8_t*)&section_data[0]);
 
     if (CHECK_DEV_INFO_OLD_FORMAT(cib_dev_info)) {
@@ -1771,7 +1760,7 @@ bool Fs3Operations::Fs3UpdateVsdSection(struct toc_info *curr_toc, std::vector<u
         std::vector<u_int8_t>  &newSectionData)
 {
     struct cibfw_device_info dev_info;
-    (void)curr_toc;
+
     cibfw_device_info_unpack(&dev_info, (u_int8_t*)&section_data[0]);
     memset(dev_info.vsd, 0, sizeof(dev_info.vsd));
     strncpy(dev_info.vsd, user_vsd, TOOLS_ARR_SZ(dev_info.vsd) - 1);
@@ -1975,8 +1964,6 @@ bool  Fs3Operations::Fs3UpdateSection(void *new_info, fs3_section_t sect_type, b
 
 bool Fs3Operations::FwSetVSD(char* vsdStr, ProgressCallBack progressFunc, PrintCallBack printFunc)
 {
-    // Avoid warning
-    (void)progressFunc;
     if (!vsdStr) {
         return errmsg("Please specify a valid VSD string.");
     }
@@ -1997,8 +1984,6 @@ bool Fs3Operations::FwSetVSD(char* vsdStr, ProgressCallBack progressFunc, PrintC
 
 bool Fs3Operations::FwSetAccessKey(hw_key_t userKey, ProgressCallBack progressFunc)
 {
-    (void)userKey;
-    (void)progressFunc;
     return errmsg("Set access key not supported.");
 }
 
@@ -2566,7 +2551,6 @@ bool Fs3Operations::FixCX4WriteProtection(bool justCheck)
 bool Fs3Operations::FwCalcMD5(u_int8_t md5sum[16])
 {
 #if defined(UEFI_BUILD) || defined(NO_OPEN_SSL)
-    (void)md5sum;
     return errmsg("Operation not supported");
 #else
     if (!Fs3IntQuery(true, false)) {
diff --git a/mlxfwops/lib/fw_ops.cpp b/mlxfwops/lib/fw_ops.cpp
index ca2dab6..41de4dd 100644
--- a/mlxfwops/lib/fw_ops.cpp
+++ b/mlxfwops/lib/fw_ops.cpp
@@ -1049,10 +1049,6 @@ void FwOperations::WriteToErrBuff(char* errBuff, const char* errStr, int size)
 
 bool FwOperations::UpdateImgCache(u_int8_t *buff, u_int32_t addr, u_int32_t size)
 {
-    //avoid compiler warrnings
-    (void)buff;
-    (void)addr;
-    (void)size;
     //in FS2 we dont have ImgCache, just in FS3 so we define a defult behaviour.
     return true;
 }
@@ -1425,7 +1421,6 @@ bool FwOperations::ReadImageFile(const char *fimage, u_int8_t *&file_data, int &
 
 void FwOperations::SetDevFlags(chip_type_t chipType, u_int32_t devType, fw_img_type_t fwType, bool &ibDev, bool &ethDev) {
 
-    (void)devType;
     if (chipType == CT_IS4) {
         ibDev =  true;
         ethDev = false;
@@ -1591,8 +1586,6 @@ const char* FwOperations::expRomType2Str(u_int16_t type)
 
 bool FwOperations::FwSetTimeStamp(struct tools_open_ts_entry& timestamp, struct tools_open_fw_version& fwVer)
 {
-    (void)timestamp;
-    (void)fwVer;
     return errmsg("Operation not supported.");
 }
 
@@ -1603,8 +1596,5 @@ bool FwOperations::FwResetTimeStamp()
 
 bool FwOperations::FwQueryTimeStamp(struct tools_open_ts_entry& timestamp, struct tools_open_fw_version& fwVer, bool queryRunning)
 {
-    (void)timestamp;
-    (void)fwVer;
-    (void)queryRunning;
     return errmsg("Operation not supported.");
 }
diff --git a/mtcr_ul/Makefile.am b/mtcr_ul/Makefile.am
index 007c865..15e91a4 100644
--- a/mtcr_ul/Makefile.am
+++ b/mtcr_ul/Makefile.am
@@ -41,7 +41,7 @@ libmtcr_ul_a_SOURCES = mtcr_ul.c mtcr_ib.h  mtcr_int_defs.h\
 			mtcr_ul_icmd_cif.c mtcr_icmd_cif.h\
 			packets_common.c packets_common.h\
 			packets_layout.c packets_layout.h
-libmtcr_ul_a_CFLAGS = -W -Wall -g -MP -MD -fPIC -DMTCR_API="" -DMST_UL
+libmtcr_ul_a_CFLAGS = -Wall -Wextra -Wno-unused-parameter -fno-strict-aliasing -g -MP -MD -fPIC -DMTCR_API="" -DMST_UL
 
 if ENABLE_INBAND
 libmtcr_ul_a_SOURCES += mtcr_ib_ofed.c
diff --git a/mtcr_ul/mtcr_ib_ofed.c b/mtcr_ul/mtcr_ib_ofed.c
index b49acbf..c66d281 100644
--- a/mtcr_ul/mtcr_ib_ofed.c
+++ b/mtcr_ul/mtcr_ib_ofed.c
@@ -432,7 +432,6 @@ int process_dynamic_linking(ibvs_mad *ivm, int mad_init)
     char* libs[] = {"libibmad.so.5"};
 
     u_int32_t i;
-    (void)mad_init;
     for (i = 0; i < sizeof(libs)/sizeof(libs[0]) ; i++) {
         ivm->dl_handle = dlopen (libs[i], RTLD_LAZY);
         if (ivm->dl_handle) {
diff --git a/mtcr_ul/mtcr_ib_res_mgt.c b/mtcr_ul/mtcr_ib_res_mgt.c
index 4d316dd..8c21cda 100644
--- a/mtcr_ul/mtcr_ib_res_mgt.c
+++ b/mtcr_ul/mtcr_ib_res_mgt.c
@@ -70,11 +70,6 @@ struct semaphore_lock_cmd {
 
 void semaphore_lock_cmd_pack(const struct semaphore_lock_cmd *ptr_struct, u_int8_t* ptr_buff){
     u_int32_t offset;
-    int i=0;
-    (void)offset;
-    (void)i;
-    (void)ptr_struct;
-    (void)ptr_buff;
 
     offset=24;
     push_to_buff(ptr_buff, offset, 8, (u_int32_t)ptr_struct->semaphore_max_addr);
@@ -98,13 +93,6 @@ void semaphore_lock_cmd_pack(const struct semaphore_lock_cmd *ptr_struct, u_int8
 
 void semaphore_lock_cmd_unpack(struct semaphore_lock_cmd *ptr_struct, u_int8_t* ptr_buff){
     u_int32_t offset;
-    int i=0;
-    u_int8_t val=0;
-    (void)val;
-    (void)offset;
-    (void)i;
-    (void)ptr_struct;
-    (void)ptr_buff;
 
     offset=24;
     ptr_struct->semaphore_max_addr = (u_int8_t)pop_from_buff(ptr_buff, offset, 8);
diff --git a/mtcr_ul/mtcr_ul.c b/mtcr_ul/mtcr_ul.c
index cb0a2c5..1bfba0f 100644
--- a/mtcr_ul/mtcr_ul.c
+++ b/mtcr_ul/mtcr_ul.c
@@ -1145,8 +1145,6 @@ int mtcr_inband_open(mfile* mf, const char* name)
     }
 
 #else
-    (void) name;
-    (void) mf;
     errno = ENOSYS;
     return -1;
 #endif
@@ -1253,7 +1251,6 @@ name_parsed:
     *force = 0;
 #ifdef __aarch64__
     // on ARM processors MMAP not supported
-    (void)force_config;
     return MTCR_ACCESS_CONFIG;
 #else
     if (force_config) {
@@ -1285,14 +1282,12 @@ int msw_reset(mfile *mf)
         return -1;
     }
 #else
-    (void)mf;
     return -1;
 #endif
 }
 
 int mhca_reset(mfile *mf)
 {
-    (void)mf;
     errno = ENOTSUP;
     return -1;
 }
@@ -1554,7 +1549,6 @@ next:
 
 void mdevices_info_destroy(dev_info* dev_info, int len)
 {
-    (void)len;
     if (dev_info)
         free(dev_info);
 }
@@ -1793,8 +1787,6 @@ mfile *mopen_fw_ctx(void* fw_cmd_context, void* fw_cmd_func, void* extra_data)
 
 unsigned char mset_i2c_slave(mfile *mf, unsigned char new_i2c_slave)
 {
-    (void)mf;
-    (void)new_i2c_slave; /* compiler warning */
     fprintf(stderr, "Warning: libmtcr: mset_i2c_slave() is not implemented and has no effect.\n");
     return 0;
 }
@@ -1832,13 +1824,12 @@ int get_inband_dev_from_pci(char* inband_dev, char* pci_dev)
 {
     unsigned domain = 0, bus = 0, dev = 0, func = 0;
     int force = 0;
-    enum mtcr_access_method access;
     DIR* d;
     struct dirent *dir;
     char dirname[DEV_DIR_MAX_SIZE], subdirname[DEV_DIR_MAX_SIZE], linkname[DEV_DIR_MAX_SIZE];
     int found = 0;
 
-    access = mtcr_parse_name(pci_dev, &force, &domain, &bus, &dev, &func);
+    mtcr_parse_name(pci_dev, &force, &domain, &bus, &dev, &func);
 
     strcpy(dirname, "/sys/class/infiniband");
     d = opendir(dirname);
@@ -1855,7 +1846,7 @@ int get_inband_dev_from_pci(char* inband_dev, char* pci_dev)
         }
         sprintf(subdirname, "%s/%s/device", dirname, dir->d_name);
         link_size = readlink(subdirname, linkname, DEV_DIR_MAX_SIZE);
-        access = mtcr_parse_name(&linkname[link_size - BDF_NAME_SIZE], &curr_force, &curr_domain, &curr_bus, &curr_dev, &curr_func);
+        mtcr_parse_name(&linkname[link_size - BDF_NAME_SIZE], &curr_force, &curr_domain, &curr_bus, &curr_dev, &curr_func);
                  
         if (domain == curr_domain && bus == curr_bus && dev == curr_dev && func == curr_func) {
             sprintf(inband_dev, "ibdr-0,%s,1", dir->d_name);
@@ -1865,7 +1856,6 @@ int get_inband_dev_from_pci(char* inband_dev, char* pci_dev)
     }
 
     closedir(d);
-    (void)access; // avoid compiler warrnings
     if (found) {
         return 0;
     } else {
@@ -1915,20 +1905,12 @@ int maccess_reg_mad(mfile *mf, u_int8_t *data)
 
 int mos_reg_access(mfile *mf, int reg_access, void *reg_data, u_int32_t cmd_type)
 {
-    (void)mf;
-    (void)reg_data; /* compiler warning */
-    (void)cmd_type; /* compiler warning */
-    (void)reg_access; /* compiler warning */
     fprintf(stderr, "Warning: libmtcr: mos_reg_access() is not implemented and has no effect.\n");
     return ME_NOT_IMPLEMENTED;
 }
 
 int maccess_reg_cmdif(mfile *mf, reg_access_t reg_access, void *reg_data, u_int32_t cmd_type)
 {
-    (void)mf;
-    (void)reg_data; /* compiler warning */
-    (void)cmd_type; /* compiler warning */
-    (void)reg_access; /* compiler warning */
     fprintf(stderr, "Warning: libmtcr: maccess_reg_cmdif() is not implemented and has no effect.\n");
     return ME_NOT_IMPLEMENTED;
 }
diff --git a/small_utils/mcra.c b/small_utils/mcra.c
index 2fc9a30..85b30a1 100644
--- a/small_utils/mcra.c
+++ b/small_utils/mcra.c
@@ -112,7 +112,6 @@ int main(int argc, char *argv[])
     }
     exit(0);
 #endif
-    (void)rc; // avoid warnings (we dont use it just assign)
     // Parse cmd line:
     if (argc < 2) {
         usage(argv[0], 1);
diff --git a/tools_layouts/cibfw_layouts.c b/tools_layouts/cibfw_layouts.c
index d72ee07..8e49163 100644
--- a/tools_layouts/cibfw_layouts.c
+++ b/tools_layouts/cibfw_layouts.c
@@ -39,11 +39,6 @@
 
 void cibfw_uint64_pack(const struct cibfw_uint64 *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	adb2c_push_integer_to_buff(ptr_buff, offset, 4, (u_int64_t)ptr_struct->hi);
@@ -55,13 +50,6 @@ void cibfw_uint64_pack(const struct cibfw_uint64 *ptr_struct, u_int8_t* ptr_buff
 
 void cibfw_uint64_unpack(struct cibfw_uint64 *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	ptr_struct->hi = (u_int32_t)adb2c_pop_integer_from_buff(ptr_buff, offset, 4);
@@ -74,10 +62,6 @@ void cibfw_uint64_unpack(struct cibfw_uint64 *ptr_struct, const u_int8_t* ptr_bu
 void cibfw_uint64_print(const struct cibfw_uint64 *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cibfw_uint64 ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "hi                   : "U32H_FMT"\n", ptr_struct->hi);
@@ -97,11 +81,6 @@ void cibfw_uint64_dump(const struct cibfw_uint64 *ptr_struct, FILE* file) {
 
 void cibfw_module_version_pack(const struct cibfw_module_version *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 8, (u_int32_t)ptr_struct->branch);
@@ -116,13 +95,6 @@ void cibfw_module_version_pack(const struct cibfw_module_version *ptr_struct, u_
 
 void cibfw_module_version_unpack(struct cibfw_module_version *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	ptr_struct->branch = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 8);
@@ -138,10 +110,6 @@ void cibfw_module_version_unpack(struct cibfw_module_version *ptr_struct, const
 void cibfw_module_version_print(const struct cibfw_module_version *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cibfw_module_version ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "branch               : "UH_FMT"\n", ptr_struct->branch);
@@ -164,11 +132,6 @@ void cibfw_module_version_dump(const struct cibfw_module_version *ptr_struct, FI
 
 void cibfw_uid_entry_pack(const struct cibfw_uid_entry *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 8, (u_int32_t)ptr_struct->num_allocated);
@@ -183,13 +146,6 @@ void cibfw_uid_entry_pack(const struct cibfw_uid_entry *ptr_struct, u_int8_t* pt
 
 void cibfw_uid_entry_unpack(struct cibfw_uid_entry *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	ptr_struct->num_allocated = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 8);
@@ -205,10 +161,6 @@ void cibfw_uid_entry_unpack(struct cibfw_uid_entry *ptr_struct, const u_int8_t*
 void cibfw_uid_entry_print(const struct cibfw_uid_entry *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cibfw_uid_entry ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "num_allocated        : "UH_FMT"\n", ptr_struct->num_allocated);
@@ -231,11 +183,6 @@ void cibfw_uid_entry_dump(const struct cibfw_uid_entry *ptr_struct, FILE* file)
 
 void cibfw_module_versions_pack(const struct cibfw_module_versions *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	cibfw_module_version_pack(&(ptr_struct->core), ptr_buff + offset/8);
@@ -259,13 +206,6 @@ void cibfw_module_versions_pack(const struct cibfw_module_versions *ptr_struct,
 
 void cibfw_module_versions_unpack(struct cibfw_module_versions *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	cibfw_module_version_unpack(&(ptr_struct->core), ptr_buff + offset/8);
@@ -290,10 +230,6 @@ void cibfw_module_versions_unpack(struct cibfw_module_versions *ptr_struct, cons
 void cibfw_module_versions_print(const struct cibfw_module_versions *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cibfw_module_versions ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "core:\n");
@@ -331,11 +267,6 @@ void cibfw_module_versions_dump(const struct cibfw_module_versions *ptr_struct,
 
 void cibfw_image_size_pack(const struct cibfw_image_size *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 8, (u_int32_t)ptr_struct->log_step);
@@ -347,13 +278,6 @@ void cibfw_image_size_pack(const struct cibfw_image_size *ptr_struct, u_int8_t*
 
 void cibfw_image_size_unpack(struct cibfw_image_size *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	ptr_struct->log_step = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 8);
@@ -366,10 +290,6 @@ void cibfw_image_size_unpack(struct cibfw_image_size *ptr_struct, const u_int8_t
 void cibfw_image_size_print(const struct cibfw_image_size *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cibfw_image_size ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "log_step             : "UH_FMT"\n", ptr_struct->log_step);
@@ -389,11 +309,6 @@ void cibfw_image_size_dump(const struct cibfw_image_size *ptr_struct, FILE* file
 
 void cibfw_TRIPPLE_VERSION_pack(const struct cibfw_TRIPPLE_VERSION *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 16, (u_int32_t)ptr_struct->MAJOR);
@@ -408,13 +323,6 @@ void cibfw_TRIPPLE_VERSION_pack(const struct cibfw_TRIPPLE_VERSION *ptr_struct,
 
 void cibfw_TRIPPLE_VERSION_unpack(struct cibfw_TRIPPLE_VERSION *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	ptr_struct->MAJOR = (u_int16_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 16);
@@ -430,10 +338,6 @@ void cibfw_TRIPPLE_VERSION_unpack(struct cibfw_TRIPPLE_VERSION *ptr_struct, cons
 void cibfw_TRIPPLE_VERSION_print(const struct cibfw_TRIPPLE_VERSION *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cibfw_TRIPPLE_VERSION ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "MAJOR                : "UH_FMT"\n", ptr_struct->MAJOR);
@@ -456,11 +360,6 @@ void cibfw_TRIPPLE_VERSION_dump(const struct cibfw_TRIPPLE_VERSION *ptr_struct,
 
 void cibfw_FW_VERSION_pack(const struct cibfw_FW_VERSION *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 16, (u_int32_t)ptr_struct->MAJOR);
@@ -493,13 +392,6 @@ void cibfw_FW_VERSION_pack(const struct cibfw_FW_VERSION *ptr_struct, u_int8_t*
 
 void cibfw_FW_VERSION_unpack(struct cibfw_FW_VERSION *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	ptr_struct->MAJOR = (u_int16_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 16);
@@ -533,10 +425,6 @@ void cibfw_FW_VERSION_unpack(struct cibfw_FW_VERSION *ptr_struct, const u_int8_t
 void cibfw_FW_VERSION_print(const struct cibfw_FW_VERSION *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cibfw_FW_VERSION ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "MAJOR                : "UH_FMT"\n", ptr_struct->MAJOR);
@@ -578,10 +466,6 @@ void cibfw_FW_VERSION_dump(const struct cibfw_FW_VERSION *ptr_struct, FILE* file
 void cibfw_guids_pack(const struct cibfw_guids *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	for (i=0; i < 2; i++) {
 	offset=adb2c_calc_array_field_address(0, 128, i, 512, 1);
@@ -598,12 +482,6 @@ void cibfw_guids_pack(const struct cibfw_guids *ptr_struct, u_int8_t* ptr_buff){
 void cibfw_guids_unpack(struct cibfw_guids *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	for (i=0; i < 2; i++) {
 	offset=adb2c_calc_array_field_address(0, 128, i, 512, 1);
@@ -621,9 +499,6 @@ void cibfw_guids_print(const struct cibfw_guids *ptr_struct, FILE* file, int ind
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cibfw_guids ========\n");
 	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	for (i=0; i < 2; i++) {
 	adb2c_add_indentation(file, indent_level);
@@ -649,11 +524,6 @@ void cibfw_guids_dump(const struct cibfw_guids *ptr_struct, FILE* file) {
 
 void cibfw_operation_key_pack(const struct cibfw_operation_key *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=16;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 16, (u_int32_t)ptr_struct->key_modifier);
@@ -665,13 +535,6 @@ void cibfw_operation_key_pack(const struct cibfw_operation_key *ptr_struct, u_in
 
 void cibfw_operation_key_unpack(struct cibfw_operation_key *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=16;
 	ptr_struct->key_modifier = (u_int16_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 16);
@@ -684,10 +547,6 @@ void cibfw_operation_key_unpack(struct cibfw_operation_key *ptr_struct, const u_
 void cibfw_operation_key_print(const struct cibfw_operation_key *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cibfw_operation_key ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "key_modifier         : "UH_FMT"\n", ptr_struct->key_modifier);
@@ -708,10 +567,6 @@ void cibfw_operation_key_dump(const struct cibfw_operation_key *ptr_struct, FILE
 void cibfw_image_info_pack(const struct cibfw_image_info *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=8;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 8, (u_int32_t)ptr_struct->minor_version);
@@ -762,12 +617,6 @@ void cibfw_image_info_pack(const struct cibfw_image_info *ptr_struct, u_int8_t*
 void cibfw_image_info_unpack(struct cibfw_image_info *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=8;
 	ptr_struct->minor_version = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 8);
@@ -822,9 +671,6 @@ void cibfw_image_info_print(const struct cibfw_image_info *ptr_struct, FILE* fil
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cibfw_image_info ========\n");
 	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "minor_version        : "UH_FMT"\n", ptr_struct->minor_version);
@@ -875,10 +721,6 @@ void cibfw_image_info_dump(const struct cibfw_image_info *ptr_struct, FILE* file
 void cibfw_mfg_info_pack(const struct cibfw_mfg_info *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	for (i=0; i < 16; i++) {
 	offset=adb2c_calc_array_field_address(24, 8, i, 2560, 1);
@@ -902,12 +744,6 @@ void cibfw_mfg_info_pack(const struct cibfw_mfg_info *ptr_struct, u_int8_t* ptr_
 void cibfw_mfg_info_unpack(struct cibfw_mfg_info *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	for (i=0; i < 16; i++) {
 	offset=adb2c_calc_array_field_address(24, 8, i, 2560, 1);
@@ -932,10 +768,6 @@ void cibfw_mfg_info_unpack(struct cibfw_mfg_info *ptr_struct, const u_int8_t* pt
 void cibfw_mfg_info_print(const struct cibfw_mfg_info *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cibfw_mfg_info ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	fprintf(file, "psid                 : \"%s\"\n", ptr_struct->psid);
 	adb2c_add_indentation(file, indent_level);
@@ -964,10 +796,6 @@ void cibfw_mfg_info_dump(const struct cibfw_mfg_info *ptr_struct, FILE* file) {
 void cibfw_device_info_pack(const struct cibfw_device_info *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	adb2c_push_integer_to_buff(ptr_buff, offset, 4, (u_int64_t)ptr_struct->signature0);
@@ -1008,12 +836,6 @@ void cibfw_device_info_pack(const struct cibfw_device_info *ptr_struct, u_int8_t
 void cibfw_device_info_unpack(struct cibfw_device_info *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	ptr_struct->signature0 = (u_int32_t)adb2c_pop_integer_from_buff(ptr_buff, offset, 4);
@@ -1056,9 +878,6 @@ void cibfw_device_info_print(const struct cibfw_device_info *ptr_struct, FILE* f
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cibfw_device_info ========\n");
 	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "signature0           : "U32H_FMT"\n", ptr_struct->signature0);
@@ -1104,11 +923,6 @@ void cibfw_device_info_dump(const struct cibfw_device_info *ptr_struct, FILE* fi
 
 void cibfw_register_mfrl_pack(const struct cibfw_register_mfrl *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=56;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 8, (u_int32_t)ptr_struct->reset_level);
@@ -1117,13 +931,6 @@ void cibfw_register_mfrl_pack(const struct cibfw_register_mfrl *ptr_struct, u_in
 
 void cibfw_register_mfrl_unpack(struct cibfw_register_mfrl *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=56;
 	ptr_struct->reset_level = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 8);
@@ -1133,10 +940,6 @@ void cibfw_register_mfrl_unpack(struct cibfw_register_mfrl *ptr_struct, const u_
 void cibfw_register_mfrl_print(const struct cibfw_register_mfrl *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cibfw_register_mfrl ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "reset_level          : "UH_FMT"\n", ptr_struct->reset_level);
@@ -1153,11 +956,6 @@ void cibfw_register_mfrl_dump(const struct cibfw_register_mfrl *ptr_struct, FILE
 
 void cibfw_itoc_header_pack(const struct cibfw_itoc_header *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	adb2c_push_integer_to_buff(ptr_buff, offset, 4, (u_int64_t)ptr_struct->signature0);
@@ -1181,13 +979,6 @@ void cibfw_itoc_header_pack(const struct cibfw_itoc_header *ptr_struct, u_int8_t
 
 void cibfw_itoc_header_unpack(struct cibfw_itoc_header *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	ptr_struct->signature0 = (u_int32_t)adb2c_pop_integer_from_buff(ptr_buff, offset, 4);
@@ -1212,10 +1003,6 @@ void cibfw_itoc_header_unpack(struct cibfw_itoc_header *ptr_struct, const u_int8
 void cibfw_itoc_header_print(const struct cibfw_itoc_header *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cibfw_itoc_header ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "signature0           : "U32H_FMT"\n", ptr_struct->signature0);
@@ -1247,11 +1034,6 @@ void cibfw_itoc_header_dump(const struct cibfw_itoc_header *ptr_struct, FILE* fi
 
 void cibfw_itoc_entry_pack(const struct cibfw_itoc_entry *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=8;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 22, (u_int32_t)ptr_struct->size);
@@ -1293,13 +1075,6 @@ void cibfw_itoc_entry_pack(const struct cibfw_itoc_entry *ptr_struct, u_int8_t*
 
 void cibfw_itoc_entry_unpack(struct cibfw_itoc_entry *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=8;
 	ptr_struct->size = (u_int32_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 22);
@@ -1342,10 +1117,6 @@ void cibfw_itoc_entry_unpack(struct cibfw_itoc_entry *ptr_struct, const u_int8_t
 void cibfw_itoc_entry_print(const struct cibfw_itoc_entry *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cibfw_itoc_entry ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "size                 : "UH_FMT"\n", ptr_struct->size);
@@ -1395,11 +1166,6 @@ void cibfw_itoc_entry_dump(const struct cibfw_itoc_entry *ptr_struct, FILE* file
 
 void cibfw_register_mfai_pack(const struct cibfw_register_mfai *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=8;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 24, (u_int32_t)ptr_struct->address);
@@ -1420,13 +1186,6 @@ void cibfw_register_mfai_pack(const struct cibfw_register_mfai *ptr_struct, u_in
 
 void cibfw_register_mfai_unpack(struct cibfw_register_mfai *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=8;
 	ptr_struct->address = (u_int32_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 24);
@@ -1448,10 +1207,6 @@ void cibfw_register_mfai_unpack(struct cibfw_register_mfai *ptr_struct, const u_
 void cibfw_register_mfai_print(const struct cibfw_register_mfai *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cibfw_register_mfai ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "address              : "UH_FMT"\n", ptr_struct->address);
@@ -1491,10 +1246,6 @@ void cibfw_cibfw_Nodes_unpack(union cibfw_cibfw_Nodes *ptr_struct, const u_int8_
 void cibfw_cibfw_Nodes_print(const union cibfw_cibfw_Nodes *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cibfw_cibfw_Nodes ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "register_mfai:\n");
diff --git a/tools_layouts/connectib_layouts.c b/tools_layouts/connectib_layouts.c
index 9b72bb4..c15d850 100644
--- a/tools_layouts/connectib_layouts.c
+++ b/tools_layouts/connectib_layouts.c
@@ -34,11 +34,6 @@
 
 void connectib_FW_VERSION_pack(const struct connectib_FW_VERSION *ptr_struct, u_int8_t* ptr_buff){
     u_int32_t offset;
-    int i=0;
-    (void)offset;
-    (void)i;
-    (void)ptr_struct;
-    (void)ptr_buff;
 
     offset=0;
     adb2c_push_bits_to_buff(ptr_buff, offset, 16, (u_int32_t)ptr_struct->MAJOR);
@@ -71,13 +66,6 @@ void connectib_FW_VERSION_pack(const struct connectib_FW_VERSION *ptr_struct, u_
 
 void connectib_FW_VERSION_unpack(struct connectib_FW_VERSION *ptr_struct, const u_int8_t* ptr_buff){
     u_int32_t offset;
-    int i=0;
-    u_int8_t val=0;
-    (void)val;
-    (void)offset;
-    (void)i;
-    (void)ptr_struct;
-    (void)ptr_buff;
 
     offset=0;
     ptr_struct->MAJOR = (u_int16_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 16);
@@ -111,10 +99,6 @@ void connectib_FW_VERSION_unpack(struct connectib_FW_VERSION *ptr_struct, const
 void connectib_FW_VERSION_print(const struct connectib_FW_VERSION *ptr_struct, FILE* file, int indent_level){
     adb2c_add_indentation(file, indent_level);
     fprintf(file, "======== connectib_FW_VERSION ========\n");
-    int i=0;
-    (void)i;(void)ptr_struct;
-    (void)file;
-    (void)indent_level;
 
     adb2c_add_indentation(file, indent_level);
     fprintf(file, "MAJOR                : "UH_FMT"\n", ptr_struct->MAJOR);
@@ -155,11 +139,6 @@ void connectib_FW_VERSION_dump(const struct connectib_FW_VERSION *ptr_struct, FI
 
 void connectib_icmd_get_fw_info_pack(const struct connectib_icmd_get_fw_info *ptr_struct, u_int8_t* ptr_buff){
     u_int32_t offset;
-    int i=0;
-    (void)offset;
-    (void)i;
-    (void)ptr_struct;
-    (void)ptr_buff;
 
     offset=0;
     connectib_FW_VERSION_pack(&(ptr_struct->fw_version), ptr_buff + offset/8);
@@ -171,13 +150,6 @@ void connectib_icmd_get_fw_info_pack(const struct connectib_icmd_get_fw_info *pt
 
 void connectib_icmd_get_fw_info_unpack(struct connectib_icmd_get_fw_info *ptr_struct, const u_int8_t* ptr_buff){
     u_int32_t offset;
-    int i=0;
-    u_int8_t val=0;
-    (void)val;
-    (void)offset;
-    (void)i;
-    (void)ptr_struct;
-    (void)ptr_buff;
 
     offset=0;
     connectib_FW_VERSION_unpack(&(ptr_struct->fw_version), ptr_buff + offset/8);
@@ -190,10 +162,6 @@ void connectib_icmd_get_fw_info_unpack(struct connectib_icmd_get_fw_info *ptr_st
 void connectib_icmd_get_fw_info_print(const struct connectib_icmd_get_fw_info *ptr_struct, FILE* file, int indent_level){
     adb2c_add_indentation(file, indent_level);
     fprintf(file, "======== connectib_icmd_get_fw_info ========\n");
-    int i=0;
-    (void)i;(void)ptr_struct;
-    (void)file;
-    (void)indent_level;
 
     adb2c_add_indentation(file, indent_level);
     fprintf(file, "fw_version:\n");
diff --git a/tools_layouts/cx4fw_layouts.c b/tools_layouts/cx4fw_layouts.c
index 2eeb44d..d30229a 100644
--- a/tools_layouts/cx4fw_layouts.c
+++ b/tools_layouts/cx4fw_layouts.c
@@ -39,11 +39,6 @@
 
 void cx4fw_uint64_pack(const struct cx4fw_uint64 *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	adb2c_push_integer_to_buff(ptr_buff, offset, 4, (u_int64_t)ptr_struct->hi);
@@ -55,13 +50,6 @@ void cx4fw_uint64_pack(const struct cx4fw_uint64 *ptr_struct, u_int8_t* ptr_buff
 
 void cx4fw_uint64_unpack(struct cx4fw_uint64 *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	ptr_struct->hi = (u_int32_t)adb2c_pop_integer_from_buff(ptr_buff, offset, 4);
@@ -74,10 +62,6 @@ void cx4fw_uint64_unpack(struct cx4fw_uint64 *ptr_struct, const u_int8_t* ptr_bu
 void cx4fw_uint64_print(const struct cx4fw_uint64 *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cx4fw_uint64 ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "hi                   : "U32H_FMT"\n", ptr_struct->hi);
@@ -97,11 +81,6 @@ void cx4fw_uint64_dump(const struct cx4fw_uint64 *ptr_struct, FILE* file) {
 
 void cx4fw_uid_entry_pack(const struct cx4fw_uid_entry *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 8, (u_int32_t)ptr_struct->num_allocated);
@@ -116,13 +95,6 @@ void cx4fw_uid_entry_pack(const struct cx4fw_uid_entry *ptr_struct, u_int8_t* pt
 
 void cx4fw_uid_entry_unpack(struct cx4fw_uid_entry *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	ptr_struct->num_allocated = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 8);
@@ -138,10 +110,6 @@ void cx4fw_uid_entry_unpack(struct cx4fw_uid_entry *ptr_struct, const u_int8_t*
 void cx4fw_uid_entry_print(const struct cx4fw_uid_entry *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cx4fw_uid_entry ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "num_allocated        : "UH_FMT"\n", ptr_struct->num_allocated);
@@ -164,11 +132,6 @@ void cx4fw_uid_entry_dump(const struct cx4fw_uid_entry *ptr_struct, FILE* file)
 
 void cx4fw_guids_pack(const struct cx4fw_guids *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	cx4fw_uid_entry_pack(&(ptr_struct->guids), ptr_buff + offset/8);
@@ -180,13 +143,6 @@ void cx4fw_guids_pack(const struct cx4fw_guids *ptr_struct, u_int8_t* ptr_buff){
 
 void cx4fw_guids_unpack(struct cx4fw_guids *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	cx4fw_uid_entry_unpack(&(ptr_struct->guids), ptr_buff + offset/8);
@@ -199,10 +155,6 @@ void cx4fw_guids_unpack(struct cx4fw_guids *ptr_struct, const u_int8_t* ptr_buff
 void cx4fw_guids_print(const struct cx4fw_guids *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cx4fw_guids ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "guids:\n");
@@ -224,11 +176,6 @@ void cx4fw_guids_dump(const struct cx4fw_guids *ptr_struct, FILE* file) {
 
 void cx4fw_operation_key_pack(const struct cx4fw_operation_key *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=16;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 16, (u_int32_t)ptr_struct->key_modifier);
@@ -240,13 +187,6 @@ void cx4fw_operation_key_pack(const struct cx4fw_operation_key *ptr_struct, u_in
 
 void cx4fw_operation_key_unpack(struct cx4fw_operation_key *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=16;
 	ptr_struct->key_modifier = (u_int16_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 16);
@@ -259,10 +199,6 @@ void cx4fw_operation_key_unpack(struct cx4fw_operation_key *ptr_struct, const u_
 void cx4fw_operation_key_print(const struct cx4fw_operation_key *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cx4fw_operation_key ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "key_modifier         : "UH_FMT"\n", ptr_struct->key_modifier);
@@ -283,10 +219,6 @@ void cx4fw_operation_key_dump(const struct cx4fw_operation_key *ptr_struct, FILE
 void cx4fw_mfg_info_pack(const struct cx4fw_mfg_info *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	for (i=0; i < 16; i++) {
 	offset=adb2c_calc_array_field_address(24, 8, i, 2560, 1);
@@ -310,12 +242,6 @@ void cx4fw_mfg_info_pack(const struct cx4fw_mfg_info *ptr_struct, u_int8_t* ptr_
 void cx4fw_mfg_info_unpack(struct cx4fw_mfg_info *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	for (i=0; i < 16; i++) {
 	offset=adb2c_calc_array_field_address(24, 8, i, 2560, 1);
@@ -340,10 +266,6 @@ void cx4fw_mfg_info_unpack(struct cx4fw_mfg_info *ptr_struct, const u_int8_t* pt
 void cx4fw_mfg_info_print(const struct cx4fw_mfg_info *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cx4fw_mfg_info ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	fprintf(file, "psid                 : \"%s\"\n", ptr_struct->psid);
 	adb2c_add_indentation(file, indent_level);
@@ -372,10 +294,6 @@ void cx4fw_mfg_info_dump(const struct cx4fw_mfg_info *ptr_struct, FILE* file) {
 void cx4fw_device_info_pack(const struct cx4fw_device_info *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	adb2c_push_integer_to_buff(ptr_buff, offset, 4, (u_int64_t)ptr_struct->signature0);
@@ -416,12 +334,6 @@ void cx4fw_device_info_pack(const struct cx4fw_device_info *ptr_struct, u_int8_t
 void cx4fw_device_info_unpack(struct cx4fw_device_info *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	ptr_struct->signature0 = (u_int32_t)adb2c_pop_integer_from_buff(ptr_buff, offset, 4);
@@ -464,9 +376,6 @@ void cx4fw_device_info_print(const struct cx4fw_device_info *ptr_struct, FILE* f
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cx4fw_device_info ========\n");
 	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "signature0           : "U32H_FMT"\n", ptr_struct->signature0);
@@ -523,10 +432,6 @@ void cx4fw_cx4fw_Nodes_unpack(union cx4fw_cx4fw_Nodes *ptr_struct, const u_int8_
 void cx4fw_cx4fw_Nodes_print(const union cx4fw_cx4fw_Nodes *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== cx4fw_cx4fw_Nodes ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "device_info:\n");
diff --git a/tools_layouts/register_access_open_layouts.c b/tools_layouts/register_access_open_layouts.c
index d9c0c8a..848008a 100644
--- a/tools_layouts/register_access_open_layouts.c
+++ b/tools_layouts/register_access_open_layouts.c
@@ -40,10 +40,6 @@
 void register_access_mfba_pack(const struct register_access_mfba *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=26;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 2, (u_int32_t)ptr_struct->fs);
@@ -67,12 +63,6 @@ void register_access_mfba_pack(const struct register_access_mfba *ptr_struct, u_
 void register_access_mfba_unpack(struct register_access_mfba *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=26;
 	ptr_struct->fs = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 2);
@@ -97,9 +87,6 @@ void register_access_mfba_print(const struct register_access_mfba *ptr_struct, F
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== register_access_mfba ========\n");
 	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "fs                   : "UH_FMT"\n", ptr_struct->fs);
@@ -130,11 +117,6 @@ void register_access_mfba_dump(const struct register_access_mfba *ptr_struct, FI
 
 void register_access_mfpa_pack(const struct register_access_mfpa *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=26;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 2, (u_int32_t)ptr_struct->fs);
@@ -167,13 +149,6 @@ void register_access_mfpa_pack(const struct register_access_mfpa *ptr_struct, u_
 
 void register_access_mfpa_unpack(struct register_access_mfpa *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=26;
 	ptr_struct->fs = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 2);
@@ -207,10 +182,6 @@ void register_access_mfpa_unpack(struct register_access_mfpa *ptr_struct, const
 void register_access_mfpa_print(const struct register_access_mfpa *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== register_access_mfpa ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "fs                   : "UH_FMT"\n", ptr_struct->fs);
@@ -251,11 +222,6 @@ void register_access_mfpa_dump(const struct register_access_mfpa *ptr_struct, FI
 
 void register_access_mfbe_pack(const struct register_access_mfbe *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=26;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 2, (u_int32_t)ptr_struct->fs);
@@ -273,13 +239,6 @@ void register_access_mfbe_pack(const struct register_access_mfbe *ptr_struct, u_
 
 void register_access_mfbe_unpack(struct register_access_mfbe *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=26;
 	ptr_struct->fs = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 2);
@@ -298,10 +257,6 @@ void register_access_mfbe_unpack(struct register_access_mfbe *ptr_struct, const
 void register_access_mfbe_print(const struct register_access_mfbe *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== register_access_mfbe ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "fs                   : "UH_FMT"\n", ptr_struct->fs);
@@ -338,10 +293,6 @@ void register_access_register_access_open_Nodes_unpack(union register_access_reg
 void register_access_register_access_open_Nodes_print(const union register_access_register_access_open_Nodes *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== register_access_register_access_open_Nodes ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "mfbe:\n");
diff --git a/tools_layouts/register_access_sib_layouts.c b/tools_layouts/register_access_sib_layouts.c
index 60bee42..c18c0fd 100644
--- a/tools_layouts/register_access_sib_layouts.c
+++ b/tools_layouts/register_access_sib_layouts.c
@@ -40,10 +40,6 @@
 void register_access_sib_IB_PSID__pack(const struct register_access_sib_IB_PSID_ *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	for (i=0; i < 4; i++) {
 	offset=adb2c_calc_array_field_address(0, 32, i, 128, 1);
@@ -55,12 +51,6 @@ void register_access_sib_IB_PSID__pack(const struct register_access_sib_IB_PSID_
 void register_access_sib_IB_PSID__unpack(struct register_access_sib_IB_PSID_ *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	for (i=0; i < 4; i++) {
 	offset=adb2c_calc_array_field_address(0, 32, i, 128, 1);
@@ -73,9 +63,6 @@ void register_access_sib_IB_PSID__print(const struct register_access_sib_IB_PSID
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== register_access_sib_IB_PSID_ ========\n");
 	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	for (i=0; i < 4; i++) {
 	adb2c_add_indentation(file, indent_level);
@@ -94,11 +81,6 @@ void register_access_sib_IB_PSID__dump(const struct register_access_sib_IB_PSID_
 
 void register_access_sib_IB_SWInfo__pack(const struct register_access_sib_IB_SWInfo_ *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 8, (u_int32_t)ptr_struct->VerSubMinor);
@@ -113,13 +95,6 @@ void register_access_sib_IB_SWInfo__pack(const struct register_access_sib_IB_SWI
 
 void register_access_sib_IB_SWInfo__unpack(struct register_access_sib_IB_SWInfo_ *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	ptr_struct->VerSubMinor = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 8);
@@ -135,10 +110,6 @@ void register_access_sib_IB_SWInfo__unpack(struct register_access_sib_IB_SWInfo_
 void register_access_sib_IB_SWInfo__print(const struct register_access_sib_IB_SWInfo_ *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== register_access_sib_IB_SWInfo_ ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "VerSubMinor          : "UH_FMT"\n", ptr_struct->VerSubMinor);
@@ -161,11 +132,6 @@ void register_access_sib_IB_SWInfo__dump(const struct register_access_sib_IB_SWI
 
 void register_access_sib_IB_FWInfo__pack(const struct register_access_sib_IB_FWInfo_ *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 8, (u_int32_t)ptr_struct->SubMinor);
@@ -210,13 +176,6 @@ void register_access_sib_IB_FWInfo__pack(const struct register_access_sib_IB_FWI
 
 void register_access_sib_IB_FWInfo__unpack(struct register_access_sib_IB_FWInfo_ *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	ptr_struct->SubMinor = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 8);
@@ -262,10 +221,6 @@ void register_access_sib_IB_FWInfo__unpack(struct register_access_sib_IB_FWInfo_
 void register_access_sib_IB_FWInfo__print(const struct register_access_sib_IB_FWInfo_ *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== register_access_sib_IB_FWInfo_ ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "SubMinor             : "UH_FMT"\n", ptr_struct->SubMinor);
@@ -319,11 +274,6 @@ void register_access_sib_IB_FWInfo__dump(const struct register_access_sib_IB_FWI
 
 void register_access_sib_IB_HWInfo__pack(const struct register_access_sib_IB_HWInfo_ *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=16;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 16, (u_int32_t)ptr_struct->DEVID);
@@ -344,13 +294,6 @@ void register_access_sib_IB_HWInfo__pack(const struct register_access_sib_IB_HWI
 
 void register_access_sib_IB_HWInfo__unpack(struct register_access_sib_IB_HWInfo_ *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=16;
 	ptr_struct->DEVID = (u_int16_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 16);
@@ -372,10 +315,6 @@ void register_access_sib_IB_HWInfo__unpack(struct register_access_sib_IB_HWInfo_
 void register_access_sib_IB_HWInfo__print(const struct register_access_sib_IB_HWInfo_ *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== register_access_sib_IB_HWInfo_ ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "DEVID                : "UH_FMT"\n", ptr_struct->DEVID);
@@ -404,11 +343,6 @@ void register_access_sib_IB_HWInfo__dump(const struct register_access_sib_IB_HWI
 
 void register_access_sib_mgir_pack(const struct register_access_sib_mgir *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	register_access_sib_IB_HWInfo__pack(&(ptr_struct->HWInfo), ptr_buff + offset/8);
@@ -423,13 +357,6 @@ void register_access_sib_mgir_pack(const struct register_access_sib_mgir *ptr_st
 
 void register_access_sib_mgir_unpack(struct register_access_sib_mgir *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	register_access_sib_IB_HWInfo__unpack(&(ptr_struct->HWInfo), ptr_buff + offset/8);
@@ -445,10 +372,6 @@ void register_access_sib_mgir_unpack(struct register_access_sib_mgir *ptr_struct
 void register_access_sib_mgir_print(const struct register_access_sib_mgir *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== register_access_sib_mgir ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "HWInfo:\n");
@@ -474,11 +397,6 @@ void register_access_sib_mgir_dump(const struct register_access_sib_mgir *ptr_st
 
 void register_access_sib_mtmp_pack(const struct register_access_sib_mtmp *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=25;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 7, (u_int32_t)ptr_struct->sensor_index);
@@ -517,13 +435,6 @@ void register_access_sib_mtmp_pack(const struct register_access_sib_mtmp *ptr_st
 
 void register_access_sib_mtmp_unpack(struct register_access_sib_mtmp *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=25;
 	ptr_struct->sensor_index = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 7);
@@ -563,10 +474,6 @@ void register_access_sib_mtmp_unpack(struct register_access_sib_mtmp *ptr_struct
 void register_access_sib_mtmp_print(const struct register_access_sib_mtmp *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== register_access_sib_mtmp ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "sensor_index         : "UH_FMT"\n", ptr_struct->sensor_index);
@@ -624,10 +531,6 @@ void register_access_sib_register_access_sib_Nodes_unpack(union register_access_
 void register_access_sib_register_access_sib_Nodes_print(const union register_access_sib_register_access_sib_Nodes *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== register_access_sib_register_access_sib_Nodes ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "mtmp:\n");
diff --git a/tools_layouts/tools_open_layouts.c b/tools_layouts/tools_open_layouts.c
index 1cb0428..786b553 100644
--- a/tools_layouts/tools_open_layouts.c
+++ b/tools_layouts/tools_open_layouts.c
@@ -39,11 +39,6 @@
 
 void tools_open_tlv_type_dw_pack(const struct tools_open_tlv_type_dw *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	adb2c_push_integer_to_buff(ptr_buff, offset, 4, (u_int64_t)ptr_struct->tlv_type_dw);
@@ -52,13 +47,6 @@ void tools_open_tlv_type_dw_pack(const struct tools_open_tlv_type_dw *ptr_struct
 
 void tools_open_tlv_type_dw_unpack(struct tools_open_tlv_type_dw *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	ptr_struct->tlv_type_dw = (u_int32_t)adb2c_pop_integer_from_buff(ptr_buff, offset, 4);
@@ -68,10 +56,6 @@ void tools_open_tlv_type_dw_unpack(struct tools_open_tlv_type_dw *ptr_struct, co
 void tools_open_tlv_type_dw_print(const struct tools_open_tlv_type_dw *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_tlv_type_dw ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "tlv_type_dw          : "U32H_FMT"\n", ptr_struct->tlv_type_dw);
@@ -88,11 +72,6 @@ void tools_open_tlv_type_dw_dump(const struct tools_open_tlv_type_dw *ptr_struct
 
 void tools_open_per_port_type_pack(const struct tools_open_per_port_type *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=16;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 16, (u_int32_t)ptr_struct->param_idx);
@@ -107,13 +86,6 @@ void tools_open_per_port_type_pack(const struct tools_open_per_port_type *ptr_st
 
 void tools_open_per_port_type_unpack(struct tools_open_per_port_type *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=16;
 	ptr_struct->param_idx = (u_int16_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 16);
@@ -129,10 +101,6 @@ void tools_open_per_port_type_unpack(struct tools_open_per_port_type *ptr_struct
 void tools_open_per_port_type_print(const struct tools_open_per_port_type *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_per_port_type ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "param_idx            : "UH_FMT"\n", ptr_struct->param_idx);
@@ -155,11 +123,6 @@ void tools_open_per_port_type_dump(const struct tools_open_per_port_type *ptr_st
 
 void tools_open_bmc_type_pack(const struct tools_open_bmc_type *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=19;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 13, (u_int32_t)ptr_struct->param_idx);
@@ -177,13 +140,6 @@ void tools_open_bmc_type_pack(const struct tools_open_bmc_type *ptr_struct, u_in
 
 void tools_open_bmc_type_unpack(struct tools_open_bmc_type *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=19;
 	ptr_struct->param_idx = (u_int16_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 13);
@@ -202,10 +158,6 @@ void tools_open_bmc_type_unpack(struct tools_open_bmc_type *ptr_struct, const u_
 void tools_open_bmc_type_print(const struct tools_open_bmc_type *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_bmc_type ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "param_idx            : "UH_FMT"\n", ptr_struct->param_idx);
@@ -231,11 +183,6 @@ void tools_open_bmc_type_dump(const struct tools_open_bmc_type *ptr_struct, FILE
 
 void tools_open_per_host_type_pack(const struct tools_open_per_host_type *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=22;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 10, (u_int32_t)ptr_struct->param_idx);
@@ -253,13 +200,6 @@ void tools_open_per_host_type_pack(const struct tools_open_per_host_type *ptr_st
 
 void tools_open_per_host_type_unpack(struct tools_open_per_host_type *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=22;
 	ptr_struct->param_idx = (u_int16_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 10);
@@ -278,10 +218,6 @@ void tools_open_per_host_type_unpack(struct tools_open_per_host_type *ptr_struct
 void tools_open_per_host_type_print(const struct tools_open_per_host_type *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_per_host_type ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "param_idx            : "UH_FMT"\n", ptr_struct->param_idx);
@@ -307,11 +243,6 @@ void tools_open_per_host_type_dump(const struct tools_open_per_host_type *ptr_st
 
 void tools_open_eswitch_type_pack(const struct tools_open_eswitch_type *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=16;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 16, (u_int32_t)ptr_struct->param_idx);
@@ -329,13 +260,6 @@ void tools_open_eswitch_type_pack(const struct tools_open_eswitch_type *ptr_stru
 
 void tools_open_eswitch_type_unpack(struct tools_open_eswitch_type *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=16;
 	ptr_struct->param_idx = (u_int16_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 16);
@@ -354,10 +278,6 @@ void tools_open_eswitch_type_unpack(struct tools_open_eswitch_type *ptr_struct,
 void tools_open_eswitch_type_print(const struct tools_open_eswitch_type *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_eswitch_type ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "param_idx            : "UH_FMT"\n", ptr_struct->param_idx);
@@ -383,11 +303,6 @@ void tools_open_eswitch_type_dump(const struct tools_open_eswitch_type *ptr_stru
 
 void tools_open_global_type_pack(const struct tools_open_global_type *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=8;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 24, (u_int32_t)ptr_struct->param_idx);
@@ -399,13 +314,6 @@ void tools_open_global_type_pack(const struct tools_open_global_type *ptr_struct
 
 void tools_open_global_type_unpack(struct tools_open_global_type *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=8;
 	ptr_struct->param_idx = (u_int32_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 24);
@@ -418,10 +326,6 @@ void tools_open_global_type_unpack(struct tools_open_global_type *ptr_struct, co
 void tools_open_global_type_print(const struct tools_open_global_type *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_global_type ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "param_idx            : "UH_FMT"\n", ptr_struct->param_idx);
@@ -441,11 +345,6 @@ void tools_open_global_type_dump(const struct tools_open_global_type *ptr_struct
 
 void tools_open_ts_entry_pack(const struct tools_open_ts_entry *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 8, (u_int32_t)ptr_struct->ts_day);
@@ -469,13 +368,6 @@ void tools_open_ts_entry_pack(const struct tools_open_ts_entry *ptr_struct, u_in
 
 void tools_open_ts_entry_unpack(struct tools_open_ts_entry *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	ptr_struct->ts_day = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 8);
@@ -500,10 +392,6 @@ void tools_open_ts_entry_unpack(struct tools_open_ts_entry *ptr_struct, const u_
 void tools_open_ts_entry_print(const struct tools_open_ts_entry *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_ts_entry ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "ts_day               : "UH_FMT"\n", ptr_struct->ts_day);
@@ -535,11 +423,6 @@ void tools_open_ts_entry_dump(const struct tools_open_ts_entry *ptr_struct, FILE
 
 void tools_open_fw_version_pack(const struct tools_open_fw_version *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 16, (u_int32_t)ptr_struct->fw_ver_major);
@@ -554,13 +437,6 @@ void tools_open_fw_version_pack(const struct tools_open_fw_version *ptr_struct,
 
 void tools_open_fw_version_unpack(struct tools_open_fw_version *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	ptr_struct->fw_ver_major = (u_int16_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 16);
@@ -576,10 +452,6 @@ void tools_open_fw_version_unpack(struct tools_open_fw_version *ptr_struct, cons
 void tools_open_fw_version_print(const struct tools_open_fw_version *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_fw_version ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "fw_ver_major         : "UH_FMT"\n", ptr_struct->fw_ver_major);
@@ -613,10 +485,6 @@ void tools_open_tlv_type_unpack(union tools_open_tlv_type *ptr_struct, const u_i
 void tools_open_tlv_type_print(const union tools_open_tlv_type *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_tlv_type ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "global:\n");
@@ -654,11 +522,6 @@ void tools_open_tlv_type_dump(const union tools_open_tlv_type *ptr_struct, FILE*
 
 void tools_open_pmdio_addr_data_pack(const struct tools_open_pmdio_addr_data *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=16;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 16, (u_int32_t)ptr_struct->data);
@@ -670,13 +533,6 @@ void tools_open_pmdio_addr_data_pack(const struct tools_open_pmdio_addr_data *pt
 
 void tools_open_pmdio_addr_data_unpack(struct tools_open_pmdio_addr_data *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=16;
 	ptr_struct->data = (u_int16_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 16);
@@ -689,10 +545,6 @@ void tools_open_pmdio_addr_data_unpack(struct tools_open_pmdio_addr_data *ptr_st
 void tools_open_pmdio_addr_data_print(const struct tools_open_pmdio_addr_data *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_pmdio_addr_data ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "data                 : "UH_FMT"\n", ptr_struct->data);
@@ -712,11 +564,6 @@ void tools_open_pmdio_addr_data_dump(const struct tools_open_pmdio_addr_data *pt
 
 void tools_open_timestamp_pack(const struct tools_open_timestamp *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	tools_open_fw_version_pack(&(ptr_struct->fw_version), ptr_buff + offset/8);
@@ -728,13 +575,6 @@ void tools_open_timestamp_pack(const struct tools_open_timestamp *ptr_struct, u_
 
 void tools_open_timestamp_unpack(struct tools_open_timestamp *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	tools_open_fw_version_unpack(&(ptr_struct->fw_version), ptr_buff + offset/8);
@@ -747,10 +587,6 @@ void tools_open_timestamp_unpack(struct tools_open_timestamp *ptr_struct, const
 void tools_open_timestamp_print(const struct tools_open_timestamp *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_timestamp ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "fw_version:\n");
@@ -772,11 +608,6 @@ void tools_open_timestamp_dump(const struct tools_open_timestamp *ptr_struct, FI
 
 void tools_open_nv_hdr_fifth_gen_pack(const struct tools_open_nv_hdr_fifth_gen *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 8, (u_int32_t)ptr_struct->length);
@@ -806,13 +637,6 @@ void tools_open_nv_hdr_fifth_gen_pack(const struct tools_open_nv_hdr_fifth_gen *
 
 void tools_open_nv_hdr_fifth_gen_unpack(struct tools_open_nv_hdr_fifth_gen *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	ptr_struct->length = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 8);
@@ -843,10 +667,6 @@ void tools_open_nv_hdr_fifth_gen_unpack(struct tools_open_nv_hdr_fifth_gen *ptr_
 void tools_open_nv_hdr_fifth_gen_print(const struct tools_open_nv_hdr_fifth_gen *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_nv_hdr_fifth_gen ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "length               : "UH_FMT"\n", ptr_struct->length);
@@ -885,11 +705,6 @@ void tools_open_nv_hdr_fifth_gen_dump(const struct tools_open_nv_hdr_fifth_gen *
 
 void tools_open_nv_hdr_pack(const struct tools_open_nv_hdr *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=16;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 16, (u_int32_t)ptr_struct->type);
@@ -913,13 +728,6 @@ void tools_open_nv_hdr_pack(const struct tools_open_nv_hdr *ptr_struct, u_int8_t
 
 void tools_open_nv_hdr_unpack(struct tools_open_nv_hdr *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=16;
 	ptr_struct->type = (u_int16_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 16);
@@ -944,10 +752,6 @@ void tools_open_nv_hdr_unpack(struct tools_open_nv_hdr *ptr_struct, const u_int8
 void tools_open_nv_hdr_print(const struct tools_open_nv_hdr *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_nv_hdr ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "type                 : "UH_FMT"\n", ptr_struct->type);
@@ -979,11 +783,6 @@ void tools_open_nv_hdr_dump(const struct tools_open_nv_hdr *ptr_struct, FILE* fi
 
 void tools_open_aux_tlv_header_pack(const struct tools_open_aux_tlv_header *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 8, (u_int32_t)ptr_struct->minor_version);
@@ -1013,13 +812,6 @@ void tools_open_aux_tlv_header_pack(const struct tools_open_aux_tlv_header *ptr_
 
 void tools_open_aux_tlv_header_unpack(struct tools_open_aux_tlv_header *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	ptr_struct->minor_version = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 8);
@@ -1050,10 +842,6 @@ void tools_open_aux_tlv_header_unpack(struct tools_open_aux_tlv_header *ptr_stru
 void tools_open_aux_tlv_header_print(const struct tools_open_aux_tlv_header *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_aux_tlv_header ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "minor_version        : "UH_FMT"\n", ptr_struct->minor_version);
@@ -1092,10 +880,6 @@ void tools_open_aux_tlv_header_dump(const struct tools_open_aux_tlv_header *ptr_
 void tools_open_pmdio_pack(const struct tools_open_pmdio *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=29;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 3, (u_int32_t)ptr_struct->operation);
@@ -1128,12 +912,6 @@ void tools_open_pmdio_pack(const struct tools_open_pmdio *ptr_struct, u_int8_t*
 void tools_open_pmdio_unpack(struct tools_open_pmdio *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=29;
 	ptr_struct->operation = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 3);
@@ -1167,9 +945,6 @@ void tools_open_pmdio_print(const struct tools_open_pmdio *ptr_struct, FILE* fil
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_pmdio ========\n");
 	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "operation            : "UH_FMT"\n", ptr_struct->operation);
@@ -1210,11 +985,6 @@ void tools_open_pmdio_dump(const struct tools_open_pmdio *ptr_struct, FILE* file
 
 void tools_open_pmdic_pack(const struct tools_open_pmdic *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=8;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 8, (u_int32_t)ptr_struct->local_port);
@@ -1235,13 +1005,6 @@ void tools_open_pmdic_pack(const struct tools_open_pmdic *ptr_struct, u_int8_t*
 
 void tools_open_pmdic_unpack(struct tools_open_pmdic *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=8;
 	ptr_struct->local_port = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 8);
@@ -1263,10 +1026,6 @@ void tools_open_pmdic_unpack(struct tools_open_pmdic *ptr_struct, const u_int8_t
 void tools_open_pmdic_print(const struct tools_open_pmdic *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_pmdic ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "local_port           : "UH_FMT"\n", ptr_struct->local_port);
@@ -1295,11 +1054,6 @@ void tools_open_pmdic_dump(const struct tools_open_pmdic *ptr_struct, FILE* file
 
 void tools_open_mvts_pack(const struct tools_open_mvts *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=2;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 1, (u_int32_t)ptr_struct->check_timestamp_flag);
@@ -1317,13 +1071,6 @@ void tools_open_mvts_pack(const struct tools_open_mvts *ptr_struct, u_int8_t* pt
 
 void tools_open_mvts_unpack(struct tools_open_mvts *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=2;
 	ptr_struct->check_timestamp_flag = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 1);
@@ -1342,10 +1089,6 @@ void tools_open_mvts_unpack(struct tools_open_mvts *ptr_struct, const u_int8_t*
 void tools_open_mvts_print(const struct tools_open_mvts *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_mvts ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "check_timestamp_flag : "UH_FMT"\n", ptr_struct->check_timestamp_flag);
@@ -1372,11 +1115,6 @@ void tools_open_mvts_dump(const struct tools_open_mvts *ptr_struct, FILE* file)
 
 void tools_open_nvqgc_pack(const struct tools_open_nvqgc *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=31;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 1, (u_int32_t)ptr_struct->read_factory_settings_support);
@@ -1385,13 +1123,6 @@ void tools_open_nvqgc_pack(const struct tools_open_nvqgc *ptr_struct, u_int8_t*
 
 void tools_open_nvqgc_unpack(struct tools_open_nvqgc *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=31;
 	ptr_struct->read_factory_settings_support = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 1);
@@ -1401,11 +1132,6 @@ void tools_open_nvqgc_unpack(struct tools_open_nvqgc *ptr_struct, const u_int8_t
 void tools_open_nvqgc_print(const struct tools_open_nvqgc *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_nvqgc ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
-
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "read_factory_settings_support : "UH_FMT"\n", ptr_struct->read_factory_settings_support);
 
@@ -1421,11 +1147,6 @@ void tools_open_nvqgc_dump(const struct tools_open_nvqgc *ptr_struct, FILE* file
 
 void tools_open_nvdi_pack(const struct tools_open_nvdi *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	tools_open_nv_hdr_fifth_gen_pack(&(ptr_struct->nv_hdr), ptr_buff + offset/8);
@@ -1434,13 +1155,6 @@ void tools_open_nvdi_pack(const struct tools_open_nvdi *ptr_struct, u_int8_t* pt
 
 void tools_open_nvdi_unpack(struct tools_open_nvdi *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	tools_open_nv_hdr_fifth_gen_unpack(&(ptr_struct->nv_hdr), ptr_buff + offset/8);
@@ -1450,10 +1164,6 @@ void tools_open_nvdi_unpack(struct tools_open_nvdi *ptr_struct, const u_int8_t*
 void tools_open_nvdi_print(const struct tools_open_nvdi *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_nvdi ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "nv_hdr:\n");
@@ -1472,10 +1182,6 @@ void tools_open_nvdi_dump(const struct tools_open_nvdi *ptr_struct, FILE* file)
 void tools_open_nvda_pack(const struct tools_open_nvda *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	tools_open_nv_hdr_fifth_gen_pack(&(ptr_struct->nv_hdr), ptr_buff + offset/8);
@@ -1490,12 +1196,6 @@ void tools_open_nvda_pack(const struct tools_open_nvda *ptr_struct, u_int8_t* pt
 void tools_open_nvda_unpack(struct tools_open_nvda *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	tools_open_nv_hdr_fifth_gen_unpack(&(ptr_struct->nv_hdr), ptr_buff + offset/8);
@@ -1511,9 +1211,6 @@ void tools_open_nvda_print(const struct tools_open_nvda *ptr_struct, FILE* file,
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_nvda ========\n");
 	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "nv_hdr:\n");
@@ -1536,11 +1233,6 @@ void tools_open_nvda_dump(const struct tools_open_nvda *ptr_struct, FILE* file)
 
 void tools_open_nvia_pack(const struct tools_open_nvia *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	tools_open_nv_hdr_fifth_gen_pack(&(ptr_struct->nv_hdr), ptr_buff + offset/8);
@@ -1552,13 +1244,6 @@ void tools_open_nvia_pack(const struct tools_open_nvia *ptr_struct, u_int8_t* pt
 
 void tools_open_nvia_unpack(struct tools_open_nvia *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	tools_open_nv_hdr_fifth_gen_unpack(&(ptr_struct->nv_hdr), ptr_buff + offset/8);
@@ -1571,10 +1256,6 @@ void tools_open_nvia_unpack(struct tools_open_nvia *ptr_struct, const u_int8_t*
 void tools_open_nvia_print(const struct tools_open_nvia *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_nvia ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "nv_hdr:\n");
@@ -1595,11 +1276,6 @@ void tools_open_nvia_dump(const struct tools_open_nvia *ptr_struct, FILE* file)
 
 void tools_open_nvqc_pack(const struct tools_open_nvqc *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	tools_open_tlv_type_pack(&(ptr_struct->type), ptr_buff + offset/8);
@@ -1617,13 +1293,6 @@ void tools_open_nvqc_pack(const struct tools_open_nvqc *ptr_struct, u_int8_t* pt
 
 void tools_open_nvqc_unpack(struct tools_open_nvqc *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	tools_open_tlv_type_unpack(&(ptr_struct->type), ptr_buff + offset/8);
@@ -1642,10 +1311,6 @@ void tools_open_nvqc_unpack(struct tools_open_nvqc *ptr_struct, const u_int8_t*
 void tools_open_nvqc_print(const struct tools_open_nvqc *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_nvqc ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "type:\n");
@@ -1672,11 +1337,6 @@ void tools_open_nvqc_dump(const struct tools_open_nvqc *ptr_struct, FILE* file)
 
 void tools_open_mnvia_pack(const struct tools_open_mnvia *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	tools_open_nv_hdr_pack(&(ptr_struct->nv_hdr), ptr_buff + offset/8);
@@ -1685,13 +1345,6 @@ void tools_open_mnvia_pack(const struct tools_open_mnvia *ptr_struct, u_int8_t*
 
 void tools_open_mnvia_unpack(struct tools_open_mnvia *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	tools_open_nv_hdr_unpack(&(ptr_struct->nv_hdr), ptr_buff + offset/8);
@@ -1701,10 +1354,6 @@ void tools_open_mnvia_unpack(struct tools_open_mnvia *ptr_struct, const u_int8_t
 void tools_open_mnvia_print(const struct tools_open_mnvia *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_mnvia ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "nv_hdr:\n");
@@ -1722,11 +1371,6 @@ void tools_open_mnvia_dump(const struct tools_open_mnvia *ptr_struct, FILE* file
 
 void tools_open_mnvi_pack(const struct tools_open_mnvi *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	tools_open_nv_hdr_pack(&(ptr_struct->nv_hdr), ptr_buff + offset/8);
@@ -1735,13 +1379,6 @@ void tools_open_mnvi_pack(const struct tools_open_mnvi *ptr_struct, u_int8_t* pt
 
 void tools_open_mnvi_unpack(struct tools_open_mnvi *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	tools_open_nv_hdr_unpack(&(ptr_struct->nv_hdr), ptr_buff + offset/8);
@@ -1751,10 +1388,6 @@ void tools_open_mnvi_unpack(struct tools_open_mnvi *ptr_struct, const u_int8_t*
 void tools_open_mnvi_print(const struct tools_open_mnvi *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_mnvi ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "nv_hdr:\n");
@@ -1773,10 +1406,6 @@ void tools_open_mnvi_dump(const struct tools_open_mnvi *ptr_struct, FILE* file)
 void tools_open_mnva_pack(const struct tools_open_mnva *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	tools_open_nv_hdr_pack(&(ptr_struct->nv_hdr), ptr_buff + offset/8);
@@ -1791,12 +1420,6 @@ void tools_open_mnva_pack(const struct tools_open_mnva *ptr_struct, u_int8_t* pt
 void tools_open_mnva_unpack(struct tools_open_mnva *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	tools_open_nv_hdr_unpack(&(ptr_struct->nv_hdr), ptr_buff + offset/8);
@@ -1812,9 +1435,6 @@ void tools_open_mnva_print(const struct tools_open_mnva *ptr_struct, FILE* file,
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_mnva ========\n");
 	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "nv_hdr:\n");
@@ -1838,10 +1458,6 @@ void tools_open_mnva_dump(const struct tools_open_mnva *ptr_struct, FILE* file)
 void tools_open_mfg_info_pack(const struct tools_open_mfg_info *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	for (i=0; i < 16; i++) {
 	offset=adb2c_calc_array_field_address(24, 8, i, 2560, 1);
@@ -1864,12 +1480,6 @@ void tools_open_mfg_info_pack(const struct tools_open_mfg_info *ptr_struct, u_in
 void tools_open_mfg_info_unpack(struct tools_open_mfg_info *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	for (i=0; i < 16; i++) {
 	offset=adb2c_calc_array_field_address(24, 8, i, 2560, 1);
@@ -1894,10 +1504,6 @@ void tools_open_mfg_info_unpack(struct tools_open_mfg_info *ptr_struct, const u_
 void tools_open_mfg_info_print(const struct tools_open_mfg_info *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_mfg_info ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	fprintf(file, "psid                 : \"%s\"\n", ptr_struct->psid);
 	adb2c_add_indentation(file, indent_level);
@@ -1920,10 +1526,6 @@ void tools_open_mfg_info_dump(const struct tools_open_mfg_info *ptr_struct, FILE
 void tools_open_image_info_pack(const struct tools_open_image_info *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=8;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 8, (u_int32_t)ptr_struct->minor_version);
@@ -1956,12 +1558,6 @@ void tools_open_image_info_pack(const struct tools_open_image_info *ptr_struct,
 void tools_open_image_info_unpack(struct tools_open_image_info *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=8;
 	ptr_struct->minor_version = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 8);
@@ -1998,10 +1594,6 @@ void tools_open_image_info_unpack(struct tools_open_image_info *ptr_struct, cons
 void tools_open_image_info_print(const struct tools_open_image_info *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_image_info ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "minor_version        : "UH_FMT"\n", ptr_struct->minor_version);
@@ -2026,10 +1618,6 @@ void tools_open_image_info_dump(const struct tools_open_image_info *ptr_struct,
 void tools_open_aux_tlv_pack(const struct tools_open_aux_tlv *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	tools_open_aux_tlv_header_pack(&(ptr_struct->aux_tlv_header), ptr_buff + offset/8);
@@ -2044,12 +1632,6 @@ void tools_open_aux_tlv_pack(const struct tools_open_aux_tlv *ptr_struct, u_int8
 void tools_open_aux_tlv_unpack(struct tools_open_aux_tlv *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	tools_open_aux_tlv_header_unpack(&(ptr_struct->aux_tlv_header), ptr_buff + offset/8);
@@ -2065,9 +1647,6 @@ void tools_open_aux_tlv_print(const struct tools_open_aux_tlv *ptr_struct, FILE*
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_aux_tlv ========\n");
 	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "aux_tlv_header:\n");
@@ -2090,11 +1669,6 @@ void tools_open_aux_tlv_dump(const struct tools_open_aux_tlv *ptr_struct, FILE*
 
 void tools_open_aux_data_hdr_pack(const struct tools_open_aux_data_hdr *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	adb2c_push_integer_to_buff(ptr_buff, offset, 4, (u_int64_t)ptr_struct->signature0);
@@ -2112,13 +1686,6 @@ void tools_open_aux_data_hdr_pack(const struct tools_open_aux_data_hdr *ptr_stru
 
 void tools_open_aux_data_hdr_unpack(struct tools_open_aux_data_hdr *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	ptr_struct->signature0 = (u_int32_t)adb2c_pop_integer_from_buff(ptr_buff, offset, 4);
@@ -2137,10 +1704,6 @@ void tools_open_aux_data_hdr_unpack(struct tools_open_aux_data_hdr *ptr_struct,
 void tools_open_aux_data_hdr_print(const struct tools_open_aux_data_hdr *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_aux_data_hdr ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "signature0           : "U32H_FMT"\n", ptr_struct->signature0);
@@ -2166,11 +1729,6 @@ void tools_open_aux_data_hdr_dump(const struct tools_open_aux_data_hdr *ptr_stru
 
 void tools_open_query_def_params_per_port_pack(const struct tools_open_query_def_params_per_port *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=13;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 1, (u_int32_t)ptr_struct->nv_config_vpi);
@@ -2266,13 +1824,6 @@ void tools_open_query_def_params_per_port_pack(const struct tools_open_query_def
 
 void tools_open_query_def_params_per_port_unpack(struct tools_open_query_def_params_per_port *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=13;
 	ptr_struct->nv_config_vpi = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 1);
@@ -2369,10 +1920,6 @@ void tools_open_query_def_params_per_port_unpack(struct tools_open_query_def_par
 void tools_open_query_def_params_per_port_print(const struct tools_open_query_def_params_per_port *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_query_def_params_per_port ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "nv_config_vpi        : "UH_FMT"\n", ptr_struct->nv_config_vpi);
@@ -2476,11 +2023,6 @@ void tools_open_query_def_params_per_port_dump(const struct tools_open_query_def
 
 void tools_open_query_def_params_global_pack(const struct tools_open_query_def_params_global *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 8, (u_int32_t)ptr_struct->fw_default_config_payload_version);
@@ -2504,13 +2046,6 @@ void tools_open_query_def_params_global_pack(const struct tools_open_query_def_p
 
 void tools_open_query_def_params_global_unpack(struct tools_open_query_def_params_global *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	ptr_struct->fw_default_config_payload_version = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 8);
@@ -2535,10 +2070,6 @@ void tools_open_query_def_params_global_unpack(struct tools_open_query_def_param
 void tools_open_query_def_params_global_print(const struct tools_open_query_def_params_global *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_query_def_params_global ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "fw_default_config_payload_version : "UH_FMT"\n", ptr_struct->fw_default_config_payload_version);
@@ -2581,10 +2112,6 @@ void tools_open_phy_reg_unpack(union tools_open_phy_reg *ptr_struct, const u_int
 void tools_open_phy_reg_print(const union tools_open_phy_reg *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_phy_reg ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "pmdic:\n");
@@ -2617,10 +2144,6 @@ void tools_open_mnv_cfg_unpack(union tools_open_mnv_cfg *ptr_struct, const u_int
 void tools_open_mnv_cfg_print(const union tools_open_mnv_cfg *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_mnv_cfg ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "mnva:\n");
@@ -2670,11 +2193,6 @@ void tools_open_mnv_cfg_dump(const union tools_open_mnv_cfg *ptr_struct, FILE* f
 
 void tools_open_option_rom_capability_pack(const struct tools_open_option_rom_capability *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 1, (u_int32_t)ptr_struct->ip_ver);
@@ -2683,13 +2201,6 @@ void tools_open_option_rom_capability_pack(const struct tools_open_option_rom_ca
 
 void tools_open_option_rom_capability_unpack(struct tools_open_option_rom_capability *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	ptr_struct->ip_ver = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 1);
@@ -2699,10 +2210,6 @@ void tools_open_option_rom_capability_unpack(struct tools_open_option_rom_capabi
 void tools_open_option_rom_capability_print(const struct tools_open_option_rom_capability *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_option_rom_capability ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "ip_ver               : "UH_FMT"\n", ptr_struct->ip_ver);
@@ -2719,11 +2226,6 @@ void tools_open_option_rom_capability_dump(const struct tools_open_option_rom_ca
 
 void tools_open_boot_settings_ext_pack(const struct tools_open_boot_settings_ext *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=22;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 2, (u_int32_t)ptr_struct->ip_ver);
@@ -2732,13 +2234,6 @@ void tools_open_boot_settings_ext_pack(const struct tools_open_boot_settings_ext
 
 void tools_open_boot_settings_ext_unpack(struct tools_open_boot_settings_ext *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=22;
 	ptr_struct->ip_ver = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 2);
@@ -2748,10 +2243,6 @@ void tools_open_boot_settings_ext_unpack(struct tools_open_boot_settings_ext *pt
 void tools_open_boot_settings_ext_print(const struct tools_open_boot_settings_ext *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_boot_settings_ext ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "ip_ver               : "UH_FMT"\n", ptr_struct->ip_ver);
@@ -2768,11 +2259,6 @@ void tools_open_boot_settings_ext_dump(const struct tools_open_boot_settings_ext
 
 void tools_open_external_port_pack(const struct tools_open_external_port *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=31;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 1, (u_int32_t)ptr_struct->port_owner);
@@ -2784,13 +2270,6 @@ void tools_open_external_port_pack(const struct tools_open_external_port *ptr_st
 
 void tools_open_external_port_unpack(struct tools_open_external_port *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=31;
 	ptr_struct->port_owner = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 1);
@@ -2803,10 +2282,6 @@ void tools_open_external_port_unpack(struct tools_open_external_port *ptr_struct
 void tools_open_external_port_print(const struct tools_open_external_port *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_external_port ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "port_owner           : "UH_FMT"\n", ptr_struct->port_owner);
@@ -2827,10 +2302,6 @@ void tools_open_external_port_dump(const struct tools_open_external_port *ptr_st
 void tools_open_lldp_nb_capability_pack(const struct tools_open_lldp_nb_capability *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 1, (u_int32_t)ptr_struct->lldp_nb_supported);
@@ -2848,12 +2319,6 @@ void tools_open_lldp_nb_capability_pack(const struct tools_open_lldp_nb_capabili
 void tools_open_lldp_nb_capability_unpack(struct tools_open_lldp_nb_capability *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	ptr_struct->lldp_nb_supported = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 1);
@@ -2872,9 +2337,6 @@ void tools_open_lldp_nb_capability_print(const struct tools_open_lldp_nb_capabil
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_lldp_nb_capability ========\n");
 	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "lldp_nb_supported    : "UH_FMT"\n", ptr_struct->lldp_nb_supported);
@@ -2900,10 +2362,6 @@ void tools_open_lldp_nb_capability_dump(const struct tools_open_lldp_nb_capabili
 void tools_open_lldp_nb_pack(const struct tools_open_lldp_nb *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=1;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 1, (u_int32_t)ptr_struct->lldp_nb_rx_en);
@@ -2924,12 +2382,6 @@ void tools_open_lldp_nb_pack(const struct tools_open_lldp_nb *ptr_struct, u_int8
 void tools_open_lldp_nb_unpack(struct tools_open_lldp_nb *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
 	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=1;
 	ptr_struct->lldp_nb_rx_en = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 1);
@@ -2951,9 +2403,6 @@ void tools_open_lldp_nb_print(const struct tools_open_lldp_nb *ptr_struct, FILE*
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_lldp_nb ========\n");
 	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "lldp_nb_rx_en        : "UH_FMT"\n", ptr_struct->lldp_nb_rx_en);
@@ -2981,11 +2430,6 @@ void tools_open_lldp_nb_dump(const struct tools_open_lldp_nb *ptr_struct, FILE*
 
 void tools_open_roce_cc_ecn_pack(const struct tools_open_roce_cc_ecn *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=1;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 1, (u_int32_t)ptr_struct->clamp_tgt_rate_after_time_inc);
@@ -3048,13 +2492,6 @@ void tools_open_roce_cc_ecn_pack(const struct tools_open_roce_cc_ecn *ptr_struct
 
 void tools_open_roce_cc_ecn_unpack(struct tools_open_roce_cc_ecn *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=1;
 	ptr_struct->clamp_tgt_rate_after_time_inc = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 1);
@@ -3118,10 +2555,6 @@ void tools_open_roce_cc_ecn_unpack(struct tools_open_roce_cc_ecn *ptr_struct, co
 void tools_open_roce_cc_ecn_print(const struct tools_open_roce_cc_ecn *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_roce_cc_ecn ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "clamp_tgt_rate_after_time_inc : "UH_FMT"\n", ptr_struct->clamp_tgt_rate_after_time_inc);
@@ -3192,11 +2625,6 @@ void tools_open_roce_cc_ecn_dump(const struct tools_open_roce_cc_ecn *ptr_struct
 
 void tools_open_roce_cc_pack(const struct tools_open_roce_cc *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 8, (u_int32_t)ptr_struct->roce_cc_enable_priority);
@@ -3208,13 +2636,6 @@ void tools_open_roce_cc_pack(const struct tools_open_roce_cc *ptr_struct, u_int8
 
 void tools_open_roce_cc_unpack(struct tools_open_roce_cc *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	ptr_struct->roce_cc_enable_priority = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 8);
@@ -3227,10 +2648,6 @@ void tools_open_roce_cc_unpack(struct tools_open_roce_cc *ptr_struct, const u_in
 void tools_open_roce_cc_print(const struct tools_open_roce_cc *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_roce_cc ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "roce_cc_enable_priority : "UH_FMT"\n", ptr_struct->roce_cc_enable_priority);
@@ -3250,11 +2667,6 @@ void tools_open_roce_cc_dump(const struct tools_open_roce_cc *ptr_struct, FILE*
 
 void tools_open_roce_v_1_5_next_protocol_pack(const struct tools_open_roce_v_1_5_next_protocol *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 8, (u_int32_t)ptr_struct->roce_over_ip_next_protocol);
@@ -3263,13 +2675,6 @@ void tools_open_roce_v_1_5_next_protocol_pack(const struct tools_open_roce_v_1_5
 
 void tools_open_roce_v_1_5_next_protocol_unpack(struct tools_open_roce_v_1_5_next_protocol *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	ptr_struct->roce_over_ip_next_protocol = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 8);
@@ -3279,10 +2684,6 @@ void tools_open_roce_v_1_5_next_protocol_unpack(struct tools_open_roce_v_1_5_nex
 void tools_open_roce_v_1_5_next_protocol_print(const struct tools_open_roce_v_1_5_next_protocol *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_roce_v_1_5_next_protocol ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "roce_over_ip_next_protocol : "UH_FMT"\n", ptr_struct->roce_over_ip_next_protocol);
@@ -3299,11 +2700,6 @@ void tools_open_roce_v_1_5_next_protocol_dump(const struct tools_open_roce_v_1_5
 
 void tools_open_vpi_settings_pack(const struct tools_open_vpi_settings *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=30;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 2, (u_int32_t)ptr_struct->network_link_type);
@@ -3315,13 +2711,6 @@ void tools_open_vpi_settings_pack(const struct tools_open_vpi_settings *ptr_stru
 
 void tools_open_vpi_settings_unpack(struct tools_open_vpi_settings *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=30;
 	ptr_struct->network_link_type = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 2);
@@ -3334,10 +2723,6 @@ void tools_open_vpi_settings_unpack(struct tools_open_vpi_settings *ptr_struct,
 void tools_open_vpi_settings_print(const struct tools_open_vpi_settings *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_vpi_settings ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "network_link_type    : "UH_FMT"\n", ptr_struct->network_link_type);
@@ -3357,11 +2742,6 @@ void tools_open_vpi_settings_dump(const struct tools_open_vpi_settings *ptr_stru
 
 void tools_open_bar_size_pack(const struct tools_open_bar_size *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	adb2c_push_integer_to_buff(ptr_buff, offset, 4, (u_int64_t)ptr_struct->log_uar_bar_size);
@@ -3370,13 +2750,6 @@ void tools_open_bar_size_pack(const struct tools_open_bar_size *ptr_struct, u_in
 
 void tools_open_bar_size_unpack(struct tools_open_bar_size *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	ptr_struct->log_uar_bar_size = (u_int32_t)adb2c_pop_integer_from_buff(ptr_buff, offset, 4);
@@ -3386,10 +2759,6 @@ void tools_open_bar_size_unpack(struct tools_open_bar_size *ptr_struct, const u_
 void tools_open_bar_size_print(const struct tools_open_bar_size *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_bar_size ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "log_uar_bar_size     : "U32H_FMT"\n", ptr_struct->log_uar_bar_size);
@@ -3406,11 +2775,6 @@ void tools_open_bar_size_dump(const struct tools_open_bar_size *ptr_struct, FILE
 
 void tools_open_sriov_pack(const struct tools_open_sriov *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=16;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 16, (u_int32_t)ptr_struct->total_vfs);
@@ -3422,13 +2786,6 @@ void tools_open_sriov_pack(const struct tools_open_sriov *ptr_struct, u_int8_t*
 
 void tools_open_sriov_unpack(struct tools_open_sriov *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=16;
 	ptr_struct->total_vfs = (u_int16_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 16);
@@ -3441,10 +2798,6 @@ void tools_open_sriov_unpack(struct tools_open_sriov *ptr_struct, const u_int8_t
 void tools_open_sriov_print(const struct tools_open_sriov *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_sriov ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "total_vfs            : "UH_FMT"\n", ptr_struct->total_vfs);
@@ -3464,11 +2817,6 @@ void tools_open_sriov_dump(const struct tools_open_sriov *ptr_struct, FILE* file
 
 void tools_open_preboot_flow_ctrl_pack(const struct tools_open_preboot_flow_ctrl *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 8, (u_int32_t)ptr_struct->pfcrx);
@@ -3489,13 +2837,6 @@ void tools_open_preboot_flow_ctrl_pack(const struct tools_open_preboot_flow_ctrl
 
 void tools_open_preboot_flow_ctrl_unpack(struct tools_open_preboot_flow_ctrl *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	ptr_struct->pfcrx = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 8);
@@ -3517,10 +2858,6 @@ void tools_open_preboot_flow_ctrl_unpack(struct tools_open_preboot_flow_ctrl *pt
 void tools_open_preboot_flow_ctrl_print(const struct tools_open_preboot_flow_ctrl *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_preboot_flow_ctrl ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "pfcrx                : "UH_FMT"\n", ptr_struct->pfcrx);
@@ -3549,11 +2886,6 @@ void tools_open_preboot_flow_ctrl_dump(const struct tools_open_preboot_flow_ctrl
 
 void tools_open_preboot_boot_settings_pack(const struct tools_open_preboot_boot_settings *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=20;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 12, (u_int32_t)ptr_struct->boot_vlan);
@@ -3574,13 +2906,6 @@ void tools_open_preboot_boot_settings_pack(const struct tools_open_preboot_boot_
 
 void tools_open_preboot_boot_settings_unpack(struct tools_open_preboot_boot_settings *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=20;
 	ptr_struct->boot_vlan = (u_int16_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 12);
@@ -3602,10 +2927,6 @@ void tools_open_preboot_boot_settings_unpack(struct tools_open_preboot_boot_sett
 void tools_open_preboot_boot_settings_print(const struct tools_open_preboot_boot_settings *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_preboot_boot_settings ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "boot_vlan            : "UH_FMT"\n", ptr_struct->boot_vlan);
@@ -3634,11 +2955,6 @@ void tools_open_preboot_boot_settings_dump(const struct tools_open_preboot_boot_
 
 void tools_open_boot_settings_pack(const struct tools_open_boot_settings *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=20;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 12, (u_int32_t)ptr_struct->boot_vlan);
@@ -3659,13 +2975,6 @@ void tools_open_boot_settings_pack(const struct tools_open_boot_settings *ptr_st
 
 void tools_open_boot_settings_unpack(struct tools_open_boot_settings *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=20;
 	ptr_struct->boot_vlan = (u_int16_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 12);
@@ -3687,10 +2996,6 @@ void tools_open_boot_settings_unpack(struct tools_open_boot_settings *ptr_struct
 void tools_open_boot_settings_print(const struct tools_open_boot_settings *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_boot_settings ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "boot_vlan            : "UH_FMT"\n", ptr_struct->boot_vlan);
@@ -3719,11 +3024,6 @@ void tools_open_boot_settings_dump(const struct tools_open_boot_settings *ptr_st
 
 void tools_open_infiniband_boot_settings_pack(const struct tools_open_infiniband_boot_settings *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=16;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 16, (u_int32_t)ptr_struct->boot_pkey);
@@ -3732,13 +3032,6 @@ void tools_open_infiniband_boot_settings_pack(const struct tools_open_infiniband
 
 void tools_open_infiniband_boot_settings_unpack(struct tools_open_infiniband_boot_settings *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=16;
 	ptr_struct->boot_pkey = (u_int16_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 16);
@@ -3748,10 +3041,6 @@ void tools_open_infiniband_boot_settings_unpack(struct tools_open_infiniband_boo
 void tools_open_infiniband_boot_settings_print(const struct tools_open_infiniband_boot_settings *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_infiniband_boot_settings ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "boot_pkey            : "UH_FMT"\n", ptr_struct->boot_pkey);
@@ -3768,11 +3057,6 @@ void tools_open_infiniband_boot_settings_dump(const struct tools_open_infiniband
 
 void tools_open_iscsi_settings_pack(const struct tools_open_iscsi_settings *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=10;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 1, (u_int32_t)ptr_struct->target_as_first_hdd_en);
@@ -3814,13 +3098,6 @@ void tools_open_iscsi_settings_pack(const struct tools_open_iscsi_settings *ptr_
 
 void tools_open_iscsi_settings_unpack(struct tools_open_iscsi_settings *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=10;
 	ptr_struct->target_as_first_hdd_en = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 1);
@@ -3863,10 +3140,6 @@ void tools_open_iscsi_settings_unpack(struct tools_open_iscsi_settings *ptr_stru
 void tools_open_iscsi_settings_print(const struct tools_open_iscsi_settings *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_iscsi_settings ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "target_as_first_hdd_en : "UH_FMT"\n", ptr_struct->target_as_first_hdd_en);
@@ -3916,11 +3189,6 @@ void tools_open_iscsi_settings_dump(const struct tools_open_iscsi_settings *ptr_
 
 void tools_open_port_boot_state_pack(const struct tools_open_port_boot_state *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 8, (u_int32_t)ptr_struct->aux_power_indication_gpio);
@@ -3938,13 +3206,6 @@ void tools_open_port_boot_state_pack(const struct tools_open_port_boot_state *pt
 
 void tools_open_port_boot_state_unpack(struct tools_open_port_boot_state *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=24;
 	ptr_struct->aux_power_indication_gpio = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 8);
@@ -3963,10 +3224,6 @@ void tools_open_port_boot_state_unpack(struct tools_open_port_boot_state *ptr_st
 void tools_open_port_boot_state_print(const struct tools_open_port_boot_state *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_port_boot_state ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "aux_power_indication_gpio : "UH_FMT"\n", ptr_struct->aux_power_indication_gpio);
@@ -3992,11 +3249,6 @@ void tools_open_port_boot_state_dump(const struct tools_open_port_boot_state *pt
 
 void tools_open_pci_configuration_pack(const struct tools_open_pci_configuration *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=7;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 1, (u_int32_t)ptr_struct->pf_bar_size_valid);
@@ -4053,13 +3305,6 @@ void tools_open_pci_configuration_pack(const struct tools_open_pci_configuration
 
 void tools_open_pci_configuration_unpack(struct tools_open_pci_configuration *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=7;
 	ptr_struct->pf_bar_size_valid = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 1);
@@ -4117,10 +3362,6 @@ void tools_open_pci_configuration_unpack(struct tools_open_pci_configuration *pt
 void tools_open_pci_configuration_print(const struct tools_open_pci_configuration *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_pci_configuration ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "pf_bar_size_valid    : "UH_FMT"\n", ptr_struct->pf_bar_size_valid);
@@ -4185,11 +3426,6 @@ void tools_open_pci_configuration_dump(const struct tools_open_pci_configuration
 
 void tools_open_pci_capabilities_pack(const struct tools_open_pci_capabilities *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=7;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 1, (u_int32_t)ptr_struct->pf_bar_size_supported);
@@ -4252,13 +3488,6 @@ void tools_open_pci_capabilities_pack(const struct tools_open_pci_capabilities *
 
 void tools_open_pci_capabilities_unpack(struct tools_open_pci_capabilities *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=7;
 	ptr_struct->pf_bar_size_supported = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 1);
@@ -4322,10 +3551,6 @@ void tools_open_pci_capabilities_unpack(struct tools_open_pci_capabilities *ptr_
 void tools_open_pci_capabilities_print(const struct tools_open_pci_capabilities *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_pci_capabilities ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "pf_bar_size_supported : "UH_FMT"\n", ptr_struct->pf_bar_size_supported);
@@ -4396,11 +3621,6 @@ void tools_open_pci_capabilities_dump(const struct tools_open_pci_capabilities *
 
 void tools_open_tpt_configuration_pack(const struct tools_open_tpt_configuration *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=28;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 4, (u_int32_t)ptr_struct->log_max_payload_size);
@@ -4409,13 +3629,6 @@ void tools_open_tpt_configuration_pack(const struct tools_open_tpt_configuration
 
 void tools_open_tpt_configuration_unpack(struct tools_open_tpt_configuration *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=28;
 	ptr_struct->log_max_payload_size = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 4);
@@ -4425,10 +3638,6 @@ void tools_open_tpt_configuration_unpack(struct tools_open_tpt_configuration *pt
 void tools_open_tpt_configuration_print(const struct tools_open_tpt_configuration *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_tpt_configuration ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "log_max_payload_size : "UH_FMT"\n", ptr_struct->log_max_payload_size);
@@ -4445,11 +3654,6 @@ void tools_open_tpt_configuration_dump(const struct tools_open_tpt_configuration
 
 void tools_open_tpt_capabilities_pack(const struct tools_open_tpt_capabilities *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 1, (u_int32_t)ptr_struct->log_max_payload_size_supported);
@@ -4458,13 +3662,6 @@ void tools_open_tpt_capabilities_pack(const struct tools_open_tpt_capabilities *
 
 void tools_open_tpt_capabilities_unpack(struct tools_open_tpt_capabilities *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	ptr_struct->log_max_payload_size_supported = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 1);
@@ -4474,10 +3671,6 @@ void tools_open_tpt_capabilities_unpack(struct tools_open_tpt_capabilities *ptr_
 void tools_open_tpt_capabilities_print(const struct tools_open_tpt_capabilities *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_tpt_capabilities ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "log_max_payload_size_supported : "UH_FMT"\n", ptr_struct->log_max_payload_size_supported);
@@ -4494,11 +3687,6 @@ void tools_open_tpt_capabilities_dump(const struct tools_open_tpt_capabilities *
 
 void tools_open_infiniband_dc_settings_pack(const struct tools_open_infiniband_dc_settings *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=27;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 5, (u_int32_t)ptr_struct->log_dcr_hash_table_size);
@@ -4510,13 +3698,6 @@ void tools_open_infiniband_dc_settings_pack(const struct tools_open_infiniband_d
 
 void tools_open_infiniband_dc_settings_unpack(struct tools_open_infiniband_dc_settings *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=27;
 	ptr_struct->log_dcr_hash_table_size = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 5);
@@ -4529,10 +3710,6 @@ void tools_open_infiniband_dc_settings_unpack(struct tools_open_infiniband_dc_se
 void tools_open_infiniband_dc_settings_print(const struct tools_open_infiniband_dc_settings *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_infiniband_dc_settings ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "log_dcr_hash_table_size : "UH_FMT"\n", ptr_struct->log_dcr_hash_table_size);
@@ -4552,11 +3729,6 @@ void tools_open_infiniband_dc_settings_dump(const struct tools_open_infiniband_d
 
 void tools_open_infiniband_dc_capabilities_pack(const struct tools_open_infiniband_dc_capabilities *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	adb2c_push_integer_to_buff(ptr_buff, offset, 4, (u_int64_t)ptr_struct->min_log_dcr_hash_table_size);
@@ -4574,13 +3746,6 @@ void tools_open_infiniband_dc_capabilities_pack(const struct tools_open_infiniba
 
 void tools_open_infiniband_dc_capabilities_unpack(struct tools_open_infiniband_dc_capabilities *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	ptr_struct->min_log_dcr_hash_table_size = (u_int32_t)adb2c_pop_integer_from_buff(ptr_buff, offset, 4);
@@ -4599,10 +3764,6 @@ void tools_open_infiniband_dc_capabilities_unpack(struct tools_open_infiniband_d
 void tools_open_infiniband_dc_capabilities_print(const struct tools_open_infiniband_dc_capabilities *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_infiniband_dc_capabilities ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "min_log_dcr_hash_table_size : "U32H_FMT"\n", ptr_struct->min_log_dcr_hash_table_size);
@@ -4628,11 +3789,6 @@ void tools_open_infiniband_dc_capabilities_dump(const struct tools_open_infiniba
 
 void tools_open_wol_pack(const struct tools_open_wol *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=22;
 	adb2c_push_bits_to_buff(ptr_buff, offset, 1, (u_int32_t)ptr_struct->en_wol_psswd_magic);
@@ -4659,13 +3815,6 @@ void tools_open_wol_pack(const struct tools_open_wol *ptr_struct, u_int8_t* ptr_
 
 void tools_open_wol_unpack(struct tools_open_wol *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=22;
 	ptr_struct->en_wol_psswd_magic = (u_int8_t)adb2c_pop_bits_from_buff(ptr_buff, offset, 1);
@@ -4693,10 +3842,6 @@ void tools_open_wol_unpack(struct tools_open_wol *ptr_struct, const u_int8_t* pt
 void tools_open_wol_print(const struct tools_open_wol *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_wol ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "en_wol_psswd_magic   : "UH_FMT"\n", ptr_struct->en_wol_psswd_magic);
@@ -4742,10 +3887,6 @@ void tools_open_misc_structs_unpack(union tools_open_misc_structs *ptr_struct, c
 void tools_open_misc_structs_print(const union tools_open_misc_structs *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_misc_structs ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "image_info:\n");
@@ -4778,10 +3919,6 @@ void tools_open_aux_img_data_unpack(union tools_open_aux_img_data *ptr_struct, c
 void tools_open_aux_img_data_print(const union tools_open_aux_img_data *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_aux_img_data ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "aux_data_hdr:\n");
@@ -4814,10 +3951,6 @@ void tools_open_hcr_cmds_unpack(union tools_open_hcr_cmds *ptr_struct, const u_i
 void tools_open_hcr_cmds_print(const union tools_open_hcr_cmds *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_hcr_cmds ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "query_def_params_global:\n");
@@ -4850,10 +3983,6 @@ void tools_open_access_registers_unpack(union tools_open_access_registers *ptr_s
 void tools_open_access_registers_print(const union tools_open_access_registers *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_access_registers ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "MNVReg:\n");
@@ -4886,10 +4015,6 @@ void tools_open_nv_cfg_unpack(union tools_open_nv_cfg *ptr_struct, const u_int8_
 void tools_open_nv_cfg_print(const union tools_open_nv_cfg *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_nv_cfg ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "wol:\n");
@@ -5010,10 +4135,6 @@ void tools_open_tools_open_unpack(union tools_open_tools_open *ptr_struct, const
 void tools_open_tools_open_print(const union tools_open_tools_open *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_tools_open ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "NVConfig:\n");
@@ -5047,11 +4168,6 @@ void tools_open_tools_open_dump(const union tools_open_tools_open *ptr_struct, F
 
 void tools_open_uint64_pack(const struct tools_open_uint64 *ptr_struct, u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	adb2c_push_integer_to_buff(ptr_buff, offset, 4, (u_int64_t)ptr_struct->hi);
@@ -5063,13 +4179,6 @@ void tools_open_uint64_pack(const struct tools_open_uint64 *ptr_struct, u_int8_t
 
 void tools_open_uint64_unpack(struct tools_open_uint64 *ptr_struct, const u_int8_t* ptr_buff){
 	u_int32_t offset;
-	int i=0;
-	u_int8_t val=0;
-	(void)val;
-	(void)offset;
-	(void)i;
-	(void)ptr_struct;
-	(void)ptr_buff;
 
 	offset=0;
 	ptr_struct->hi = (u_int32_t)adb2c_pop_integer_from_buff(ptr_buff, offset, 4);
@@ -5082,10 +4191,6 @@ void tools_open_uint64_unpack(struct tools_open_uint64 *ptr_struct, const u_int8
 void tools_open_uint64_print(const struct tools_open_uint64 *ptr_struct, FILE* file, int indent_level){
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "======== tools_open_uint64 ========\n");
-	int i=0;
-	(void)i;(void)ptr_struct;
-	(void)file;
-	(void)indent_level;
 
 	adb2c_add_indentation(file, indent_level);
 	fprintf(file, "hi                   : "U32H_FMT"\n", ptr_struct->hi);
-- 
2.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
