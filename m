From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RESEND] infiniband:core:Add needed error path in cm_init_av_by_path
Date: Wed, 16 Dec 2015 01:52:22 -0500
Message-ID: <20151216065222.GA27524@phlsvsds.ph.intel.com>
References: <1450194724-7107-1-git-send-email-xerofoify@gmail.com> <5670420A.7040202@profitbricks.com> <20151215173022.GB25965@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151215173022.GB25965-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, doront-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 15, 2015 at 10:30:22AM -0700, Jason Gunthorpe wrote:
> On Tue, Dec 15, 2015 at 05:38:34PM +0100, Michael Wang wrote:
> > The hop_limit is only suggest that the package allowed to be
> > routed, not have to, correct?
> 
> If the hop limit is >= 2 (?) then the GRH is mandatory.

Yes >= 2.

"Setting this value to 0 or 1 will ensure that the packet 
will not be forwarded beyond the local subnet."

	-- IBTA 8.3.6 Hop Limit

Ira

> The
> SM will return this information in the PathRecord if it determines a
> GRH is required. The whole stack follows this protocol.
> 
> The GRH is optional for in-subnet communications.
> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
