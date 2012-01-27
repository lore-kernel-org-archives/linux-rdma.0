From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH, RFC] nes: Add missing rcu_read_unlock() call
Date: Fri, 27 Jan 2012 09:56:39 -0800
Message-ID: <CAL1RGDX8G71Vb1C9AGg_7sT5zoNPb8EyXrf+n1N1dAWDMbPo_A@mail.gmail.com>
References: <7025497.ASMhoMrTFM@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7025497.ASMhoMrTFM@asus>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Good catch.  I think it's closer to kernel idiom to jump to one unwind
path, though:

RDMA/nes: Add missing rcu_read_unlock() in nes_addr_resolve_neigh()

Make sure all exit paths from this function unlock everything.

Reported-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_cm.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c
b/drivers/infiniband/hw/nes/nes_cm.c
index 183f7ab..271279c 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -1363,8 +1363,7 @@ static int nes_addr_resolve_neigh(struct
nes_vnic *nesvnic, u32 dst_ip, int arpi
                                if
(!memcmp(nesadapter->arp_table[arpindex].mac_addr,
                                            neigh->ha, ETH_ALEN)) {
                                        /* Mac address same as in
nes_arp_table */
-                                       ip_rt_put(rt);
-                                       return rc;
+                                       goto out;
                                }

                                nes_manage_arp_cache(nesvnic->netdev,
@@ -1380,6 +1379,8 @@ static int nes_addr_resolve_neigh(struct
nes_vnic *nesvnic, u32 dst_ip, int arpi
                        neigh_event_send(neigh, NULL);
                }
        }
+
+out:
        rcu_read_unlock();
        ip_rt_put(rt);
        return rc;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
