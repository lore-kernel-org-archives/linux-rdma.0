From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/6] IB/core: Enable QP creation which is
 associated to underlay QP
Date: Mon, 5 Jun 2017 09:36:44 -0600
Message-ID: <20170605153644.GA6749@obsidianresearch.com>
References: <20170530071602.8139-1-leon@kernel.org>
 <20170530071602.8139-2-leon@kernel.org>
 <20170530160447.GA21513@obsidianresearch.com>
 <1d799662-bc2b-ed12-882c-42d12d1ed8a1@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1d799662-bc2b-ed12-882c-42d12d1ed8a1-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 01, 2017 at 05:42:25PM +0300, Yishai Hadas wrote:
> On 5/30/2017 7:04 PM, Jason Gunthorpe wrote:
> >On Tue, May 30, 2017 at 10:15:57AM +0300, Leon Romanovsky wrote:
> >>From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>
> >>Enable QP creation which is associated to underlay QP.
> >>The created QP will manage the scattering objects as of RQ and SQ, while
> >>the transport attributes will be managed by its underlay QP
> >>
> >>This comes as a pre-patch for downstream patches in this series to
> >>enable flow steering on the underlay IPoIB QP.
> >
> >I think you need to define the semantics here much more precisely.
> 
> Sure, please find below some clarifications on the semantics and the usage,
> will add as part of V1 to this commit log.

I feel like this is really convoluted..

Sounds like the goal here is to allow user space to setup a send-only
'QP' with a fixed QPN, and a receive-only 'QP' associated with the
existing flow rule stuff

Why not do this directly? Why do we need this semanticly odd
association with an 'underlay QP' ?

What happens if thi underlay qp is deleted? Or reconfigured?

How does security work? This is all root-only, right?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
