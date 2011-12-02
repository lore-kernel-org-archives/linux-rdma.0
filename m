From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/3] infiniband-diags: move is_mlnx_ext_port_info_supported
 to common code
Date: Fri, 2 Dec 2011 12:00:13 -0800
Message-ID: <20111202120013.8d1a2efb.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
---
 include/ibdiag_common.h |    2 ++
 src/ibdiag_common.c     |    9 +++++++++
 src/ibportstate.c       |    9 ---------
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/ibdiag_common.h b/include/ibdiag_common.h
index 6586cc6..1d8cdc7 100644
--- a/include/ibdiag_common.h
+++ b/include/ibdiag_common.h
@@ -93,6 +93,8 @@ extern void iberror(const char *fn, char *msg, ...);
  */
 extern char *conv_cnt_human_readable(uint64_t val64, float *val, int data);
 
+int is_mlnx_ext_port_info_supported(uint32_t devid);
+
 /* define an SA query structure to be common
  * This is by no means optimal but it moves the saquery functionality out of
  * the saquery tool and provides it to other utilities.
diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
index 81d7878..e7c514a 100644
--- a/src/ibdiag_common.c
+++ b/src/ibdiag_common.c
@@ -455,6 +455,15 @@ conv_cnt_human_readable(uint64_t val64, float *val, int data)
 	return ("");
 }
 
+int is_mlnx_ext_port_info_supported(uint32_t devid)
+{
+	if (devid == 0xc738)
+		return 1;
+	if (devid >= 0x1003 && devid <= 0x1010)
+		return 1;
+	return 0;
+}
+
 /* define a common SA query structure
  * This is by no means optimal but it moves the saquery functionality out of
  * the saquery tool and provides it to other utilities.
diff --git a/src/ibportstate.c b/src/ibportstate.c
index daa8514..ec6b823 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -121,15 +121,6 @@ static int get_node_info(ib_portid_t * dest, uint8_t * data)
 		return 0;
 }
 
-static int is_mlnx_ext_port_info_supported(uint32_t devid)
-{
-	if (devid == 0xc738)
-		return 1;
-	if (devid >= 0x1003 && devid <= 0x1010)
-		return 1;
-	return 0;
-}
-
 static int get_port_info(ib_portid_t * dest, uint8_t * data, int portnum,
 			 int is_switch)
 {
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
