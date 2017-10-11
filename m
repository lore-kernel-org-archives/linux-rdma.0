From: "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 30/45] IB/nes: Fix a race condition in
 nes_inetaddr_event()
Date: Wed, 11 Oct 2017 18:13:09 +0000
Message-ID: <1EEBC91386407A4A8D1EBE1DD5AA5212822DF09F@FMSMSX114.amr.corp.intel.com>
References: <20171011174927.25113-1-bart.vanassche@wdc.com>
 <20171011174927.25113-31-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171011174927.25113-31-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>From: Bart Van Assche [mailto:bart.vanassche-Sjgp3cTcYWE@public.gmane.org]
>Sent: Wednesday, October 11, 2017 12:49 PM
>To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>;
>Latif, Faisal <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>Subject: [PATCH v2 30/45] IB/nes: Fix a race condition in nes_inetaddr_event()
>
>This patch has been compile-tested only.
>
>Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
>Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>---
> drivers/infiniband/hw/nes/nes.c | 13 +++++++++----
> 1 file changed, 9 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
>index ff58dfa071b8..42b68aa999fc 100644
>--- a/drivers/infiniband/hw/nes/nes.c
>+++ b/drivers/infiniband/hw/nes/nes.c
>@@ -178,11 +178,16 @@ static int nes_inetaddr_event(struct notifier_block
>*notifier,
> 					/* fall through */
> 				case NETDEV_CHANGEADDR:
> 					/* Add the address to the IP table */
>-					if (upper_dev)
>-						nesvnic->local_ipaddr =
>-							((struct in_device
>*)upper_dev->ip_ptr)->ifa_list->ifa_address;
>-					else
>+					if (upper_dev) {
>+						struct in_device *in;
>+
>+						rcu_read_lock();
>+						in =
>__in_dev_get_rcu(upper_dev);
>+						nesvnic->local_ipaddr = in-
>>ifa_list->ifa_address;
>+						rcu_read_unlock();
>+					} else {
> 						nesvnic->local_ipaddr = ifa-
>>ifa_address;
>+					}
>
> 					nes_write_indexed(nesdev,
>
>	NES_IDX_DST_IP_ADDR+(0x10*PCI_FUNC(nesdev->pcidev->devfn)),
>--
>2.14.2
Acked-by: Faisal Latif <fasial.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
