From: Aleksey Senin <aleksey-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>
Subject: When IBoE will be merged to upstream?
Date: Sun, 20 Jun 2010 09:18:37 +0300
Message-ID: <AANLkTikXzoaRl61ivsc7fm8EdO9Ucz4iGGfclFOQl3kK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org, yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org, tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi, Roland.
This is actually a continue of the RAW_ET(XXXX)  issue. We want to
make a submition  of the patches to the upstream, but there is not
support for IB transport in Ethernet devices, and the mlx4_en drivers
version  is a bit outdated 1.4.1.1 in upstream and 1.5.1 in the OFED
There is also missing VLAN support that already present in the OFED.
When do you planning to submit changes from OFED to upstream?
Now, concerning new enum type RAW_ETH and exporting it to the kernel.
As you can see there is no special QP types defined in the verbs
userspace, so I think we can't broke userspace applications.This is on
the one hand. On the second hand, we need this new enum becase already
present RAW_ETY actually should be used when formatting non-IBA frames
over IB, and the new one will be used for formatting such pakets over
Ethernet. In additon there are changes in the OFED that using RAW_ETY
type and QP created for such type is different from the RAW_ETH QP.
The first one - RAW_ETY - cannot be created from userspace and there
is no such limitation for newer RAW_ETH type.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
