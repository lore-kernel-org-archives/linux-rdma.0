From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] libibverbs: ibv_fork_init() and libhugetlbfs
Date: Wed, 02 Jun 2010 14:49:37 -0700
Message-ID: <adamxvdqf4e.fsf@roland-alpha.cisco.com>
References: <20100531111359.4c0696ab@alex-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100531111359.4c0696ab@alex-laptop> (Alexander Schmidt's
	message of "Mon, 31 May 2010 11:13:59 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Stefan Roscher <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, of-ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Vainman <alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > without patch:
 > 1M memory region    120usec
 > 16M memory region  1970usec 
 > 
 > with patch v2:
 > 1M memory region    172usec
 > 16M memory region  2030usec

So if I read this correctly this patch introduces almost a 50% overhead
in the 1M case... and probably much worse (as a fraction) in say the 64K
or 4K case.  I wonder if that's acceptable?

Alex's original approach was to try the memadvise with normal page size
and then fall back to huge page size if that failed.  But of course that
wastes some time on the failed madvise in the hugepage case.

I think it would be interesting to compare timings for registering, say,
4K, 64K, 1M and 16M regions with and without huge page backing, for
three possibilities:

 - unpatched libibverbs (will obviously fail on hugepage backed regions)
 - patched with this v2
 - alternate patch that tries madvise and only does your /proc/pid/smaps
 - parsing if the first madvise fails.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
