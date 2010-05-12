From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] libibverbs: ibv_fork_init() and libhugetlbfs
Date: Wed, 12 May 2010 09:40:16 -0700
Message-ID: <adafx1xul8v.fsf@roland-alpha.cisco.com>
References: <20100506093949.55916ab0@alex-laptop>
	<adavdb092d8.fsf@roland-alpha.cisco.com>
	<20100507121936.283a18c6@alex-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100507121936.283a18c6@alex-laptop> (Alexander Schmidt's
	message of "Fri, 7 May 2010 12:19:36 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: of-ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Stefan Roscher <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Joachim Fenkes <fenkes-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Alex Vainman <alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 >  * added get_huge_page_size() to read the huge page size from
 >    /proc/meminfo. This is done at ibv_fork_init() time.

That doesn't work on systems that have multiple huge page sizes (eg
powerpc).  You can compare the code to get the size in libhugetlbfs.

Also I think the munging through /proc/pid/maps doesn't really work.
First of all, essentially grepping for libhugetlbfs is not robust as I
mentioned -- this will break in the same way for apps using huge pages
directly.  And while it is nice to be able to tell if a range came from
libhugetlbfs, I think there may be some bad performance impact from
reading /proc/pid/maps line-by-line.  (And by the way, as a trivial
optimization, it would make sense to me to check the address of each map
before doing the strstr).

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
