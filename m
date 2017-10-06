From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 31/47] IB/nes: Fix a race condition in nes_inetaddr_event()
Date: Fri,  6 Oct 2017 14:33:17 -0700
Message-ID: <20171006213333.6721-32-bart.vanassche@wdc.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch has been compile-tested only.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index ff58dfa071b8..42b68aa999fc 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -178,11 +178,16 @@ static int nes_inetaddr_event(struct notifier_block *notifier,
 					/* fall through */
 				case NETDEV_CHANGEADDR:
 					/* Add the address to the IP table */
-					if (upper_dev)
-						nesvnic->local_ipaddr =
-							((struct in_device *)upper_dev->ip_ptr)->ifa_list->ifa_address;
-					else
+					if (upper_dev) {
+						struct in_device *in;
+
+						rcu_read_lock();
+						in = __in_dev_get_rcu(upper_dev);
+						nesvnic->local_ipaddr = in->ifa_list->ifa_address;
+						rcu_read_unlock();
+					} else {
 						nesvnic->local_ipaddr = ifa->ifa_address;
+					}
 
 					nes_write_indexed(nesdev,
 							NES_IDX_DST_IP_ADDR+(0x10*PCI_FUNC(nesdev->pcidev->devfn)),
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
