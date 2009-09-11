From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT PULL] please pull ummunotify
Date: Thu, 10 Sep 2009 23:22:20 -0700
Message-ID: <adapr9yhug3.fsf@cisco.com>
References: <aday6omhz9d.fsf@cisco.com>
	<20090911145036.DB65.A69D9226@jp.fujitsu.com>
	<adatyzahvbm.fsf@cisco.com> <4AA9EAF7.5010401@inria.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AA9EAF7.5010401-MZpvjPyXg2s@public.gmane.org> (Brice Goglin's message of "Fri, 11
	Sep 2009 08:15:19 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brice Goglin <Brice.Goglin-MZpvjPyXg2s@public.gmane.org>
Cc: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > My understanding of the code is that fork will end-up calling
 > copy_page_range() on all VMA, and copy_page_range() calls
 > mmu_notifier_invalidate_range_start() if  is_cow_mapping() is true,
 > which should be the case here. So you should get some invalidate events
 > on fork.

Yes, I agree (that's what the second half of my email tried to say).

However, that doesn't help if the parent process is actively doing RDMA
on the range being invalidated -- the MPI library or whatever will get
the invalidate event via ummunotify, but what can it do?  The event is
basically saying "your data is going to the wrong place" and I don't see
what useful thing MPI could do with that.

As I said, it does mean that MPI can invalidate cached registrations for
COWed memory, which might be useful in case a parent forks and then
touches memory it used to use for RDMA, but I think that's the easier
part of the fork/COW problem.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
