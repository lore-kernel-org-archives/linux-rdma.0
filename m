From: Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [GIT PULL] please pull ummunotify
Date: Fri, 11 Sep 2009 19:42:47 +0300
Message-ID: <20090911164247.GA6736@redhat.com>
References: <20090911145036.DB65.A69D9226@jp.fujitsu.com>
 <adatyzahvbm.fsf@cisco.com>
 <20090911150552.DB68.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20090911150552.DB68.A69D9226-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 11, 2009 at 03:11:36PM +0900, KOSAKI Motohiro wrote:
> Hi
> 
> Thank you explanation.
> 
> > 
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
> 
> So, Can we assume OpenMPI user process doesn't such thing?
> 
> Parhaps, madvise(DONTFORK) or vfork() avoid this issue. but I'm not
> sure all program in the world do that.
> 
MPI (or is it libibverbs?) marks all registered memory as DONTFORK.

--
			Gleb.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
