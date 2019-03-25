From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [RESEND 1/7] mm/gup: Replace get_user_pages_longterm() with
 FOLL_LONGTERM
Date: Sun, 24 Mar 2019 23:19:42 -0700
Message-ID: <20190325061941.GA16366@iweiny-DESK2.sc.intel.com>
References: <20190317183438.2057-1-ira.weiny@intel.com>
 <20190317183438.2057-2-ira.weiny@intel.com>
 <CAA9_cmffz1VBOJ0ykBtcj+hiznn-kbbuotu1uUhPiJtXiFjJXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAA9_cmffz1VBOJ0ykBtcj+hiznn-kbbuotu1uUhPiJtXiFjJXg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, "David S. Miller" <davem@davemloft.net>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rich Felker <dalias@libc.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Ralf Baechle <ralf@linux-mips.org>, James Hogan <jhogan@kernel.org>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 22, 2019 at 02:24:40PM -0700, Dan Williams wrote:
> On Sun, Mar 17, 2019 at 7:36 PM <ira.weiny@intel.com> wrote:
> >
> > From: Ira Weiny <ira.weiny@intel.com>
> >
> > Rather than have a separate get_user_pages_longterm() call,
> > introduce FOLL_LONGTERM and change the longterm callers to use
> > it.
> >
> > This patch does not change any functionality.
> >
> > FOLL_LONGTERM can only be supported with get_user_pages() as it
> > requires vmas to determine if DAX is in use.
> >
> > CC: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> > CC: Andrew Morton <akpm@linux-foundation.org>
> > CC: Michal Hocko <mhocko@kernel.org>
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> [..]
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 2d483dbdffc0..6831077d126c 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> [..]
> > @@ -2609,6 +2596,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
> >  #define FOLL_REMOTE    0x2000  /* we are working on non-current tsk/mm */
> >  #define FOLL_COW       0x4000  /* internal GUP flag */
> >  #define FOLL_ANON      0x8000  /* don't do file mappings */
> > +#define FOLL_LONGTERM  0x10000 /* mapping is intended for a long term pin */
> 
> Let's change this comment to say something like /* mapping lifetime is
> indefinite / at the discretion of userspace */, since "longterm is not
> well defined.
> 
> I think it should also include a /* FIXME: */ to say something about
> the havoc a long term pin might wreak on fs and mm code paths.

Will do.

> 
> >  static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
> >  {
> > diff --git a/mm/gup.c b/mm/gup.c
> > index f84e22685aaa..8cb4cff067bc 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -1112,26 +1112,7 @@ long get_user_pages_remote(struct task_struct *tsk, struct mm_struct *mm,
> >  }
> >  EXPORT_SYMBOL(get_user_pages_remote);
> >
> > -/*
> > - * This is the same as get_user_pages_remote(), just with a
> > - * less-flexible calling convention where we assume that the task
> > - * and mm being operated on are the current task's and don't allow
> > - * passing of a locked parameter.  We also obviously don't pass
> > - * FOLL_REMOTE in here.
> > - */
> > -long get_user_pages(unsigned long start, unsigned long nr_pages,
> > -               unsigned int gup_flags, struct page **pages,
> > -               struct vm_area_struct **vmas)
> > -{
> > -       return __get_user_pages_locked(current, current->mm, start, nr_pages,
> > -                                      pages, vmas, NULL,
> > -                                      gup_flags | FOLL_TOUCH);
> > -}
> > -EXPORT_SYMBOL(get_user_pages);
> > -
> >  #if defined(CONFIG_FS_DAX) || defined (CONFIG_CMA)
> > -
> > -#ifdef CONFIG_FS_DAX
> >  static bool check_dax_vmas(struct vm_area_struct **vmas, long nr_pages)
> >  {
> >         long i;
> > @@ -1150,12 +1131,6 @@ static bool check_dax_vmas(struct vm_area_struct **vmas, long nr_pages)
> >         }
> >         return false;
> >  }
> > -#else
> > -static inline bool check_dax_vmas(struct vm_area_struct **vmas, long nr_pages)
> > -{
> > -       return false;
> > -}
> > -#endif
> >
> >  #ifdef CONFIG_CMA
> >  static struct page *new_non_cma_page(struct page *page, unsigned long private)
> > @@ -1209,10 +1184,13 @@ static struct page *new_non_cma_page(struct page *page, unsigned long private)
> >         return __alloc_pages_node(nid, gfp_mask, 0);
> >  }
> >
> > -static long check_and_migrate_cma_pages(unsigned long start, long nr_pages,
> > -                                       unsigned int gup_flags,
> > +static long check_and_migrate_cma_pages(struct task_struct *tsk,
> > +                                       struct mm_struct *mm,
> > +                                       unsigned long start,
> > +                                       unsigned long nr_pages,
> >                                         struct page **pages,
> > -                                       struct vm_area_struct **vmas)
> > +                                       struct vm_area_struct **vmas,
> > +                                       unsigned int gup_flags)
> >  {
> >         long i;
> >         bool drain_allow = true;
> > @@ -1268,10 +1246,14 @@ static long check_and_migrate_cma_pages(unsigned long start, long nr_pages,
> >                                 putback_movable_pages(&cma_page_list);
> >                 }
> >                 /*
> > -                * We did migrate all the pages, Try to get the page references again
> > -                * migrating any new CMA pages which we failed to isolate earlier.
> > +                * We did migrate all the pages, Try to get the page references
> > +                * again migrating any new CMA pages which we failed to isolate
> > +                * earlier.
> >                  */
> > -               nr_pages = get_user_pages(start, nr_pages, gup_flags, pages, vmas);
> > +               nr_pages = __get_user_pages_locked(tsk, mm, start, nr_pages,
> > +                                                  pages, vmas, NULL,
> > +                                                  gup_flags);
> > +
> 
> Why did this need to change to __get_user_pages_locked?

__get_uer_pages_locked() is now the "internal call" for get_user_pages.

Technically it did not _have_ to change but there is no need to call
get_user_pages() again because the FOLL_TOUCH flags is already set.  Also this
call then matches the __get_user_pages_locked() which was called on the pages
we migrated from.  Mostly this keeps the code "symmetrical" in that we called
__get_user_pages_locked() on the pages we are migrating from and the same call
on the pages we migrated to.

While the change here looks funny I think the final code is better.

> 
> >                 if ((nr_pages > 0) && migrate_allow) {
> >                         drain_allow = true;
> >                         goto check_again;
> > @@ -1281,66 +1263,115 @@ static long check_and_migrate_cma_pages(unsigned long start, long nr_pages,
> >         return nr_pages;
> >  }
> >  #else
> > -static inline long check_and_migrate_cma_pages(unsigned long start, long nr_pages,
> > -                                              unsigned int gup_flags,
> > -                                              struct page **pages,
> > -                                              struct vm_area_struct **vmas)
> > +static long check_and_migrate_cma_pages(struct task_struct *tsk,
> > +                                       struct mm_struct *mm,
> > +                                       unsigned long start,
> > +                                       unsigned long nr_pages,
> > +                                       struct page **pages,
> > +                                       struct vm_area_struct **vmas,
> > +                                       unsigned int gup_flags)
> >  {
> >         return nr_pages;
> >  }
> >  #endif
> >
> >  /*
> > - * This is the same as get_user_pages() in that it assumes we are
> > - * operating on the current task's mm, but it goes further to validate
> > - * that the vmas associated with the address range are suitable for
> > - * longterm elevated page reference counts. For example, filesystem-dax
> > - * mappings are subject to the lifetime enforced by the filesystem and
> > - * we need guarantees that longterm users like RDMA and V4L2 only
> > - * establish mappings that have a kernel enforced revocation mechanism.
> > + * __gup_longterm_locked() is a wrapper for __get_uer_pages_locked which
> 
> s/uer/user/

Check

> 
> > + * allows us to process the FOLL_LONGTERM flag if present.
> > + *
> > + * FOLL_LONGTERM Checks for either DAX VMAs or PPC CMA regions and either fails
> > + * the pin or attempts to migrate the page as appropriate.
> > + *
> > + * In the filesystem-dax case mappings are subject to the lifetime enforced by
> > + * the filesystem and we need guarantees that longterm users like RDMA and V4L2
> > + * only establish mappings that have a kernel enforced revocation mechanism.
> > + *
> > + * In the CMA case pages can't be pinned in a CMA region as this would
> > + * unnecessarily fragment that region.  So CMA attempts to migrate the page
> > + * before pinning.
> >   *
> >   * "longterm" == userspace controlled elevated page count lifetime.
> >   * Contrast this to iov_iter_get_pages() usages which are transient.
> 
> Ah, here's the longterm documentation, but if I was a developer
> considering whether to use FOLL_LONGTERM or not I would expect to find
> the documentation at the flag definition site.
> 
> I think it has become more clear since get_user_pages_longterm() was
> initially merged that we need to warn people not to use it, or at
> least seriously reconsider whether they want an interface to support
> indefinite pins.

Good point will move

> 
> >   */
> > -long get_user_pages_longterm(unsigned long start, unsigned long nr_pages,
> > -                            unsigned int gup_flags, struct page **pages,
> > -                            struct vm_area_struct **vmas_arg)
> > +static __always_inline long __gup_longterm_locked(struct task_struct *tsk,
> 
> ...why the __always_inline?
 
This was because it was only called from get_user_pages() in this patch.  But
later on I use it elsewhere so __always_inline is wrong.

Ira
