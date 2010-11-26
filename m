From: "Sosnowski, Maciej" <maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/4] RDMA/nes: send IB_EVENT_PORT_ERR/PORT_ACTIVE event
 on	link state interrupt
Date: Fri, 26 Nov 2010 13:18:06 +0000
Message-ID: <129600E5E5FB004392DDC3FB599660D70104DF8A1D@irsmsx504.ger.corp.intel.com>
References: <20101124172930.14764.20947.stgit@linux.site>,<20101124172938.14764.49859.stgit@linux.site>
 <D69C90565D53114396BF743585AF5A09122E61E8AD@VSHINMSMBX01.vshodc.lntinfotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D69C90565D53114396BF743585AF5A09122E61E8AD-fVvhrSDAkVjuuPCCJ6VnObSn4PsL5ZDKvpI+GvaZM4lBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Viral Mehta <Viral.Mehta-oonXi/34qI7c+919tysfdA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Viral Mehta wrote:
>Hi,
>
>>Depending on link state change IB_EVENT_PORT_ERR or
>IB_EVENT_PORT_ACTIVE
>>should be dispatched in processing of mac interrupt.
>>Plug in the cable happen to result in series of interrupts
>>changing driver's link state for a number of times before finally
>>staying at link up (e.g. link up, link down, link up, link down, ...,
>link up).
>>To prevent sending series of redundant IB_EVENT_PORT_ACTIVE
>>and IB_EVENT_PORT_ERR events they get filtered out by timer based
>>nes_port_ibevent() routine.
>
>>Signed-off-by: Maciej Sosnowski maciej.sosnowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
>
>>diff --git a/drivers/infiniband/hw/nes/nes_hw.c
>b/drivers/infiniband/hw/nes/nes_hw.c
>>index 1980a46..2b89b06 100644
>>--- a/drivers/infiniband/hw/nes/nes_hw.c
>>+++ b/drivers/infiniband/hw/nes/nes_hw.c
>>@@ -2608,6 +2608,13 @@ static void nes_process_mac_intr(struct
>>
>netif_start_queue(nesvnic->netdev);
>>                                      nesvnic->linkup = 1;
>>                                        netif_carrier_on(nesvnic-
>>netdev);
>>+
>>+                                       spin_lock(&nesvnic-
>>port_ibevent_lock);
>>+                                       if (nesdev->iw_status == 0) {
>>+                                               nesdev->iw_status = 1;
>>+
>nes_port_ibevent(nesvnic);
>>+                                       }
>>+                                       spin_unlock(&nesvnic-
>>port_ibevent_lock);
>
>Is it really "nes_port_ibevent" needed surrounded by spin_lock/unlock ?
>To me it looks like setting iw_status to atomic_t and doing atomic
>operations are enough....
>

Hi Viral,

I am afraid it is not enough.
We need to keep locks around nes_port_ibevent as well to ensure
that correct port state events get sent in correct order.

Regards,
Maciej

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
