From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Wed, 11 May 2016 09:23:30 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1605110920490.8588@east.gentwo.org>
References: <20160505181423.GB5957@obsidianresearch.com> <alpine.DEB.2.20.1605052116570.1091@east.gentwo.org> <20160506225523.GA21309@obsidianresearch.com> <alpine.DEB.2.20.1605090926440.6128@east.gentwo.org> <20160509163537.GA15479@obsidianresearch.com>
 <20160509191613.GS29160@leon.nu> <20160509195734.GA22669@obsidianresearch.com> <20160510044107.GU29160@leon.nu> <20160510170739.GA2879@obsidianresearch.com> <alpine.DEB.2.20.1605101928280.2103@east.gentwo.org> <20160511020429.GA32766@obsidianresearch.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160511020429.GA32766-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 10 May 2016, Jason Gunthorpe wrote:

> I still don't understand why this is being forced into
> libibverbs. dpdk would seem to be the prefered way to access these
> sorts of features and there is no technical reason why the mlx
> dpdk provider needs to use libibverbs. Talk directly to /dev/uverbs0
> and use udata to enable the universe of nic specific features.

Well then the trouble is how to integrate that into QPs and the rest of
the RDMA infrastructure.

>
> For instance, the dpdk community has already done the hard work to
> figure out how to expose things like LSO to their users - and they
> actually have multiple vendors providing these features...
>
> http://dpdk.org/ml/archives/dev/2014-May/002537.html
>
> I guess you are going to tell me you want these features on IB UD
> transport and dpdk has no support for L2's other than ethernet?

Our software is based on raw ethernet frame processing through QPs. Thus
the desire to have the extras that the hardware can provide. And yes we
want to have an API that can be used to interface with hardware from
multiple vendors.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
