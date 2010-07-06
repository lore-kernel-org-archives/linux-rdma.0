From: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [ewg] [PATCH v2] libibverbs: ibv_fork_init() and libhugetlbfs
Date: Tue, 6 Jul 2010 17:25:16 +0200
Message-ID: <20100706172516.19d5b7dd@alex-laptop>
References: <20100531111359.4c0696ab@alex-laptop>
	<adamxvdqf4e.fsf@roland-alpha.cisco.com>
	<20100609114750.0798c664@alex-laptop>
	<adamxv4m620.fsf@roland-alpha.cisco.com>
	<4C10FDD0.8000108@gmail.com>
	<20100628171829.7749f145@alex-laptop>
	<adaoceonwsk.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaoceonwsk.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org, alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, of-ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Stefan Roscher <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 03 Jul 2010 13:19:07 -0700
Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:

>  >  When registering two memory regions A and B from within
>  > the same huge page, we will end up with one node in the tree which covers the
>  > whole huge page after registering A. When the second MR is registered, a node
>  > is created with the MR size rounded to the system page size (as there is no
>  > need to call madvise(), it is not noticed that MR B is part of a huge page).
>  > 
>  > Now if MR A is deregistered before MR B, I see that the tree containing
>  > mem_nodes is empty afterwards, which causes problems for the deregistration of
>  > MR B, leaving the tree in a corrupted state with negative refcounts. This also
>  > breaks later registrations of other memory regions within this huge page.
> 
> Good thing I didn't get around to applying the patch yet ;)
> 
> I haven't thought this through fully, but it seems that maybe we could
> extend the madvise tracking tree to keep track of the page size used for
> each node in the tree.  Then for the registration of MR B above, we
> would find the node for MR A covered MR B and we should be able to get
> the ref counting right.

We thought about this too, but in some special cases, we do not know the
correct page size of a memory range. For example when getting a 16M chunk
from a 16M huge page region which is also aligned to 16M, the first madvise()
will work fine and the code will assume that the page size is 64K.

If trying to register a 16M - 64K + 1 byte region, the first madvise() also
works fine. Now if a second memory region which resides in the last 64K is
registered, we end up with the same situation as above.

As this issue was not present in version 2 of the code, but there we had
a big performance penalty, I suggest the following: we could go back to
version 2 and introduce a new RDMAV_HUGEPAGE_SAFE env variable to let the user
decide between huge page support and better performance (the same approach we
use for the COW protection itself). Would this be okay or do you see a problem
with this?

Regards,
Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
