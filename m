From: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [GIT PULL] please pull ummunotify
Date: Fri, 11 Sep 2009 15:21:35 +0900 (JST)
Message-ID: <20090911151930.DB6B.A69D9226@jp.fujitsu.com>
References: <adatyzahvbm.fsf@cisco.com> <4AA9EAF7.5010401@inria.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AA9EAF7.5010401-MZpvjPyXg2s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brice Goglin <Brice.Goglin-MZpvjPyXg2s@public.gmane.org>
Cc: kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Roland Dreier wrote:
> >  > Can I this version already solved fork() + COW issue? if so, could you
> >  > please explain what happen at fork. Obviously RDMA point to either parent
> >  > or child page, not both. but Corrent COW rule is, first touch process
> >  > get copyed page and other process still own original page. I think it's 
> >  > unpecected behavior form RDMA.
> >
> > No, ummunotify doesn't really help that much with fork() + COW.  If a
> > parent forks and then touches pages that are actively in use for RDMA,
> > then of course they get COWed and RDMA goes to the wrong memory (from
> > the point of view of the parent).
> >   
> 
> My understanding of the code is that fork will end-up calling
> copy_page_range() on all VMA, and copy_page_range() calls
> mmu_notifier_invalidate_range_start() if  is_cow_mapping() is true,
> which should be the case here. So you should get some invalidate events
> on fork.

Worried...
Anybody haven't test fork() case yet???



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
