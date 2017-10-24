From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 3/7] IB/hfi1: Validate PKEY for incoming GSI MAD
 packets
Date: Tue, 24 Oct 2017 08:56:28 -0600
Message-ID: <20171024145628.GA28224@obsidianresearch.com>
References: <20171023125327.21191.31462.stgit@scvm10.sc.intel.com>
 <20171023130558.21191.30808.stgit@scvm10.sc.intel.com>
 <20171023183848.GC16127@mtr-leonro.local>
 <d09970ea-2531-4d8e-0b4f-85533ff8487a@intel.com>
 <20171023193102.GE16127@mtr-leonro.local>
 <b1ec461a-9c04-ff16-2a2a-4f21dfbfbcb1@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b1ec461a-9c04-ff16-2a2a-4f21dfbfbcb1-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 24, 2017 at 10:02:23AM -0400, Dennis Dalessandro wrote:

> Right, which doesn't say not to put it in a .c file. So I think the location
> is OK for this. However, whether it even needs to be an inline function at
> all in the first place is certainly a valid question. Let me chat with
> Sebastian and double check, if it doesn't really need to be inlined we'll
> send a v2.

The general thinking is that the compiler is much better at deciding
if something should be inlined or not. For the case of 'static' the
compiler will always inline it if it makes sense. 'static inline'
disables that heuristic and forces the compiler to always inline..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
