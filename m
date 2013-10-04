From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 23/26] ib: Convert qib_get_user_pages() to
 get_user_pages_unlocked()
Date: Fri, 4 Oct 2013 13:39:03 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211B0123@FMSMSX107.amr.corp.intel.com>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
 <1380724087-13927-24-git-send-email-jack@suse.cz>
 <32E1700B9017364D9B60AED9960492BC211AEF75@FMSMSX107.amr.corp.intel.com>
 <20131002152811.GC32181@quack.suse.cz>
 <32E1700B9017364D9B60AED9960492BC211AF005@FMSMSX107.amr.corp.intel.com>
 <20131002153842.GD32181@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131002153842.GD32181-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Jan Kara [mailto:jack-AlSwsSmVLrQ@public.gmane.org]
> Sent: Wednesday, October 02, 2013 11:39 AM
> To: Marciniszyn, Mike
> Cc: Jan Kara; LKML; linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org; infinipath; Roland Dreier; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH 23/26] ib: Convert qib_get_user_pages() to
> get_user_pages_unlocked()
> 
> On Wed 02-10-13 15:32:47, Marciniszyn, Mike wrote:
> > > > The risk of GUP fast is the loss of the "force" arg on GUP fast,
> > > > which I don't see as significant give our use case.
> > >   Yes. I was discussing with Roland some time ago whether the force
> > > argument is needed and he said it is. So I kept the arguments of
> > > get_user_pages() intact and just simplified the locking...
> >
> > The PSM side of the code is a more traditional use of GUP (like direct
> > I/O), so I think it is a different use case than the locking for IB
> > memory regions.
>   Ah, I see. Whatever suits you best. I don't really care as long as
> get_user_pages() locking doesn't leak into IB drivers :)
> 
> 								Honza
> --
> Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
> SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
