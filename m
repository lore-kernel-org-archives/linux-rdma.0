From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/osm_switch.h: Fix commentary typo
Date: Tue, 20 Dec 2011 15:08:40 -0500
Message-ID: <4EF0EB48.8000701@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/opensm/osm_switch.h b/include/opensm/osm_switch.h
index a0dfbfc..de567ad 100644
--- a/include/opensm/osm_switch.h
+++ b/include/opensm/osm_switch.h
@@ -575,7 +575,7 @@ boolean_t osm_switch_get_lft_block(IN const osm_switch_t * p_sw,
 *
 *	p_block
 *		[out] Pointer to the 64 byte array to store the
-*		forwarding table clock specified by block_id.
+*		forwarding table block specified by block_id.
 *
 * RETURN VALUES
 *	Returns true if there are more blocks necessary to
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
