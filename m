From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ibqueryerrors.c: Add support for additional counters in
 PortCountersExtended
Date: Sat, 30 Sep 2017 01:42:17 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E67D31C52@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "'Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)'" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "odedni-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <odedni-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hal, Oded,

I have lost the original email from this submission but got it off of patchwork.

Question on the hunk below.

diff --git a/src/ibqueryerrors.c b/src/ibqueryerrors.c                                                       
index 304dc154c4b4..4ea762a1f344 100644                                                                      
--- a/src/ibqueryerrors.c                                                                                    
+++ b/src/ibqueryerrors.c                                                                                    
@@ -105,15 +105,15 @@ static unsigned valid_gid(ib_gid_t * gid)                                              
        return memcmp(&zero_gid, gid, sizeof(*gid));                                                         
 }                                                                                                           
                                                                                                             
-static void set_thres(char *name, uint32_t val)                                                             
+static void set_thres(char *name, uint64_t val)                                                             
 {                                                                                                           
        int f;                                                                                               
        int n;                                                                                               
        char tmp[256];                                                                                       
-       for (f = IB_PC_FIRST_F; f <= IB_PC_LAST_F; f++) {                                                    
+       for (f = IB_PC_EXT_ERR_SYM_F; f <= IB_PC_EXT_XMT_WAIT_F; f++) {                                      

How does this change allow for users to set the old Port Counters thresholds?

Ira


                if (strcmp(name, mad_field_name(f)) == 0) {                                                  
                        mad_encode_field(thresholds, f, &val);                                               
-                       snprintf(tmp, 255, "[%s = %u]", name, val);                                          
+                       snprintf(tmp, 255, "[%s = %lu]", name, val);                                         
                        threshold_str = realloc(threshold_str,                                               
                                        strlen(threshold_str)+strlen(tmp)+1);                                
                        if (!threshold_str) {                                                                
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
