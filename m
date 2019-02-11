From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH 2/3] mm/gup: Introduce get_user_pages_fast_longterm()
Date: Mon, 11 Feb 2019 13:52:38 -0800
Message-ID: <20190211215238.GA23825@iweiny-DESK2.sc.intel.com>
References: <20190211201643.7599-1-ira.weiny@intel.com>
 <20190211201643.7599-3-ira.weiny@intel.com>
 <20190211203916.GA2771@ziepe.ca>
 <bcc03ee1-4c42-48c3-bc67-942c0f04875e@nvidia.com>
 <20190211212652.GA7790@iweiny-DESK2.sc.intel.com>
 <fc9c880b-24f8-7063-6094-00175bc27f7d@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <fc9c880b-24f8-7063-6094-00175bc27f7d@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Hubbard <jhubbard@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Daniel Borkmann <daniel@iogearbox.net>, Davidlohr Bueso <dave@stgolabs.net>, netdev@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 11, 2019 at 01:39:12PM -0800, John Hubbard wrote:
> On 2/11/19 1:26 PM, Ira Weiny wrote:
> > On Mon, Feb 11, 2019 at 01:13:56PM -0800, John Hubbard wrote:
> >> On 2/11/19 12:39 PM, Jason Gunthorpe wrote:
> >>> On Mon, Feb 11, 2019 at 12:16:42PM -0800, ira.weiny@intel.com wrote:
> >>>> From: Ira Weiny <ira.weiny@intel.com>
> >> [...]
> >> It seems to me that the longterm vs. short-term is of questionable value.
> > 
> > This is exactly why I did not post this before.  I've been waiting our other
> > discussions on how GUP pins are going to be handled to play out.  But with the
> > netdev thread today[1] it seems like we need to make sure we have a "safe" fast
> > variant for a while.  Introducing FOLL_LONGTERM seemed like the cleanest way to
> > do that even if we will not need the distinction in the future...  :-(
> 
> Yes, I agree. Below...
> 
> > [...]
> > This is also why I did not change the get_user_pages_longterm because we could
> > be ripping this all out by the end of the year...  (I hope. :-)
> > 
> > So while this does "pollute" the GUP family of calls I'm hoping it is not
> > forever.
> > 
> > Ira
> > 
> > [1] https://lkml.org/lkml/2019/2/11/1789
> > 
> 
> Yes, and to be clear, I think your patchset here is fine. It is easy to find
> the FOLL_LONGTERM callers if and when we want to change anything. I just think
> also it's appopriate to go a bit further, and use FOLL_LONGTERM all by itself.
> 
> That's because in either design outcome, it's better that way:
> 
> -- If we keep the concept of "I'm a long-term gup call site", then FOLL_LONGTERM
> is just right. The gup API already has _fast and non-fast variants, and once
> you get past a couple, you end up with a multiplication of names that really
> work better as flags. We're there.
> 
> -- If we drop the concept, then you've already done part of the work, by removing
> the _longterm API variants.

Fair enough.   But to do that correctly I think we will need to convert
get_user_pages_fast() to use flags as well.  I have a version of this series
which includes a patch does this, but the patch touched a lot of subsystems and
a couple of different architectures...[1]

I can't test them all.  If we want to go that way I'm up for submitting the
patch...  But if we remove longterm in the future we may be left with a
get_user_pages_fast() which really only needs 1 flag.  But perhaps overall we
would be better off?

Ira


[1] mm/gup.c: Change GUP fast to use flags rather than write bool

To facilitate additional options to get_user_pages_fast change the
singular write parameter to be the more generic gup_flags.

This patch currently does not change any functionality.  New
functionality will follow in subsequent patches.

Many of the get_user_pages_fast call sites were unchanged because they
already used FOLL_WRITE or 0 as appropriate.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 arch/mips/mm/gup.c                         | 11 ++++++-----
 arch/powerpc/kvm/book3s_64_mmu_hv.c        |  4 ++--
 arch/powerpc/kvm/e500_mmu.c                |  2 +-
 arch/powerpc/mm/mmu_context_iommu.c        |  4 ++--
 arch/s390/kvm/interrupt.c                  |  2 +-
 arch/s390/mm/gup.c                         | 12 ++++++------
 arch/sh/mm/gup.c                           | 11 ++++++-----
 arch/sparc/mm/gup.c                        |  9 +++++----
 arch/x86/kvm/paging_tmpl.h                 |  2 +-
 arch/x86/kvm/svm.c                         |  2 +-
 drivers/fpga/dfl-afu-dma-region.c          |  2 +-
 drivers/gpu/drm/via/via_dmablit.c          |  3 ++-
 drivers/infiniband/hw/hfi1/user_pages.c    |  3 ++-
 drivers/misc/genwqe/card_utils.c           |  2 +-
 drivers/misc/vmw_vmci/vmci_host.c          |  2 +-
 drivers/misc/vmw_vmci/vmci_queue_pair.c    |  6 ++++--
 drivers/platform/goldfish/goldfish_pipe.c  |  3 ++-
 drivers/rapidio/devices/rio_mport_cdev.c   |  4 +++-
 drivers/sbus/char/oradax.c                 |  2 +-
 drivers/scsi/st.c                          |  3 ++-
 drivers/staging/gasket/gasket_page_table.c |  4 ++--
 drivers/tee/tee_shm.c                      |  2 +-
 drivers/vfio/vfio_iommu_spapr_tce.c        |  3 ++-
 drivers/vhost/vhost.c                      |  2 +-
 drivers/video/fbdev/pvr2fb.c               |  2 +-
 drivers/virt/fsl_hypervisor.c              |  2 +-
 drivers/xen/gntdev.c                       |  2 +-
 fs/orangefs/orangefs-bufmap.c              |  2 +-
 include/linux/mm.h                         |  4 ++--
 kernel/futex.c                             |  2 +-
 lib/iov_iter.c                             |  7 +++++--
 mm/gup.c                                   | 10 +++++-----
 mm/util.c                                  |  8 ++++----
 net/ceph/pagevec.c                         |  2 +-
 net/rds/info.c                             |  2 +-
 net/rds/rdma.c                             |  3 ++-
 36 files changed, 81 insertions(+), 65 deletions(-)
