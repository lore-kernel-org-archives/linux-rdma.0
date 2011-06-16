From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH V1 7/9] ib/pma: add include file for IBA performance
 counters definitions
Date: Thu, 16 Jun 2011 08:49:03 -0700
Message-ID: <35AAF1E4A771E142979F27B51793A4888838E71F03@AVEXMB1.qlogic.org>
References: <alpine.LRH.2.00.1106151733410.15844@ogerlitz.voltaire.com>
	<alpine.LRH.2.00.1106151747390.15844@ogerlitz.voltaire.com>
 <alpine.LRH.2.00.1106161119120.12552@ogerlitz.voltaire.com>
 <4DFA10CC.5080002@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DFA10CC.5080002-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Edward Mascarenhas <edward.mascarenhas-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Yes,

I'm the maintainer for both qib and ipath.

I'm currently looking over these fixes.

We also have pending fixes in the qib_mad.c that are complicating my testing with the various source streams we are maintaining.

I would be nice as a result of this if we could resolve issues associated with https://patchwork.kernel.org/patch/523041/ to reduce those impacts.

Mike


> -----Original Message-----
> From: Or Gerlitz [mailto:ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
> Sent: Thursday, June 16, 2011 10:19 AM
> To: Mike Marciniszyn
> Cc: linux-rdma
> Subject: Re: [PATCH V1 7/9] ib/pma: add include file for IBA
> performance counters definitions
>
>
> > Move the various definitions and mad structures needed for software
> > implementation of IBA PM agent from the ipath and qib drivers into
> > a single include file, which in turn could be used by more consumers.
> Hi, I don't see any maintainer entry for qib and the ipath maintainer
> entry seems
> to be invalid? are you the maintainer? could you look here?
>
> Or.
>
> > changes from V0 - applied feedback from Sean and Hal
> >
> >   - renamed struct ib_perf to be ib_pma_mad which now starts with
> struct ib_mad_hdr
> >   - removed struct ib_pma_classportinfo, use struct
> ib_class_port_info from ib_mad.h
> >   - clarified comments for bit fields, adding missing fields for
> ib_pma_portsamplescontrol
> >   - removed packing from struct ib_pma_portsamples{control, result,
> result_ext}
> >   - changed struct ib_pma_portcounters :: lli_ebor_errors to be
> link_overrun_errors
> >   - added xmit wait to struct ib_pma_portcounters
> >   - left proprietary defs in the qib code
> >
> >   drivers/infiniband/hw/ipath/ipath_mad.c |  198 +++++---------------
> ------------
> >   drivers/infiniband/hw/qib/qib_mad.h     |  151 --------------------
> ----
> >   include/rdma/ib_pma.h                   |  164
> ++++++++++++++++++++++++++
> >   3 files changed, 200 insertions(+), 313 deletions(-)


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
