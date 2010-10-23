From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC 9/12] ib-mgmt: convert ib_types.h to use umad types
Date: Sat, 23 Oct 2010 00:10:20 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B7F9@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B7EE@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B7EE-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Several data type definitions have been added to umad.
Update ib_types.h to make use of these definitions.  For
backwards compatibility, the existing names in ib_types.h
are kept until they can be deprecated.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 opensm/include/iba/ib_types.h |  186 +++++++++++++++++++++--------------------
 1 files changed, 94 insertions(+), 92 deletions(-)
 mode change 100644 => 100755 opensm/include/iba/ib_types.h

diff --git a/opensm/include/iba/ib_types.h b/opensm/include/iba/ib_types.h
old mode 100644
new mode 100755
index e1bc102..86b31b0
--- a/opensm/include/iba/ib_types.h
+++ b/opensm/include/iba/ib_types.h
@@ -40,6 +40,8 @@
 #include <string.h>
 #include <complib/cl_types.h>
 #include <complib/cl_byteswap.h>
+#include <infiniband/umad_types.h>
+#include <infiniband/umad_sa.h>

 #ifdef __cplusplus
 #  define BEGIN_C_DECLS extern "C" {
@@ -105,7 +107,7 @@ BEGIN_C_DECLS
 *
 * SOURCE
 */
-#define MAD_RMPP_DATA_SIZE             (MAD_BLOCK_SIZE - MAD_RMPP_HDR_SIZE)
+#define MAD_RMPP_DATA_SIZE                     UMAD_LEN_RMPP_DATA
 /**********/
 /****d* IBA Base: Constants/MAD_BLOCK_GRH_SIZE
 * NAME
@@ -409,7 +411,7 @@ BEGIN_C_DECLS
 *
 * SOURCE
 */
-#define IB_MCLASS_SUBN_LID                                     0x01
+#define IB_MCLASS_SUBN_LID                                     UMAD_CLASS_SUBN_LID_ROUTED
 /**********/
 /****d* IBA Base: Constants/IB_MCLASS_SUBN_DIR
 * NAME
@@ -420,7 +422,7 @@ BEGIN_C_DECLS
 *
 * SOURCE
 */
-#define IB_MCLASS_SUBN_DIR                                     0x81
+#define IB_MCLASS_SUBN_DIR                                     UMAD_CLASS_SUBN_DIRECTED_ROUTE
 /**********/
 /****d* IBA Base: Constants/IB_MCLASS_SUBN_ADM
 * NAME
@@ -431,7 +433,7 @@ BEGIN_C_DECLS
 *
 * SOURCE
 */
-#define IB_MCLASS_SUBN_ADM                                     0x03
+#define IB_MCLASS_SUBN_ADM                                     UMAD_CLASS_SUBN_ADM
 /**********/
 /****d* IBA Base: Constants/IB_MCLASS_PERF
 * NAME
@@ -442,7 +444,7 @@ BEGIN_C_DECLS
 *
 * SOURCE
 */
-#define IB_MCLASS_PERF                                         0x04
+#define IB_MCLASS_PERF                                         UMAD_CLASS_PERF_MGMT
 /**********/
 /****d* IBA Base: Constants/IB_MCLASS_BM
 * NAME
@@ -453,7 +455,7 @@ BEGIN_C_DECLS
 *
 * SOURCE
 */
-#define IB_MCLASS_BM                                           0x05
+#define IB_MCLASS_BM                                           UMAD_CLASS_BM
 /**********/
 /****d* IBA Base: Constants/IB_MCLASS_DEV_MGMT
 * NAME
@@ -464,7 +466,7 @@ BEGIN_C_DECLS
 *
 * SOURCE
 */
-#define IB_MCLASS_DEV_MGMT                                     0x06
+#define IB_MCLASS_DEV_MGMT                                     UMAD_CLASS_DEVICE_MGMT
 /**********/
 /****d* IBA Base: Constants/IB_MCLASS_COMM_MGMT
 * NAME
@@ -475,7 +477,7 @@ BEGIN_C_DECLS
 *
 * SOURCE
 */
-#define IB_MCLASS_COMM_MGMT                                    0x07
+#define IB_MCLASS_COMM_MGMT                                    UMAD_CLASS_CM
 /**********/
 /****d* IBA Base: Constants/IB_MCLASS_SNMP
 * NAME
@@ -486,7 +488,7 @@ BEGIN_C_DECLS
 *
 * SOURCE
 */
-#define IB_MCLASS_SNMP                                         0x08
+#define IB_MCLASS_SNMP                                         UMAD_CLASS_SNMP
 /**********/
 /****d* IBA Base: Constants/IB_MCLASS_VENDOR_LOW_RANGE_MIN
 * NAME
@@ -497,7 +499,7 @@ BEGIN_C_DECLS
 *
 * SOURCE
 */
-#define IB_MCLASS_VENDOR_LOW_RANGE_MIN 0x09
+#define IB_MCLASS_VENDOR_LOW_RANGE_MIN UMAD_CLASS_VENDOR_RANGE1_START
 /**********/
 /****d* IBA Base: Constants/IB_MCLASS_VENDOR_LOW_RANGE_MAX
 * NAME
@@ -508,7 +510,7 @@ BEGIN_C_DECLS
 *
 * SOURCE
 */
-#define IB_MCLASS_VENDOR_LOW_RANGE_MAX 0x0f
+#define IB_MCLASS_VENDOR_LOW_RANGE_MAX UMAD_CLASS_VENDOR_RANGE1_END
 /**********/
 /****d* IBA Base: Constants/IB_MCLASS_DEV_ADM
 * NAME
@@ -519,7 +521,7 @@ BEGIN_C_DECLS
 *
 * SOURCE
 */
-#define IB_MCLASS_DEV_ADM 0x10
+#define IB_MCLASS_DEV_ADM UMAD_CLASS_DEVICE_ADM
 /**********/
 /****d* IBA Base: Constants/IB_MCLASS_BIS
 * NAME
@@ -530,7 +532,7 @@ BEGIN_C_DECLS
 *
 * SOURCE
 */
-#define IB_MCLASS_BIS 0x12
+#define IB_MCLASS_BIS UMAD_CLASS_BIS
 /**********/
 /****d* IBA Base: Constants/IB_MCLASS_CC
 * NAME
@@ -541,7 +543,7 @@ BEGIN_C_DECLS
 *
 * SOURCE
 */
-#define IB_MCLASS_CC 0x21
+#define IB_MCLASS_CC UMAD_CLASS_CONG_MGMT
 /**********/
 /****d* IBA Base: Constants/IB_MCLASS_VENDOR_HIGH_RANGE_MIN
 * NAME
@@ -552,7 +554,7 @@ BEGIN_C_DECLS
 *
 * SOURCE
 */
-#define IB_MCLASS_VENDOR_HIGH_RANGE_MIN 0x30
+#define IB_MCLASS_VENDOR_HIGH_RANGE_MIN UMAD_CLASS_VENDOR_RANGE2_START
 /**********/
 /****d* IBA Base: Constants/IB_MCLASS_VENDOR_HIGH_RANGE_MAX
 * NAME
@@ -563,7 +565,7 @@ BEGIN_C_DECLS
 *
 * SOURCE
 */
-#define IB_MCLASS_VENDOR_HIGH_RANGE_MAX 0x4f
+#define IB_MCLASS_VENDOR_HIGH_RANGE_MAX UMAD_CLASS_VENDOR_RANGE2_END
 /**********/
 /****f* IBA Base: Types/ib_class_is_vendor_specific_low
 * NAME
@@ -578,8 +580,8 @@ BEGIN_C_DECLS
 static inline boolean_t OSM_API
 ib_class_is_vendor_specific_low(IN const uint8_t class_code)
 {
-       return ((class_code >= IB_MCLASS_VENDOR_LOW_RANGE_MIN) &&
-               (class_code <= IB_MCLASS_VENDOR_LOW_RANGE_MAX));
+       return ((class_code >= UMAD_CLASS_VENDOR_RANGE1_START) &&
+               (class_code <= UMAD_CLASS_VENDOR_RANGE1_END));
 }

 /*
@@ -610,8 +612,8 @@ ib_class_is_vendor_specific_low(IN const uint8_t class_code)
 static inline boolean_t OSM_API
 ib_class_is_vendor_specific_high(IN const uint8_t class_code)
 {
-       return ((class_code >= IB_MCLASS_VENDOR_HIGH_RANGE_MIN) &&
-               (class_code <= IB_MCLASS_VENDOR_HIGH_RANGE_MAX));
+       return ((class_code >= UMAD_CLASS_VENDOR_RANGE2_START) &&
+               (class_code <= UMAD_CLASS_VENDOR_RANGE2_END));
 }

 /*
@@ -671,10 +673,10 @@ ib_class_is_vendor_specific(IN const uint8_t class_code)
 */
 static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 {
-       return ((class_code == IB_MCLASS_SUBN_ADM) ||
-               (class_code == IB_MCLASS_DEV_MGMT) ||
-               (class_code == IB_MCLASS_DEV_ADM) ||
-               (class_code == IB_MCLASS_BIS) ||
+       return ((class_code == UMAD_CLASS_SUBN_ADM) ||
+               (class_code == UMAD_CLASS_DEVICE_MGMT) ||
+               (class_code == UMAD_CLASS_DEVICE_ADM) ||
+               (class_code == UMAD_CLASS_BIS) ||
                ib_class_is_vendor_specific_high(class_code));
 }

@@ -716,7 +718,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_METHOD_RESP_MASK                                0x80
+#define IB_MAD_METHOD_RESP_MASK                                UMAD_METHOD_RESP
 /**********/

 /****d* IBA Base: Constants/IB_MAD_METHOD_GET
@@ -728,7 +730,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_METHOD_GET                                      0x01
+#define IB_MAD_METHOD_GET                                      UMAD_METHOD_GET
 /**********/

 /****d* IBA Base: Constants/IB_MAD_METHOD_SET
@@ -740,7 +742,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_METHOD_SET                                      0x02
+#define IB_MAD_METHOD_SET                                      UMAD_METHOD_SET
 /**********/

 /****d* IBA Base: Constants/IB_MAD_METHOD_GET_RESP
@@ -752,10 +754,10 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_METHOD_GET_RESP                         0x81
+#define IB_MAD_METHOD_GET_RESP                         UMAD_METHOD_GET_RESP
 /**********/

-#define IB_MAD_METHOD_DELETE                           0x15
+#define IB_MAD_METHOD_DELETE                           UMAD_SA_METHOD_DELETE

 /****d* IBA Base: Constants/IB_MAD_METHOD_GETTABLE
 * NAME
@@ -766,7 +768,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_METHOD_GETTABLE                         0x12
+#define IB_MAD_METHOD_GETTABLE                         UMAD_SA_METHOD_GET_TABLE
 /**********/

 /****d* IBA Base: Constants/IB_MAD_METHOD_GETTABLE_RESP
@@ -778,13 +780,13 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_METHOD_GETTABLE_RESP                    0x92
+#define IB_MAD_METHOD_GETTABLE_RESP                    UMAD_SA_METHOD_GET_TABLE_RESP

 /**********/

-#define IB_MAD_METHOD_GETTRACETABLE                    0x13
-#define IB_MAD_METHOD_GETMULTI                         0x14
-#define IB_MAD_METHOD_GETMULTI_RESP                    0x94
+#define IB_MAD_METHOD_GETTRACETABLE                    UMAD_SA_METHOD_GET_TRACE_TABLE
+#define IB_MAD_METHOD_GETMULTI                         UMAD_SA_METHOD_GET_MULTI
+#define IB_MAD_METHOD_GETMULTI_RESP                    UMAD_SA_METHOD_GET_MULTI_RESP

 /****d* IBA Base: Constants/IB_MAD_METHOD_SEND
 * NAME
@@ -795,7 +797,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_METHOD_SEND                                     0x03
+#define IB_MAD_METHOD_SEND                                     UMAD_METHOD_SEND
 /**********/

 /****d* IBA Base: Constants/IB_MAD_METHOD_TRAP
@@ -807,7 +809,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_METHOD_TRAP                                     0x05
+#define IB_MAD_METHOD_TRAP                                     UMAD_METHOD_TRAP
 /**********/

 /****d* IBA Base: Constants/IB_MAD_METHOD_REPORT
@@ -819,7 +821,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_METHOD_REPORT                           0x06
+#define IB_MAD_METHOD_REPORT                           UMAD_METHOD_REPORT
 /**********/

 /****d* IBA Base: Constants/IB_MAD_METHOD_REPORT_RESP
@@ -831,7 +833,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_METHOD_REPORT_RESP                      0x86
+#define IB_MAD_METHOD_REPORT_RESP                      UMAD_METHOD_REPORT_RESP
 /**********/

 /****d* IBA Base: Constants/IB_MAD_METHOD_TRAP_REPRESS
@@ -843,7 +845,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_METHOD_TRAP_REPRESS                     0x07
+#define IB_MAD_METHOD_TRAP_REPRESS                     UMAD_METHOD_TRAP_REPRESS
 /**********/

 /****d* IBA Base: Constants/IB_MAD_STATUS_BUSY
@@ -855,7 +857,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_STATUS_BUSY                             (CL_HTON16(0x0001))
+#define IB_MAD_STATUS_BUSY                             (CL_HTON16(UMAD_STATUS_BUSY))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_STATUS_REDIRECT
@@ -867,7 +869,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_STATUS_REDIRECT                         (CL_HTON16(0x0002))
+#define IB_MAD_STATUS_REDIRECT                         (CL_HTON16(UMAD_STATUS_REDIRECT))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_STATUS_UNSUP_CLASS_VER
@@ -879,7 +881,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_STATUS_UNSUP_CLASS_VER                  (CL_HTON16(0x0004))
+#define IB_MAD_STATUS_UNSUP_CLASS_VER                  (CL_HTON16(UMAD_STATUS_BAD_VERSION))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_STATUS_UNSUP_METHOD
@@ -891,7 +893,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_STATUS_UNSUP_METHOD                     (CL_HTON16(0x0008))
+#define IB_MAD_STATUS_UNSUP_METHOD                     (CL_HTON16(UMAD_STATUS_METHOD_NOT_SUPPORTED))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_STATUS_UNSUP_METHOD_ATTR
@@ -903,7 +905,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_STATUS_UNSUP_METHOD_ATTR                        (CL_HTON16(0x000C))
+#define IB_MAD_STATUS_UNSUP_METHOD_ATTR                        (CL_HTON16(UMAD_STATUS_ATTR_NOT_SUPPORTED))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_STATUS_INVALID_FIELD
@@ -915,10 +917,10 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_STATUS_INVALID_FIELD                    (CL_HTON16(0x001C))
+#define IB_MAD_STATUS_INVALID_FIELD                    (CL_HTON16(UMAD_STATUS_INVALID_ATTR_VALUE))
 /**********/

-#define IB_MAD_STATUS_CLASS_MASK                       (CL_HTON16(0xFF00))
+#define IB_MAD_STATUS_CLASS_MASK                       (CL_HTON16(UMAD_STATUS_CLASS_MASK))

 #define IB_SA_MAD_STATUS_SUCCESS                       (CL_HTON16(0x0000))
 #define IB_SA_MAD_STATUS_NO_RESOURCES                  (CL_HTON16(0x0100))
@@ -943,7 +945,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_ATTR_CLASS_PORT_INFO                    (CL_HTON16(0x0001))
+#define IB_MAD_ATTR_CLASS_PORT_INFO                    (CL_HTON16(UMAD_ATTR_CLASS_PORT_INFO))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_ATTR_NOTICE
@@ -955,7 +957,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_ATTR_NOTICE                                     (CL_HTON16(0x0002))
+#define IB_MAD_ATTR_NOTICE                                     (CL_HTON16(UMAD_ATTR_NOTICE))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_ATTR_INFORM_INFO
@@ -967,7 +969,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_ATTR_INFORM_INFO                                (CL_HTON16(0x0003))
+#define IB_MAD_ATTR_INFORM_INFO                                (CL_HTON16(UMAD_ATTR_INFORM_INFO))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_ATTR_NODE_DESC
@@ -1182,7 +1184,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_ATTR_NODE_RECORD                                (CL_HTON16(0x0011))
+#define IB_MAD_ATTR_NODE_RECORD                                (CL_HTON16(UMAD_SA_ATTR_NODE_REC))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_ATTR_PORTINFO_RECORD
@@ -1194,7 +1196,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_ATTR_PORTINFO_RECORD                    (CL_HTON16(0x0012))
+#define IB_MAD_ATTR_PORTINFO_RECORD                    (CL_HTON16(UMAD_SA_ATTR_PORT_INFO_REC))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_ATTR_SWITCH_INFO_RECORD
@@ -1206,7 +1208,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_ATTR_SWITCH_INFO_RECORD                 (CL_HTON16(0x0014))
+#define IB_MAD_ATTR_SWITCH_INFO_RECORD                 (CL_HTON16(UMAD_SA_ATTR_SWITCH_INFO_REC))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_ATTR_LINK_RECORD
@@ -1218,7 +1220,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_ATTR_LINK_RECORD                                (CL_HTON16(0x0020))
+#define IB_MAD_ATTR_LINK_RECORD                                (CL_HTON16(UMAD_SA_ATTR_LINK_REC))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_ATTR_SM_INFO
@@ -1242,7 +1244,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_ATTR_SMINFO_RECORD                      (CL_HTON16(0x0018))
+#define IB_MAD_ATTR_SMINFO_RECORD                      (CL_HTON16(UMAD_SA_ATTR_SM_INFO_REC))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_ATTR_GUIDINFO_RECORD
@@ -1254,7 +1256,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_ATTR_GUIDINFO_RECORD                    (CL_HTON16(0x0030))
+#define IB_MAD_ATTR_GUIDINFO_RECORD                    (CL_HTON16(UMAD_SA_ATTR_GUID_INFO_REC))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_ATTR_VENDOR_DIAG
@@ -1290,7 +1292,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_ATTR_SERVICE_RECORD                     (CL_HTON16(0x0031))
+#define IB_MAD_ATTR_SERVICE_RECORD                     (CL_HTON16(UMAD_SA_ATTR_SERVICE_REC))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_ATTR_LFT_RECORD
@@ -1302,7 +1304,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_ATTR_LFT_RECORD                         (CL_HTON16(0x0015))
+#define IB_MAD_ATTR_LFT_RECORD                         (CL_HTON16(UMAD_SA_ATTR_LINEAR_FT_REC))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_ATTR_MFT_RECORD
@@ -1314,7 +1316,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_ATTR_MFT_RECORD                         (CL_HTON16(0x0017))
+#define IB_MAD_ATTR_MFT_RECORD                         (CL_HTON16(UMAD_SA_ATTR_MCAST_FT_REC))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_ATTR_PKEYTBL_RECORD
@@ -1326,7 +1328,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_ATTR_PKEY_TBL_RECORD                    (CL_HTON16(0x0033))
+#define IB_MAD_ATTR_PKEY_TBL_RECORD                    (CL_HTON16(UMAD_SA_ATTR_PKEY_TABLE_REC))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_ATTR_PATH_RECORD
@@ -1338,7 +1340,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_ATTR_PATH_RECORD                                (CL_HTON16(0x0035))
+#define IB_MAD_ATTR_PATH_RECORD                                (CL_HTON16(UMAD_SA_ATTR_PATH_REC))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_ATTR_VLARB_RECORD
@@ -1350,7 +1352,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_ATTR_VLARB_RECORD                       (CL_HTON16(0x0036))
+#define IB_MAD_ATTR_VLARB_RECORD                       (CL_HTON16(UMAD_SA_ATTR_VL_ARB_REC))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_ATTR_SLVL_RECORD
@@ -1362,7 +1364,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_ATTR_SLVL_RECORD                                (CL_HTON16(0x0013))
+#define IB_MAD_ATTR_SLVL_RECORD                                (CL_HTON16(UMAD_SA_ATTR_SLVL_REC))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_ATTR_MCMEMBER_RECORD
@@ -1374,7 +1376,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_ATTR_MCMEMBER_RECORD                    (CL_HTON16(0x0038))
+#define IB_MAD_ATTR_MCMEMBER_RECORD                    (CL_HTON16(UMAD_SA_ATTR_MCMEMBER_REC))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_ATTR_TRACE_RECORD
@@ -1386,7 +1388,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_ATTR_TRACE_RECORD                       (CL_HTON16(0x0039))
+#define IB_MAD_ATTR_TRACE_RECORD                       (CL_HTON16(UMAD_SA_ATTR_TRACE_REC))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_ATTR_MULTIPATH_RECORD
@@ -1398,7 +1400,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_ATTR_MULTIPATH_RECORD                   (CL_HTON16(0x003A))
+#define IB_MAD_ATTR_MULTIPATH_RECORD                   (CL_HTON16(UMAD_SA_ATTR_MULTI_PATH_REC))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_ATTR_SVC_ASSOCIATION_RECORD
@@ -1410,7 +1412,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_ATTR_SVC_ASSOCIATION_RECORD             (CL_HTON16(0x003B))
+#define IB_MAD_ATTR_SVC_ASSOCIATION_RECORD             (CL_HTON16(UMAD_SA_ATTR_SERVICE_ASSOC_REC))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_ATTR_INFORM_INFO_RECORD
@@ -1422,7 +1424,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_ATTR_INFORM_INFO_RECORD                 (CL_HTON16(0x00F3))
+#define IB_MAD_ATTR_INFORM_INFO_RECORD                 (CL_HTON16(UMAD_SA_ATTR_INFORM_INFO_REC))

 /****d* IBA Base: Constants/IB_MAD_ATTR_IO_UNIT_INFO
 * NAME
@@ -1529,7 +1531,7 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 *
 * SOURCE
 */
-#define IB_MAD_ATTR_SVC_ASSOCIATION_RECORD     (CL_HTON16(0x003B))
+#define IB_MAD_ATTR_SVC_ASSOCIATION_RECORD     (CL_HTON16(UMAD_SA_ATTR_SERVICE_ASSOC_REC))
 /**********/

 /****d* IBA Base: Constants/IB_MAD_ATTR_CONG_INFO
@@ -3931,28 +3933,28 @@ ib_mad_is_response(IN const ib_mad_t * const p_mad)
 *      ib_mad_t
 *********/

-#define IB_RMPP_TYPE_DATA              1
-#define IB_RMPP_TYPE_ACK               2
-#define IB_RMPP_TYPE_STOP              3
-#define IB_RMPP_TYPE_ABORT             4
-
-#define IB_RMPP_NO_RESP_TIME           0x1F
-#define IB_RMPP_FLAG_ACTIVE            0x01
-#define IB_RMPP_FLAG_FIRST             0x02
-#define IB_RMPP_FLAG_LAST              0x04
-
-#define IB_RMPP_STATUS_SUCCESS         0
-#define IB_RMPP_STATUS_RESX            1       /* resources exhausted */
-#define IB_RMPP_STATUS_T2L             118     /* time too long */
-#define IB_RMPP_STATUS_BAD_LEN         119     /* incon. last and payload len */
-#define IB_RMPP_STATUS_BAD_SEG         120     /* incon. first and segment no */
-#define IB_RMPP_STATUS_BADT            121     /* bad rmpp type */
-#define IB_RMPP_STATUS_W2S             122     /* newwindowlast too small */
-#define IB_RMPP_STATUS_S2B             123     /* segment no too big */
-#define IB_RMPP_STATUS_BAD_STATUS      124     /* illegal status */
-#define IB_RMPP_STATUS_UNV             125     /* unsupported version */
-#define IB_RMPP_STATUS_TMR             126     /* too many retries */
-#define IB_RMPP_STATUS_UNSPEC          127     /* unspecified */
+#define IB_RMPP_TYPE_DATA              UMAD_RMPP_TYPE_DATA
+#define IB_RMPP_TYPE_ACK               UMAD_RMPP_TYPE_ACK
+#define IB_RMPP_TYPE_STOP              UMAD_RMPP_TYPE_STOP
+#define IB_RMPP_TYPE_ABORT             UMAD_RMPP_TYPE_ABORT
+
+#define IB_RMPP_NO_RESP_TIME           UMAD_RMPP_NO_RESPTIME
+#define IB_RMPP_FLAG_ACTIVE            UMAD_RMPP_FLAG_ACTIVE
+#define IB_RMPP_FLAG_FIRST             UMAD_RMPP_FLAG_FIRST
+#define IB_RMPP_FLAG_LAST              UMAD_RMPP_FLAG_LAST
+
+#define IB_RMPP_STATUS_SUCCESS         UMAD_RMPP_STATUS_SUCCESS
+#define IB_RMPP_STATUS_RESX            UMAD_RMPP_STATUS_RESX   /* resources exhausted */
+#define IB_RMPP_STATUS_T2L             UMAD_RMPP_STATUS_T2L    /* time too long */
+#define IB_RMPP_STATUS_BAD_LEN         UMAD_RMPP_STATUS_BAD_LEN /* incon. last and payload len */
+#define IB_RMPP_STATUS_BAD_SEG         UMAD_RMPP_STATUS_BAD_SEG /* incon. first and segment no */
+#define IB_RMPP_STATUS_BADT            UMAD_RMPP_STATUS_BADT   /* bad rmpp type */
+#define IB_RMPP_STATUS_W2S             UMAD_RMPP_STATUS_W2S    /* newwindowlast too small */
+#define IB_RMPP_STATUS_S2B             UMAD_RMPP_STATUS_S2B    /* segment no too big */
+#define IB_RMPP_STATUS_BAD_STATUS      UMAD_RMPP_STATUS_BAD_STATUS /* illegal status */
+#define IB_RMPP_STATUS_UNV             UMAD_RMPP_STATUS_UNV    /* unsupported version */
+#define IB_RMPP_STATUS_TMR             UMAD_RMPP_STATUS_TMR    /* too many retries */
+#define IB_RMPP_STATUS_UNSPEC          UMAD_RMPP_STATUS_UNSPEC /* unspecified */

 /****f* IBA Base: Types/ib_rmpp_is_flag_set
 * NAME
@@ -4358,7 +4360,7 @@ typedef struct _ib_node_info {
 *
 * SYNOPSIS
 */
-#define IB_SA_DATA_SIZE 200
+#define IB_SA_DATA_SIZE UMAD_LEN_SA_DATA

 #include <complib/cl_packon.h>
 typedef struct _ib_sa_mad {
@@ -4386,7 +4388,7 @@ typedef struct _ib_sa_mad {
 } PACK_SUFFIX ib_sa_mad_t;
 #include <complib/cl_packoff.h>
 /**********/
-#define IB_SA_MAD_HDR_SIZE (sizeof(ib_sa_mad_t) - IB_SA_DATA_SIZE)
+#define IB_SA_MAD_HDR_SIZE (sizeof(ib_sa_mad_t) - UMAD_LEN_SA_DATA)

 static inline uint32_t OSM_API ib_get_attr_size(IN const ib_net16_t attr_offset)
 {


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
