From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] link-local address fix for rdma_resolve_addr
Date: Tue, 27 Oct 2009 11:14:03 -0600
Message-ID: <20091027171403.GP26003@obsidianresearch.com>
References: <20091021233639.GS14520@obsidianresearch.com> <BFF5CD71FFA74BF09A2EED5F3319F370@amr.corp.intel.com> <20091022002846.GU14520@obsidianresearch.com> <4803112A5B7A4953B62ABAFD1BBD9881@amr.corp.intel.com> <20091022011939.GW14520@obsidianresearch.com> <60E9443821EE4FFA90448DF5CC1368A8@amr.corp.intel.com> <20091022062531.GB26003@obsidianresearch.com> <4AE43BED.3090405@voltaire.com> <20091025200332.GN26003@obsidianresearch.com> <4AE6EF44.5040004@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AE6EF44.5040004-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 27, 2009 at 03:01:56PM +0200, Or Gerlitz wrote:

> Don't tell me that Dave's patches are blocked b/c you discovered the 
> rdma_bind design and now you don't like it, as I wrote you, Dave sent 
> patch to fix the IPv6 support, during the discussion on his patches you 
> come and bring up more and more issues you consider as problems (but I 
> don't) and block the patch set, I don't think this is appropriate. Let 
> the patches go and send your patches to fix the problems you see. Why 
> anyone touching some code piece has to fix problems you see in that piece?!

Wow, seriously? You do understand the purpose of review, right?

Documentation/development-process/7.AdvancedTopics:
 Different developers will review code from different points of view.
 Some are mostly concerned with coding style and whether code lines
 have trailing white space.  Others will focus primarily on whether the
 change implemented by the patch as a whole is a good thing for the
 kernel or not.  Yet others will check for problematic locking,
 excessive stack usage, possible security issues, duplication of code
 found elsewhere, adequate documentation, adverse effects on
 performance, user-space ABI changes, etc.  All types of review, if
 they lead to better code going into the kernel, are welcome and
 worthwhile.

And yes, actually, accounting for how rdma_bind() is different from
bind() when doing route resolution is pretty much the main remaining
problem.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
