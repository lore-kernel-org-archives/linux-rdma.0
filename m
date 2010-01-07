From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCHv7 4/9] ib_core: RoCEE CMA device binding
Date: Thu, 7 Jan 2010 11:24:51 -0700
Message-ID: <20100107182451.GD4664@obsidianresearch.com>
References: <20100105103257.GF31480@mtls03> <4B45E977.70805@Voltaire.com> <20100107151912.GB2892@mtls03> <1E5F6C57727E4A3BB737240D2D1942A4@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1E5F6C57727E4A3BB737240D2D1942A4-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Eli Cohen' <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 07, 2010 at 08:50:47AM -0800, Sean Hefty wrote:
> >> > +	route->path_rec->hop_limit = 2;
> >>
> >
> >The reason is that ib_init_ah_from_path() will not set IB_AH_GRH for
> >hop_limit smaller then 2, and since that GRH is required in RoCEE, and
> >since this is specific to RoCEE, I put 2 to make pass this.
> 
> A hop limit of 2 seems wrong though.  Isn't there some change that
> could be made to ib_init_ah_from_path() that would work?  It seems
> like the PR itself should indicate somehow whether the path is for
> IB or Ethernet.  (Special LID values or some flag...)

I agree, on the wire the hop limit in the GRH should be 0 or 0xFF. 0
is preferred since there is no support for routing.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
