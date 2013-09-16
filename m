From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] ibdiag_sa.c: Output attribute ID in hex
 rather than decimal
Date: Mon, 16 Sep 2013 10:19:58 -0400
Message-ID: <5237138E.9060705@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


so that it's easier to correlate to IBA spec

For example:
saquery PKTR 20/1/0 --smkey 1
ibwarn: sa_query: umad_send failed: attr 51: Bad file description

0x33 would be easier than 51 as no conversion is required to
look it up in IBA spec.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/ibdiag_sa.c b/src/ibdiag_sa.c
index 7a5014c..018a428 100644
--- a/src/ibdiag_sa.c
+++ b/src/ibdiag_sa.c
@@ -112,7 +112,7 @@ int sa_query(struct sa_handle * h, uint8_t method,
 
 	ret = umad_send(h->fd, h->agent, umad, len, ibd_timeout, 0);
 	if (ret < 0) {
-		IBWARN("umad_send failed: attr %u: %s\n",
+		IBWARN("umad_send failed: attr 0x%x: %s\n",
 			attr, strerror(errno));
 		free(umad);
 		return (-ret);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
