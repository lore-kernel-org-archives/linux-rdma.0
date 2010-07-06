From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ewg] [PATCH v2] libibverbs: ibv_fork_init() and libhugetlbfs
Date: Tue, 06 Jul 2010 14:31:45 -0700
Message-ID: <adaocekl2ke.fsf@roland-alpha.cisco.com>
References: <20100531111359.4c0696ab@alex-laptop>
	<adamxvdqf4e.fsf@roland-alpha.cisco.com>
	<20100609114750.0798c664@alex-laptop>
	<adamxv4m620.fsf@roland-alpha.cisco.com> <4C10FDD0.8000108@gmail.com>
	<20100628171829.7749f145@alex-laptop>
	<adaoceonwsk.fsf@roland-alpha.cisco.com>
	<20100706172516.19d5b7dd@alex-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100706172516.19d5b7dd@alex-laptop> (Alexander Schmidt's
	message of "Tue, 6 Jul 2010 17:25:16 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org, alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, of-ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Stefan Roscher <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > We thought about this too, but in some special cases, we do not know the
 > correct page size of a memory range. For example when getting a 16M chunk
 > from a 16M huge page region which is also aligned to 16M, the first madvise()
 > will work fine and the code will assume that the page size is 64K.

I see ... yes, that does break my idea completely.

OK, another half-baked idea: what if we pay attention to when
madvise(DOFORK) fails as well as well madvise(DONTFORK) fails, and use
that as a hit that we better check the page size?

Perhaps this adds too much complexity ... in which case your idea:

 > As this issue was not present in version 2 of the code, but there we had
 > a big performance penalty, I suggest the following: we could go back to
 > version 2 and introduce a new RDMAV_HUGEPAGE_SAFE env variable to let the user
 > decide between huge page support and better performance (the same approach we
 > use for the COW protection itself).

seems like a reasonable alternative.

Thanks,
  Roland
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
