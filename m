From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Infiniband use of get_user_pages()
Date: Wed, 24 Apr 2013 15:25:25 -0700
Message-ID: <CAL1RGDXqtLPmM0kRofFwTv+jzr2cBGoe9X7oQLO_yoHGErJnxg@mail.gmail.com>
References: <20130424153810.GA25958@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130424153810.GA25958-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 24, 2013 at 8:38 AM, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org> wrote:
>   when checking users of get_user_pages() (I'm doing some cleanups in that
> area to fix filesystem's issues with mmap_sem locking) I've noticed that
> infiniband drivers add number of pages obtained from get_user_pages() to
> mm->pinned_vm counter. Although this makes some sence, it doesn't match
> with any other user of get_user_pages() (e.g. direct IO) so has infiniband
> some special reason why it does so?

Direct IO mappings are in some sense ephemeral -- they only need to
last while the IO is in flight.  In contrast the IB memory pinning is
controlled by (possibly unprivileged) userspace and might last the
whole lifetime of a long-lived application.  So we want some
accounting and resource control.

>   Also that seems to be the only real reason why mmap_sem has to be grabbed
> in exclusive mode, am I right?

Most likely that is true.

>   Another suspicious thing (at least in drivers/infiniband/core/umem.c:
> ib_umem_get()) is that arguments of get_user_pages() are like:
>                 ret = get_user_pages(current, current->mm, cur_base,
>                                      min_t(unsigned long, npages,
>                                            PAGE_SIZE / sizeof (struct page *)),
>                                      1, !umem->writable, page_list, vma_list);
> So we always have write argument set to 1 and force argument is set to
> !umem->writable. Is that really intentional? My naive guess would be that
> arguments should be switched... Although even in that case I fail to see
> why 'force' argument should be set. Can someone please explain?

This confused even me recently.  We had a long discussion (read the
whole thread starting here: https://lkml.org/lkml/2012/1/26/7) but in
short the current parameters seem to be needed to trigger COW even
when the kernel/hardware want to read the memory, to avoid problems
where we get stale data if userspace triggers COW.

I think I better add a comment explaining this.

>   Finally (and here I may show my ignorance ;), I'd like to ask whether
> there's any reason why ib_umem_get() checks for is_vm_hugetlb_page() and
> not just whether a page is a huge page?

I'm not sure of the history here.  How would one check directly if a
page is a huge page?  get_user_pages() actually goes to some trouble
to return all small pages, even when it has to split a single huge
page into many entries in the page array.  (Which is actually a bit
unfortunate for our use here)

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
