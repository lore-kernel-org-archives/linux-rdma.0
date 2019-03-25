From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [RESEND 1/7] mm/gup: Replace get_user_pages_longterm() with
 FOLL_LONGTERM
Date: Mon, 25 Mar 2019 01:46:14 -0700
Message-ID: <20190325084614.GE16366@iweiny-DESK2.sc.intel.com>
References: <20190317183438.2057-1-ira.weiny@intel.com>
 <20190317183438.2057-2-ira.weiny@intel.com>
 <CAA9_cmffz1VBOJ0ykBtcj+hiznn-kbbuotu1uUhPiJtXiFjJXg@mail.gmail.com>
 <20190325061941.GA16366@iweiny-DESK2.sc.intel.com>
 <CAPcyv4hPxoX1+u=fjzCeVYOd9Bck9d=A9SQ-mjzeMA2tf9B9dA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4hPxoX1+u=fjzCeVYOd9Bck9d=A9SQ-mjzeMA2tf9B9dA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, "David S. Miller" <davem@davemloft.net>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rich Felker <dalias@libc.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Ralf Baechle <ralf@linux-mips.org>, James Hogan <jhogan@kernel.org>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 25, 2019 at 09:45:12AM -0700, Dan Williams wrote:
> On Mon, Mar 25, 2019 at 7:21 AM Ira Weiny <ira.weiny@intel.com> wrote:
> [..]
> > > > @@ -1268,10 +1246,14 @@ static long check_and_migrate_cma_pages(unsigned long start, long nr_pages,
> > > >                                 putback_movable_pages(&cma_page_list);
> > > >                 }
> > > >                 /*
> > > > -                * We did migrate all the pages, Try to get the page references again
> > > > -                * migrating any new CMA pages which we failed to isolate earlier.
> > > > +                * We did migrate all the pages, Try to get the page references
> > > > +                * again migrating any new CMA pages which we failed to isolate
> > > > +                * earlier.
> > > >                  */
> > > > -               nr_pages = get_user_pages(start, nr_pages, gup_flags, pages, vmas);
> > > > +               nr_pages = __get_user_pages_locked(tsk, mm, start, nr_pages,
> > > > +                                                  pages, vmas, NULL,
> > > > +                                                  gup_flags);
> > > > +
> > >
> > > Why did this need to change to __get_user_pages_locked?
> >
> > __get_uer_pages_locked() is now the "internal call" for get_user_pages.
> >
> > Technically it did not _have_ to change but there is no need to call
> > get_user_pages() again because the FOLL_TOUCH flags is already set.  Also this
> > call then matches the __get_user_pages_locked() which was called on the pages
> > we migrated from.  Mostly this keeps the code "symmetrical" in that we called
> > __get_user_pages_locked() on the pages we are migrating from and the same call
> > on the pages we migrated to.
> >
> > While the change here looks funny I think the final code is better.
> 
> Agree, but I think that either needs to be noted in the changelog so
> it's not a surprise, or moved to a follow-on cleanup patch.
> 

Can do...

Thanks!
Ira
