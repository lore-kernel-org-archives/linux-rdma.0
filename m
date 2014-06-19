From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH librdmacm] [TRIVIAL] cma: In ucma_convert_path, fix selector
 values
Date: Thu, 19 Jun 2014 13:08:02 -0400
Message-ID: <53A318F2.2030601@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Intent is for the selectors to be equal to (exactly) rather than less than.
Selector for exactly is value of 2 rather than 1.

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/cma.c b/src/cma.c
index bedc95f..a2543f2 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -701,11 +701,11 @@ static void ucma_convert_path(struct ibv_path_data *path_data,
 	sa_path->numb_path = 1;
 	sa_path->pkey = path_data->path.pkey;
 	sa_path->sl = ntohs(path_data->path.qosclass_sl) & 0xF;
-	sa_path->mtu_selector = 1;
+	sa_path->mtu_selector = 2;	/* exactly */
 	sa_path->mtu = path_data->path.mtu & 0x1F;
-	sa_path->rate_selector = 1;
+	sa_path->rate_selector = 2;
 	sa_path->rate = path_data->path.rate & 0x1F;
-	sa_path->packet_life_time_selector = 1;
+	sa_path->packet_life_time_selector = 2;
 	sa_path->packet_life_time = path_data->path.packetlifetime & 0x1F;
 
 	sa_path->preference = (uint8_t) path_data->flags;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
