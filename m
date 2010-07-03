From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ewg] [PATCH v2] libibverbs: ibv_fork_init() and libhugetlbfs
Date: Sat, 03 Jul 2010 13:19:07 -0700
Message-ID: <adaoceonwsk.fsf@roland-alpha.cisco.com>
References: <20100531111359.4c0696ab@alex-laptop>
	<adamxvdqf4e.fsf@roland-alpha.cisco.com>
	<20100609114750.0798c664@alex-laptop>
	<adamxv4m620.fsf@roland-alpha.cisco.com> <4C10FDD0.8000108@gmail.com>
	<20100628171829.7749f145@alex-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100628171829.7749f145@alex-laptop> (Alexander Schmidt's
	message of "Mon, 28 Jun 2010 17:18:29 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org, alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, of-ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Stefan Roscher <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 >  When registering two memory regions A and B from within
 > the same huge page, we will end up with one node in the tree which covers the
 > whole huge page after registering A. When the second MR is registered, a node
 > is created with the MR size rounded to the system page size (as there is no
 > need to call madvise(), it is not noticed that MR B is part of a huge page).
 > 
 > Now if MR A is deregistered before MR B, I see that the tree containing
 > mem_nodes is empty afterwards, which causes problems for the deregistration of
 > MR B, leaving the tree in a corrupted state with negative refcounts. This also
 > breaks later registrations of other memory regions within this huge page.

Good thing I didn't get around to applying the patch yet ;)

I haven't thought this through fully, but it seems that maybe we could
extend the madvise tracking tree to keep track of the page size used for
each node in the tree.  Then for the registration of MR B above, we
would find the node for MR A covered MR B and we should be able to get
the ref counting right.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
