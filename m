From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] - Proposal for new process for OFED releases
Date: Thu, 1 Dec 2011 17:22:32 -0700
Message-ID: <20111202002232.GG7230@obsidianresearch.com>
References: <CD250C48050CFB4D95E78C95F2FDDD6E237661EA@MTLDAG01.mtl.com>
 <1828884A29C6694DAF28B7E6B8A8237323FC20F5@ORSMSX102.amr.corp.intel.com>
 <382A478CAD40FA4FB46605CF81FE39F40107F9C50F@orsmsx507.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <382A478CAD40FA4FB46605CF81FE39F40107F9C50F-osO9UTpF0URzLByeVOV5+bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tziporet Koren <tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 01, 2011 at 04:13:41PM -0800, Woodruff, Robert J wrote:
> Sean wrote,
> >> - OFED will offer only backports to the distros  (no fixes)
> > I think this point needs to be clarified - at least to me anyway. :)
> 
> What this means is that the OFED code base will be identical to what
> is included in the upstream kernel and libs. 
> OFED will provide only backports to allow that 
> code to be run on other kernels.
> 
> If people find a bug or want a new feature, they need to submit the
> patch for the bug or new code upstream and have it accepted there
> before it will go into any OFED release.
> 
> We may need some other way for people to try out experimental new
> feature/code that is not upstream, but we won't include any
> non-upstream code in the production OFED release.
> 
> Hope this helps clarify the proposal.

This is what many of us, including myself, have been asking OFED to be
for some time now. I hope the EWG adopts this proposal.

FWIW, I think it would be ideal if code that is thought important
enough to flow into OFED is also marked for the kernel.org stable
series. This increases the chance important work is brought into the
disto kernel updates quickly.

I think it would be fairly simple for vendors looking to beta features
to provide that via their own packaging, possibly derived from OFED,
pretty much exactly as we've seen to date anyhow.

Non-upstreamable features like SDP could be split into separate
packaging, and built after the appropriate OFED/distro headers are
setup.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
