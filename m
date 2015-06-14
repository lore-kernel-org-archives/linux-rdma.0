From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 36/41] IB/hfi1: add low level page locking
Date: Mon, 15 Jun 2015 00:02:29 +0300
Message-ID: <CAJ3xEMjM9kRrnCdJmKR2i9VySOLfsZMkU=ZnJE0rXs0tTPSbVw@mail.gmail.com>
References: <20150611230710.16479.62955.stgit@phlsvslse11.ph.intel.com>
	<20150611231142.16479.41039.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150611231142.16479.41039.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 12, 2015 at 2:11 AM, Mike Marciniszyn
<mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> +++ b/drivers/infiniband/hw/hfi1/user_pages.c

> +/**
> + * hfi1_get_user_pages - lock user pages into memory
> + * @start_page: the start page
> + * @num_pages: the number of pages
> + * @p: the output page structures
> + *
> + * This function takes a given start page (page aligned user virtual
> + * address) and pins it and the following specified number of pages.  For
> + * now, num_pages is always 1, but that will probably change at some point
> + * (because caller is doing expected sends on a single virtually contiguous
> + * buffer, so we can do all pages at once).
> + */
> +int hfi1_get_user_pages(unsigned long start_page, size_t num_pages,
> +                       struct page **p)
> +{
> +       int ret;
> +
> +       down_write(&current->mm->mmap_sem);
> +
> +       ret = __hfi1_get_user_pages(start_page, num_pages, p);
> +
> +       up_write(&current->mm->mmap_sem);
> +
> +       return ret;
> +}
> +

anything wrong with the umem services provided by the IB core that
requires this implementation? what?

> +void hfi1_release_user_pages(struct page **p, size_t num_pages)
> +{
> +       if (current->mm) /* during close after signal, mm can be NULL */
> +               down_write(&current->mm->mmap_sem);
> +
> +       __hfi1_release_user_pages(p, num_pages, 1);
> +
> +       if (current->mm) {
> +               current->mm->pinned_vm -= num_pages;
> +               up_write(&current->mm->mmap_sem);
> +       }
> +}
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
