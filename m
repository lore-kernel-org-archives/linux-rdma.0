From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v3] [RFC] rdma/cm: support option to allow manually
	setting IB path
Date: Wed, 28 Oct 2009 13:14:54 -0600
Message-ID: <20091028191454.GL14520@obsidianresearch.com>
References: <20091020181458.GD14520@obsidianresearch.com> <46770152ACA04B6C8AA9497C45AC8FD0@amr.corp.intel.com> <20091020191404.GH14520@obsidianresearch.com> <9DFD8E65325F4EE990749EEBE4BC33CA@amr.corp.intel.com> <20091022004245.GV14520@obsidianresearch.com> <AE35305D45DB49F591A45DADD822209A@amr.corp.intel.com> <20091022013542.GX14520@obsidianresearch.com> <B7E97540810E4A2785FF1FC8CB96F453@amr.corp.intel.com> <DC0770A17FDC4DACAC0251A3362CE87A@amr.corp.intel.com> <adaiqdzs81h.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adaiqdzs81h.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 28, 2009 at 11:11:22AM -0700, Roland Dreier wrote:
> This looks fine to me... the only thing I could wonder about is:
> 
>  > +	RDMA_OPTION_ID_TOS	= 0,
>  > +
>  > +	RDMA_OPTION_IB_PATH	= 1
> 
> why a blank line here? ;)
 
> Jason and Or, does this seem ready to queue for 2.6.33?

I like the API as far as passing IB PRs between kernel and userspace,
I'm glad we came up with this. (Sean: I was going to suggest that the
second EINVAL should maybe be ENOSUPPORTED or something - so userspace
can tell the kernel supports the API but did not accept any of the flags
combinations)

But, I still think this API should return EINVAL if the cm_id is in
AF_INET/AF_INET6 mode. That is to say, this API only works with the
AF_IB idea we have been discussing.

I suggest this because using this API really does override the
capabilities of the AF_INET/6 in unexpected ways, as the discussion
drifted through it seemed like at least bonding, routing
and ND operations would/could be overridden.

If so then I'd say it should be part of an AF_IB patch.

Sean, what are your thoughts on applying it to AF_INET/6?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
