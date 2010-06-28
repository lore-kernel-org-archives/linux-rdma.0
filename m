From: Alexander Schmidt <alexs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v2] libibverbs: ibv_fork_init() and libhugetlbfs
Date: Mon, 28 Jun 2010 17:18:29 +0200
Message-ID: <20100628171829.7749f145@alex-laptop>
References: <20100531111359.4c0696ab@alex-laptop>
	<adamxvdqf4e.fsf@roland-alpha.cisco.com>
	<20100609114750.0798c664@alex-laptop>
	<adamxv4m620.fsf@roland-alpha.cisco.com>
	<4C10FDD0.8000108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C10FDD0.8000108-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org
Cc: alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Stefan Roscher <stefan.roscher-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, of-ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 10 Jun 2010 17:59:28 +0300
Alex Vainman <alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Wrote Roland Dreier:
> > Thanks, nice work.  I like this approach.  Alex (Vainman) any comments
> > on this?
> > 
> >  - R.
> 
> The solution looks great.

Hi all,

in our further testing, we noticed that there is a substantial problem with
the current solution. Depending on the order of memory registrations, we might
end up with a corrupted node tree which blocks regions from being registered.

 When registering two memory regions A and B from within
the same huge page, we will end up with one node in the tree which covers the
whole huge page after registering A. When the second MR is registered, a node
is created with the MR size rounded to the system page size (as there is no
need to call madvise(), it is not noticed that MR B is part of a huge page).

Now if MR A is deregistered before MR B, I see that the tree containing
mem_nodes is empty afterwards, which causes problems for the deregistration of
MR B, leaving the tree in a corrupted state with negative refcounts. This also
breaks later registrations of other memory regions within this huge page.

At the moment I do not see an obvious solution for this, but it's clear that
an overhaul of this code is needed. I'm writing this to make sure that there
won't be a release of libibverbs containing this incomplete code, but also
to ask for comments from other people who might have an idea on how to fix
this.

Thanks for any comments!

Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
