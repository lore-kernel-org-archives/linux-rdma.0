From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] infiniband-diags/ibportstate.c: Add newly added
 options to usage
Date: Thu, 24 May 2012 13:42:29 -0400
Message-ID: <4FBE7305.9080302@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


espeed and fdr10

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/ibportstate.c b/src/ibportstate.c
index 5559d18..c633a45 100644
--- a/src/ibportstate.c
+++ b/src/ibportstate.c
@@ -350,8 +350,8 @@ int main(int argc, char **argv)
 	uint16_t devid, rem_devid;
 	long val;
 	char usage_args[] = "<dest dr_path|lid|guid> <portnum> [<op>]\n"
-	    "\nSupported ops: enable, disable, reset, speed, width, query,\n"
-	    "\tdown, arm, active, vls, mtu, lid, smlid, lmc\n";
+	    "\nSupported ops: enable, disable, reset, speed, espeed, fdr10,\n"
+	    "\twidth, query, down, arm, active, vls, mtu, lid, smlid, lmc\n";
 	const char *usage_examples[] = {
 		"3 1 disable\t\t\t# by lid",
 		"-G 0x2C9000100D051 1 enable\t# by guid",
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
