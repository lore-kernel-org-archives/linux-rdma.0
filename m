From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH/RFC G-U-P experts] IB/umem: Modernize our get_user_pages()
 parameters
Date: Thu, 9 Feb 2012 14:57:02 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1202091425280.1263@eggly.anvils>
References: <1327557574-6125-1-git-send-email-roland@kernel.org> <alpine.LSU.2.00.1201261133230.1369@eggly.anvils> <CAG4TOxNEV2VY9wOE86p9RnKGqpruB32ci9Wq3yBt8O2zc7f05w@mail.gmail.com> <alpine.LSU.2.00.1201271458130.3402@eggly.anvils>
 <CAL1RGDXqguZ2QKV=yjLXtk2n_Ag4Nf3CW+kF2BFQFR4ySTNaRA@mail.gmail.com> <alpine.LSU.2.00.1201301217530.4505@eggly.anvils> <CAL1RGDVSBb1DVsfvuz=ijRZX06crsqQfKoXWJ+6FO4xi3aYyTg@mail.gmail.com> <alpine.LSU.2.00.1202071225250.2024@eggly.anvils>
 <alpine.LSU.2.00.1202081446110.1320@eggly.anvils> <CAL1RGDWZ2LYO7ejPs9FvDzqze43cbfUEEdQVB=Ug2n3JpEe=AQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWZ2LYO7ejPs9FvDzqze43cbfUEEdQVB=Ug2n3JpEe=AQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 9 Feb 2012, Roland Dreier wrote:
> On Wed, Feb 8, 2012 at 3:10 PM, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > A doubt assaulted me overnight: sorry, I'm back to not understanding.
> >
> > What are these access flags passed into ibv_reg_mr() that are enforced?
> > What relation do they bear to what you will pass to __get_user_pages()?
> 
> The access flags are:
> 
> enum ibv_access_flags {
>         IBV_ACCESS_LOCAL_WRITE          = 1,
>         IBV_ACCESS_REMOTE_WRITE         = (1<<1),
>         IBV_ACCESS_REMOTE_READ          = (1<<2),
>         IBV_ACCESS_REMOTE_ATOMIC        = (1<<3),
>         IBV_ACCESS_MW_BIND              = (1<<4)
> };
> 
> pretty much the only one of interest is IBV_ACCESS_REMOTE_READ --
> all the others imply the possibility of RDMA HW writing to the page.
> 
> So basically if any flags other than IBV_ACCESS_REMOTE_READ are
> set, we pass FOLL_WRITE to __get_user_pages(), otherwise we pass
> the new FOLL_FOLLOW.  [does "Marcia, Marcia, Marcia" mean anything
> to a Brit? ;)]

[ Nothing whatsoever - I needed to avoid saying "Zilch" there, didn't I?
- I had to look her up.  Not sure quite how she comes in here, if you're
implying that someone is perfect, I rather doubt you're thinking of me!
I was thrilled a year ago at last to discover who Virginia is,
celebrated in mm/memory.c and mm/page-writeback.c. ]

> 
> ie the change from the status quo would be:
> 
> [read-only]  write=1, force=1 --> FOLL_FOLLOW
> [writeable]  wrote=1, force=0 --> FOLL_WRITE (equivalent)
> 
> > You are asking for a FOLL_FOLLOW ("follow permissions of the vma") flag,
> > which automatically works for read-write access to a VM_READ|VM_WRITE vma,
> > but read-only access to a VM_READ-only vma, without you having to know
> > which permission applies to which range of memory in the area specified.
> 
> > But you don't need that new flag to set up read-only access, and if you
> > use that new flag to set up read-write access to an area which happens to
> > contain VM_READ-only ranges, you have set it up to write into ZERO_PAGEs.
> 
> First of all, I kind of like FOLL_FOLLOW as the name :)

Yeah, it's not too bad; though below I'm now wondering if it is appropriate.

> 
> Now you're confusing me:

I'm very glad to hear it, I feel less alone.

> I think we do need FOLL_FOLLOW to
> set up read-only access -- we want to trigger the COWs that userspace
> might trigger by touching the memory up front.  This is to handle
> a case like
> 
>     [userspace]
>     int *buf = malloc(16 * 4096);
>     // buf now points to 16 anonymous zero_pages
>     mr = ibv_reg_mr(pd, buf, 16 * 4096, IBV_ACCESS_REMOTE_READ);
>     // RDMA HW will only ever read buf, but...
>     buf[0] = 2012;
>     // COW triggered, first page of buf changed, RDMA HW has wrong mapping!
> 
> For something the RDMA HW might write to, then I agree we don't want
> FOLL_FOLLOW -- we just would use FOLL_WRITE as we currently do.

Ah, okay, something earlier in the thread had thrown me off that track,
I thought we were expecting the ibv_reg_mr to give the remote the same
permissions as the user had.  Or something, maybe I'm just making excuses
for being dense.

But then I wonder if FOLL_FOLLOW is actually the behaviour you need.

Imagine a PROT_READ MAP_PRIVATE area (just as in your original mail):
what if the user does mprotect PROT_READ|PROT_WRITE on that afterwards,
and then proceeds to touch it.  The old write=1 force=1 GUP would have
pre-COWed that and no problem, but FOLL_FOLLOW will not.

Maybe you can answer "don't do that"; but you do then appear to be
trading one kind of "don't do that" for another.  Maybe it depends on
what libraries might get up to: aren't there (debug? garbage collection?)
memalloc libraries which give out memory protected until you touch it?

Maybe you need FOLL_PRECOW, which does write=1 force=1 on the private
areas, but just faults in the shared areas (avoiding the bizarre forced
COW on shared areas).

> 
> When I get around to coding this up, I think I'm going to spend a lot
> of time on the comments and on the commit log :)

I am sorry to be driving you to such effort, honestly.

Hugh
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
