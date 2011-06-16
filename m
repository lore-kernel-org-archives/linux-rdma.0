From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 7/9] ib/pma: add include file for IBA performance	counters
 definitions
Date: Thu, 16 Jun 2011 17:18:52 +0300
Message-ID: <4DFA10CC.5080002@mellanox.com>
References: <alpine.LRH.2.00.1106151733410.15844@ogerlitz.voltaire.com>	<alpine.LRH.2.00.1106151747390.15844@ogerlitz.voltaire.com> <alpine.LRH.2.00.1106161119120.12552@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1106161119120.12552-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Move the various definitions and mad structures needed for software
> implementation of IBA PM agent from the ipath and qib drivers into
> a single include file, which in turn could be used by more consumers.
Hi, I don't see any maintainer entry for qib and the ipath maintainer 
entry seems
to be invalid? are you the maintainer? could you look here?

Or.

> changes from V0 - applied feedback from Sean and Hal
>
>   - renamed struct ib_perf to be ib_pma_mad which now starts with struct ib_mad_hdr
>   - removed struct ib_pma_classportinfo, use struct ib_class_port_info from ib_mad.h
>   - clarified comments for bit fields, adding missing fields for ib_pma_portsamplescontrol
>   - removed packing from struct ib_pma_portsamples{control, result, result_ext}
>   - changed struct ib_pma_portcounters :: lli_ebor_errors to be link_overrun_errors
>   - added xmit wait to struct ib_pma_portcounters
>   - left proprietary defs in the qib code
>
>   drivers/infiniband/hw/ipath/ipath_mad.c |  198 +++++---------------------------
>   drivers/infiniband/hw/qib/qib_mad.h     |  151 ------------------------
>   include/rdma/ib_pma.h                   |  164 ++++++++++++++++++++++++++
>   3 files changed, 200 insertions(+), 313 deletions(-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
