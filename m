From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Tue, 10 May 2016 19:29:42 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1605101928280.2103@east.gentwo.org>
References: <20160504181135.GA15355@obsidianresearch.com> <21d9307f-766e-9aaa-54d3-207a4a4d5d8c@mellanox.com> <20160505181423.GB5957@obsidianresearch.com> <alpine.DEB.2.20.1605052116570.1091@east.gentwo.org> <20160506225523.GA21309@obsidianresearch.com>
 <alpine.DEB.2.20.1605090926440.6128@east.gentwo.org> <20160509163537.GA15479@obsidianresearch.com> <20160509191613.GS29160@leon.nu> <20160509195734.GA22669@obsidianresearch.com> <20160510044107.GU29160@leon.nu> <20160510170739.GA2879@obsidianresearch.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160510170739.GA2879-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 10 May 2016, Jason Gunthorpe wrote:

> > Exactly, this is why it is posted on the open mailing list where
> > everyone has stage to express their opinion, including these mysterious
> > hardware architecture who cares about future design, but doesn't care about
> > its future support.
>
> Look, if you want linux-rdma to be setting hardware standards then get
> a consensus from the vendors on this idea.

This is about exporting existing hardware features that are already
available through the standard socket APIs.

> This was tried at the Collab summit and I heard several representatives
> strongly say no.

Hardware standards? I thought we were talking about software and APIs.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
