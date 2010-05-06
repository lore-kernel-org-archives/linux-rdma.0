From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] libibverbs: ibv_fork_init() and libhugetlbfs
Date: Thu, 06 May 2010 13:55:31 -0700
Message-ID: <adavdb092d8.fsf@roland-alpha.cisco.com>
References: <20100506093949.55916ab0@alex-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100506093949.55916ab0@alex-laptop> (Alexander Schmidt's
	message of "Thu, 6 May 2010 09:39:49 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: of-ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hoang-Nam Nguyen <HNGUYEN-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Stefan Roscher <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Joachim Fenkes <fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Alex Vainman <alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > When fork support is enabled in libibverbs, madvise() is called for every
 > memory page that is registered as a memory region. Memory ranges that
 > are passed to madvise() must be page aligned and the size must be a
 > multiple of the page size. libibverbs uses sysconf(_SC_PAGESIZE) to find
 > out the system page size and rounds all ranges passed to reg_mr() according
 > to this page size. When memory from libhugetlbfs is passed to reg_mr(), this
 > does not work as the page size for this memory range might be different
 > (e.g. 16Mb). So libibverbs would have to use the huge page size to
 > calculate a page aligned range for madvise.

Yes, Alex Vainman reaised this same issue a while ago.

 > The patch below demonstrates a possible solution for this. It parses the
 > /proc/PID/maps file when registering a memory region and decides if the
 > memory that is to be registered is part of a libhugetlbfs range or not. If so,
 > a page size of 16Mb is used to align the memory range passed to madvise().
 > 
 > We see two problems with this: it is not a very elegant solution to parse the
 > procfs file and the 16Mb are hardcoded currently. The latter point could be
 > solved by calling gethugepagesize() from libhugetlbfs, which would add a new
 > dependency to libibverbs.

I think that we cannot assume huge pages only come from libhugetlbfs --
we should support an application directly enabling huge pages (possibly
via another library too, so we can't assume that an application knows
the page size for a memory range it is about to register).

And also the 16 MB page size constant is of course not feasible -- with
all due respect, the x86 page size of 2 MB is much more likely in
practice :)  (Although perhaps the much slower PowerPC TLB refill makes
users more likely to try and use hugetlb pages ;)

Alex suggested parsing files in the same way as libhugetlbfs does to get
the page size, and that seems to be the best solution, since I don't
think the libhugetlbfs license is compatible with the BSD license for
libibverbs.

But your trick of using /proc/*/maps looks nice.  Does that only work
for libhugetlbfs or can we recognize direct mmap of hugetlb pages?

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
