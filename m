From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3] [RFC] rdma/cm: support option to allow manually
	setting IB path
Date: Wed, 28 Oct 2009 14:25:45 -0600
Message-ID: <20091028202545.GM14520@obsidianresearch.com>
References: <20091020191404.GH14520@obsidianresearch.com> <9DFD8E65325F4EE990749EEBE4BC33CA@amr.corp.intel.com> <20091022004245.GV14520@obsidianresearch.com> <AE35305D45DB49F591A45DADD822209A@amr.corp.intel.com> <20091022013542.GX14520@obsidianresearch.com> <B7E97540810E4A2785FF1FC8CB96F453@amr.corp.intel.com> <DC0770A17FDC4DACAC0251A3362CE87A@amr.corp.intel.com> <adaiqdzs81h.fsf@cisco.com> <20091028191454.GL14520@obsidianresearch.com> <5082D185D95A4389BC9EEA666CAEBA66@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5082D185D95A4389BC9EEA666CAEBA66-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 28, 2009 at 12:37:39PM -0700, Sean Hefty wrote:
> >But, I still think this API should return EINVAL if the cm_id is in
> >AF_INET/AF_INET6 mode. That is to say, this API only works with the
> >AF_IB idea we have been discussing.
> >
> >I suggest this because using this API really does override the
> >capabilities of the AF_INET/6 in unexpected ways, as the discussion
> >drifted through it seemed like at least bonding, routing
> >and ND operations would/could be overridden.
> >
> >If so then I'd say it should be part of an AF_IB patch.
> >
> >Sean, what are your thoughts on applying it to AF_INET/6?
> 
> Even without any other kernel changes, this patch enables us to solve the
> biggest scaling problem that we've measured, so I want to allow it regardless of
> what the original addressing was.  Whether a path record comes from the SA, a
> local cache, some wonky multicast protocol, or is made up is really independent
> from how the GIDs were discovered.

OK, that makes sense.

I have no problem with this if there is a way for the kernel to choose
the DGID and pass it to user space to do path resolution to feed back
PRs through the new API - at least it is then possible to use the new
API in a way that is consistent with the IP stack.

ie this API when applied to AF_INET does not short-circuit ND. You
have to use AF_IB to remove the ND.

Does that seem consistent with what you are thinking? Does a DGID
returning API already exist? Seems simple to add if not..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
