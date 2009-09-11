From: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [GIT PULL] please pull ummunotify
Date: Fri, 11 Sep 2009 15:11:36 +0900 (JST)
Message-ID: <20090911150552.DB68.A69D9226@jp.fujitsu.com>
References: <20090911145036.DB65.A69D9226@jp.fujitsu.com> <adatyzahvbm.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adatyzahvbm.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi

Thank you explanation.

> 
>  > Can I this version already solved fork() + COW issue? if so, could you
>  > please explain what happen at fork. Obviously RDMA point to either parent
>  > or child page, not both. but Corrent COW rule is, first touch process
>  > get copyed page and other process still own original page. I think it's 
>  > unpecected behavior form RDMA.
> 
> No, ummunotify doesn't really help that much with fork() + COW.  If a
> parent forks and then touches pages that are actively in use for RDMA,
> then of course they get COWed and RDMA goes to the wrong memory (from
> the point of view of the parent).

So, Can we assume OpenMPI user process doesn't such thing?

Parhaps, madvise(DONTFORK) or vfork() avoid this issue. but I'm not
sure all program in the world do that.

> ummunotify does deal with the case where a process forks and touches
> memory that was used for RDMA but no longer is -- in that case, the MPI
> library has a chance to flush its registration cache because it will get
> a ummunotify event invalidating the old mapping.
> 
> The real purpose of ummunotify is to allow MPI implementations to cache
> registrations, even when the MPI library is used with an application
> that does funny things for allocation (mmap()/munmap() or brk(), etc).

Yup, that's very worth.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
