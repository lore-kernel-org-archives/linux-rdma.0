From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RESEND 3/7] mm/gup: Change GUP fast to use flags rather than a
 write 'bool'
Date: Fri, 22 Mar 2019 15:05:53 -0700
Message-ID: <CAA9_cmd9gUWMbpkP_AuxZ08iqvZdxjbtDoR-FpSjAyhZJisRZA@mail.gmail.com>
References: <20190317183438.2057-1-ira.weiny@intel.com> <20190317183438.2057-4-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190317183438.2057-4-ira.weiny@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ira.weiny@intel.com
Cc: Andrew Morton <akpm@linux-foundation.org>, John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, "David S. Miller" <davem@davemloft.net>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Rich Felker <dalias@libc.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Ralf Baechle <ralf@linux-mips.org>, James Hogan <jhogan@kernel.org>, linux-mm <linux-mm@kvack.org>Linux Kernel Mailing List <l>
List-Id: linux-rdma@vger.kernel.org

On Sun, Mar 17, 2019 at 7:36 PM <ira.weiny@intel.com> wrote:
>
> From: Ira Weiny <ira.weiny@intel.com>
>
> To facilitate additional options to get_user_pages_fast() change the
> singular write parameter to be gup_flags.
>
> This patch does not change any functionality.  New functionality will
> follow in subsequent patches.
>
> Some of the get_user_pages_fast() call sites were unchanged because they
> already passed FOLL_WRITE or 0 for the write parameter.
>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
>
> ---
> Changes from V1:
>         Rebase to current merge tree
>         arch/powerpc/mm/mmu_context_iommu.c no longer calls gup_fast
>                 The gup_longterm was converted in patch 1
>
>  arch/mips/mm/gup.c                         | 11 ++++++-----
>  arch/powerpc/kvm/book3s_64_mmu_hv.c        |  4 ++--
>  arch/powerpc/kvm/e500_mmu.c                |  2 +-
>  arch/s390/kvm/interrupt.c                  |  2 +-
>  arch/s390/mm/gup.c                         | 12 ++++++------
>  arch/sh/mm/gup.c                           | 11 ++++++-----
>  arch/sparc/mm/gup.c                        |  9 +++++----
>  arch/x86/kvm/paging_tmpl.h                 |  2 +-
>  arch/x86/kvm/svm.c                         |  2 +-
>  drivers/fpga/dfl-afu-dma-region.c          |  2 +-
>  drivers/gpu/drm/via/via_dmablit.c          |  3 ++-
>  drivers/infiniband/hw/hfi1/user_pages.c    |  3 ++-
>  drivers/misc/genwqe/card_utils.c           |  2 +-
>  drivers/misc/vmw_vmci/vmci_host.c          |  2 +-
>  drivers/misc/vmw_vmci/vmci_queue_pair.c    |  6 ++++--
>  drivers/platform/goldfish/goldfish_pipe.c  |  3 ++-
>  drivers/rapidio/devices/rio_mport_cdev.c   |  4 +++-
>  drivers/sbus/char/oradax.c                 |  2 +-
>  drivers/scsi/st.c                          |  3 ++-
>  drivers/staging/gasket/gasket_page_table.c |  4 ++--
>  drivers/tee/tee_shm.c                      |  2 +-
>  drivers/vfio/vfio_iommu_spapr_tce.c        |  3 ++-
>  drivers/vhost/vhost.c                      |  2 +-
>  drivers/video/fbdev/pvr2fb.c               |  2 +-
>  drivers/virt/fsl_hypervisor.c              |  2 +-
>  drivers/xen/gntdev.c                       |  2 +-
>  fs/orangefs/orangefs-bufmap.c              |  2 +-
>  include/linux/mm.h                         |  4 ++--
>  kernel/futex.c                             |  2 +-
>  lib/iov_iter.c                             |  7 +++++--
>  mm/gup.c                                   | 10 +++++-----
>  mm/util.c                                  |  8 ++++----
>  net/ceph/pagevec.c                         |  2 +-
>  net/rds/info.c                             |  2 +-
>  net/rds/rdma.c                             |  3 ++-
>  35 files changed, 79 insertions(+), 63 deletions(-)


>
> diff --git a/arch/mips/mm/gup.c b/arch/mips/mm/gup.c
> index 0d14e0d8eacf..4c2b4483683c 100644
> --- a/arch/mips/mm/gup.c
> +++ b/arch/mips/mm/gup.c
> @@ -235,7 +235,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
>   * get_user_pages_fast() - pin user pages in memory
>   * @start:     starting user address
>   * @nr_pages:  number of pages from start to pin
> - * @write:     whether pages will be written to
> + * @gup_flags: flags modifying pin behaviour
>   * @pages:     array that receives pointers to the pages pinned.
>   *             Should be at least nr_pages long.
>   *
> @@ -247,8 +247,8 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
>   * requested. If nr_pages is 0 or negative, returns 0. If no pages
>   * were pinned, returns -errno.
>   */
> -int get_user_pages_fast(unsigned long start, int nr_pages, int write,
> -                       struct page **pages)
> +int get_user_pages_fast(unsigned long start, int nr_pages,
> +                       unsigned int gup_flags, struct page **pages)

This looks a tad scary given all related thrash especially when it's
only 1 user that wants to do get_user_page_fast_longterm, right? Maybe
something like the following. Note I explicitly moved the flags to the
end so that someone half paying attention that calls
__get_user_pages_fast will get a compile error if they specify the
args in the same order.

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 76ba638ceda8..c6c743bc2c68 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1505,8 +1505,15 @@ static inline long
get_user_pages_longterm(unsigned long start,
 }
 #endif /* CONFIG_FS_DAX */

-int get_user_pages_fast(unsigned long start, int nr_pages, int write,
-                       struct page **pages);
+
+int __get_user_pages_fast(unsigned long start, int nr_pages,
+               struct page **pages, unsigned int gup_flags);
+
+static inline int get_user_pages_fast(unsigned long start, int
nr_pages, int write,
+                       struct page **pages)
+{
+       return __get_user_pages_fast(start, nr_pages, pages, write ?
FOLL_WRITE);
+}

 /* Container for pinned pfns / pages */
 struct frame_vector {
