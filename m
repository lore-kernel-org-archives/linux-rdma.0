From: Viral Mehta <Viral.Mehta-oonXi/34qI7c+919tysfdA@public.gmane.org>
Subject: RE: [PATCH 2/4] RDMA/nes: send IB_EVENT_PORT_ERR/PORT_ACTIVE event
 on	link state interrupt
Date: Thu, 25 Nov 2010 01:26:47 +0530
Message-ID: <D69C90565D53114396BF743585AF5A09122E61E8AD@VSHINMSMBX01.vshodc.lntinfotech.com>
References: <20101124172930.14764.20947.stgit@linux.site>,<20101124172938.14764.49859.stgit@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101124172938.14764.49859.stgit-YbU/o29LwNHN0uC3ymp8PA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maciej Sosnowski <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

>Depending on link state change IB_EVENT_PORT_ERR or IB_EVENT_PORT_ACTIVE
>should be dispatched in processing of mac interrupt.
>Plug in the cable happen to result in series of interrupts
>changing driver's link state for a number of times before finally
>staying at link up (e.g. link up, link down, link up, link down, ..., link up).
>To prevent sending series of redundant IB_EVENT_PORT_ACTIVE
>and IB_EVENT_PORT_ERR events they get filtered out by timer based
>nes_port_ibevent() routine.

>Signed-off-by: Maciej Sosnowski maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

>diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
>index 1980a46..2b89b06 100644
>--- a/drivers/infiniband/hw/nes/nes_hw.c
>+++ b/drivers/infiniband/hw/nes/nes_hw.c
>@@ -2608,6 +2608,13 @@ static void nes_process_mac_intr(struct
>                                               netif_start_queue(nesvnic->netdev);
>                                      nesvnic->linkup = 1;
>                                        netif_carrier_on(nesvnic->netdev);
>+
>+                                       spin_lock(&nesvnic->port_ibevent_lock);
>+                                       if (nesdev->iw_status == 0) {
>+                                               nesdev->iw_status = 1;
>+                                               nes_port_ibevent(nesvnic);
>+                                       }
>+                                       spin_unlock(&nesvnic->port_ibevent_lock);

Is it really "nes_port_ibevent" needed surrounded by spin_lock/unlock ?
To me it looks like setting iw_status to atomic_t and doing atomic operations are enough....

--
Viral

This Email may contain confidential or privileged information for the intended recipient (s) If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.

______________________________________________________________________
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
