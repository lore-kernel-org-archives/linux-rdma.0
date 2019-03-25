From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [RESEND 4/7] mm/gup: Add FOLL_LONGTERM capability to GUP fast
Date: Mon, 25 Mar 2019 02:23:15 -0700
Message-ID: <20190325092314.GF16366@iweiny-DESK2.sc.intel.com>
References: <20190317183438.2057-1-ira.weiny@intel.com>
 <20190317183438.2057-5-ira.weiny@intel.com>
 <CAA9_cmcx-Bqo=CFuSj7Xcap3e5uaAot2reL2T74C47Ut6_KtQw@mail.gmail.com>
 <20190325084225.GC16366@iweiny-DESK2.sc.intel.com>
 <20190325164713.GC9949@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190325164713.GC9949@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, "David S. Miller" <davem@davemloft.net>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rich Felker <dalias@libc.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Ralf Baechle <ralf@linux-mips.org>, James Hogan <jhogan@kernel.org>, linux-mm <linux-mm@kvack.org>, Linux
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 25, 2019 at 01:47:13PM -0300, Jason Gunthorpe wrote:
> On Mon, Mar 25, 2019 at 01:42:26AM -0700, Ira Weiny wrote:
> > On Fri, Mar 22, 2019 at 03:12:55PM -0700, Dan Williams wrote:
> > > On Sun, Mar 17, 2019 at 7:36 PM <ira.weiny@intel.com> wrote:
> > > >
> > > > From: Ira Weiny <ira.weiny@intel.com>
> > > >
> > > > DAX pages were previously unprotected from longterm pins when users
> > > > called get_user_pages_fast().
> > > >
> > > > Use the new FOLL_LONGTERM flag to check for DEVMAP pages and fall
> > > > back to regular GUP processing if a DEVMAP page is encountered.
> > > >
> > > > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > > >  mm/gup.c | 29 +++++++++++++++++++++++++----
> > > >  1 file changed, 25 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/mm/gup.c b/mm/gup.c
> > > > index 0684a9536207..173db0c44678 100644
> > > > +++ b/mm/gup.c
> > > > @@ -1600,6 +1600,9 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
> > > >                         goto pte_unmap;
> > > >
> > > >                 if (pte_devmap(pte)) {
> > > > +                       if (unlikely(flags & FOLL_LONGTERM))
> > > > +                               goto pte_unmap;
> > > > +
> > > >                         pgmap = get_dev_pagemap(pte_pfn(pte), pgmap);
> > > >                         if (unlikely(!pgmap)) {
> > > >                                 undo_dev_pagemap(nr, nr_start, pages);
> > > > @@ -1739,8 +1742,11 @@ static int gup_huge_pmd(pmd_t orig, pmd_t *pmdp, unsigned long addr,
> > > >         if (!pmd_access_permitted(orig, flags & FOLL_WRITE))
> > > >                 return 0;
> > > >
> > > > -       if (pmd_devmap(orig))
> > > > +       if (pmd_devmap(orig)) {
> > > > +               if (unlikely(flags & FOLL_LONGTERM))
> > > > +                       return 0;
> > > >                 return __gup_device_huge_pmd(orig, pmdp, addr, end, pages, nr);
> > > > +       }
> > > >
> > > >         refs = 0;
> > > >         page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
> > > > @@ -1777,8 +1783,11 @@ static int gup_huge_pud(pud_t orig, pud_t *pudp, unsigned long addr,
> > > >         if (!pud_access_permitted(orig, flags & FOLL_WRITE))
> > > >                 return 0;
> > > >
> > > > -       if (pud_devmap(orig))
> > > > +       if (pud_devmap(orig)) {
> > > > +               if (unlikely(flags & FOLL_LONGTERM))
> > > > +                       return 0;
> > > >                 return __gup_device_huge_pud(orig, pudp, addr, end, pages, nr);
> > > > +       }
> > > >
> > > >         refs = 0;
> > > >         page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
> > > > @@ -2066,8 +2075,20 @@ int get_user_pages_fast(unsigned long start, int nr_pages,
> > > >                 start += nr << PAGE_SHIFT;
> > > >                 pages += nr;
> > > >
> > > > -               ret = get_user_pages_unlocked(start, nr_pages - nr, pages,
> > > > -                                             gup_flags);
> > > > +               if (gup_flags & FOLL_LONGTERM) {
> > > > +                       down_read(&current->mm->mmap_sem);
> > > > +                       ret = __gup_longterm_locked(current, current->mm,
> > > > +                                                   start, nr_pages - nr,
> > > > +                                                   pages, NULL, gup_flags);
> > > > +                       up_read(&current->mm->mmap_sem);
> > > > +               } else {
> > > > +                       /*
> > > > +                        * retain FAULT_FOLL_ALLOW_RETRY optimization if
> > > > +                        * possible
> > > > +                        */
> > > > +                       ret = get_user_pages_unlocked(start, nr_pages - nr,
> > > > +                                                     pages, gup_flags);
> > > 
> > > I couldn't immediately grok why this path needs to branch on
> > > FOLL_LONGTERM? Won't get_user_pages_unlocked(..., FOLL_LONGTERM) do
> > > the right thing?
> > 
> > Unfortunately holding the lock is required to support FOLL_LONGTERM (to check
> > the VMAs) but we don't want to hold the lock to be optimal (specifically allow
> > FAULT_FOLL_ALLOW_RETRY).  So I'm maintaining the optimization for *_fast users
> > who do not specify FOLL_LONGTERM.
> > 
> > Another way to do this would have been to define __gup_longterm_unlocked with
> > the above logic, but that seemed overkill at this point.
> 
> get_user_pages_unlocked() is an exported symbol, shouldn't it work
> with the FOLL_LONGTERM flag?
> 
> I think it should even though we have no user..
> 
> Otherwise the GUP API just gets more confusing.

I agree WRT to the API.  But I think callers of get_user_pages_unlocked() are
not going to get the behavior they want if they specify FOLL_LONGTERM.

What I could do is BUG_ON (or just WARN_ON) if unlocked is called with
FOLL_LONGTERM similar to the code in get_user_pages_locked() which does not
allow locked and vmas to be passed together:

        if (locked) {
                /* if VM_FAULT_RETRY can be returned, vmas become invalid */
                BUG_ON(vmas);
                /* check caller initialized locked */
                BUG_ON(*locked != 1);
        }

Combining Dan's comment and yours; I could do something like below? (not even
compile tested)  Coded with WARN_ON because technically I _think_ the
FOLL_LONGTERM would "work" but not be optimal.  I'm just not 100% sure.  A
BUG_ON would be most protective IMO.


diff --git a/mm/gup.c b/mm/gup.c
index 173db0c44678..8e31411f485f 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1014,6 +1014,29 @@ long get_user_pages_locked(unsigned long start, unsigned long nr_pages,
 }
 EXPORT_SYMBOL(get_user_pages_locked);
 
+long __gup_longterm_unlocked(unsigned long start, unsigned long nr_pages,
+			     struct page **pages, unsigned int gup_flags)
+{
+	struct mm_struct *mm = current->mm;
+	int locked = 1;
+	long ret;
+
+	down_read(&mm->mmap_sem);
+	if (gup_flags & FOLL_LONGTERM) {
+		ret = __gup_longterm_locked(current, mm,
+					    start, nr_pages - nr,
+					    pages, NULL, gup_flags);
+	} else {
+		ret = __get_user_pages_locked(current, mm, start, nr_pages,
+					      pages, NULL, &locked,
+					      gup_flags | FOLL_TOUCH);
+	}
+	if (locked)
+		up_read(&mm->mmap_sem);
+
+	return ret;
+}
+
 /*
  * get_user_pages_unlocked() is suitable to replace the form:
  *
@@ -1032,16 +1055,9 @@ EXPORT_SYMBOL(get_user_pages_locked);
 long get_user_pages_unlocked(unsigned long start, unsigned long nr_pages,
 			     struct page **pages, unsigned int gup_flags)
 {
-	struct mm_struct *mm = current->mm;
-	int locked = 1;
-	long ret;
+	WARN_ON(gup_flags & FOLL_LONGTERM);
 
-	down_read(&mm->mmap_sem);
-	ret = __get_user_pages_locked(current, mm, start, nr_pages, pages, NULL,
-				      &locked, gup_flags | FOLL_TOUCH);
-	if (locked)
-		up_read(&mm->mmap_sem);
-	return ret;
+	__gup_longterm_unlocked(start, nr_pages, pages, gup_flags);
 }
 EXPORT_SYMBOL(get_user_pages_unlocked);
 
@@ -2075,20 +2091,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages,
 		start += nr << PAGE_SHIFT;
 		pages += nr;
 
-		if (gup_flags & FOLL_LONGTERM) {
-			down_read(&current->mm->mmap_sem);
-			ret = __gup_longterm_locked(current, current->mm,
-						    start, nr_pages - nr,
-						    pages, NULL, gup_flags);
-			up_read(&current->mm->mmap_sem);
-		} else {
-			/*
-			 * retain FAULT_FOLL_ALLOW_RETRY optimization if
-			 * possible
-			 */
-			ret = get_user_pages_unlocked(start, nr_pages - nr,
-						      pages, gup_flags);
-		}
+		__gup_longterm_unlocked();
 
 		/* Have to be a bit careful with return values */
 		if (nr > 0) {
