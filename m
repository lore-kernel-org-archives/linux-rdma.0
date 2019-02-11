From: John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH 2/3] mm/gup: Introduce get_user_pages_fast_longterm()
Date: Mon, 11 Feb 2019 14:01:11 -0800
Message-ID: <f392756e-f885-e32e-77a9-d3a51689bee0@nvidia.com>
References: <20190211201643.7599-1-ira.weiny@intel.com>
 <20190211201643.7599-3-ira.weiny@intel.com> <20190211203916.GA2771@ziepe.ca>
 <bcc03ee1-4c42-48c3-bc67-942c0f04875e@nvidia.com>
 <20190211212652.GA7790@iweiny-DESK2.sc.intel.com>
 <fc9c880b-24f8-7063-6094-00175bc27f7d@nvidia.com>
 <20190211215238.GA23825@iweiny-DESK2.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190211215238.GA23825@iweiny-DESK2.sc.intel.com>
Content-Language: en-US-large
Sender: linux-kernel-owner@vger.kernel.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Daniel Borkmann <daniel@iogearbox.net>, Davidlohr Bueso <dave@stgolabs.net>, netdev@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Doug Ledford <dledford@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-rdma@vger.kernel.org

On 2/11/19 1:52 PM, Ira Weiny wrote:
> On Mon, Feb 11, 2019 at 01:39:12PM -0800, John Hubbard wrote:
>> On 2/11/19 1:26 PM, Ira Weiny wrote:
>>> On Mon, Feb 11, 2019 at 01:13:56PM -0800, John Hubbard wrote:
>>>> On 2/11/19 12:39 PM, Jason Gunthorpe wrote:
>>>>> On Mon, Feb 11, 2019 at 12:16:42PM -0800, ira.weiny@intel.com wrote:
>>>>>> From: Ira Weiny <ira.weiny@intel.com>
>>>> [...]
> Fair enough.   But to do that correctly I think we will need to convert
> get_user_pages_fast() to use flags as well.  I have a version of this series
> which includes a patch does this, but the patch touched a lot of subsystems and
> a couple of different architectures...[1]
> 
> I can't test them all.  If we want to go that way I'm up for submitting the

I have a similar problem, and a similar list of call sites, for the
put_user_pages() conversion, so that file list looks familiar. And the
arch-specific gup implementations are about to complicate my life too. :)

> patch...  But if we remove longterm in the future we may be left with a
> get_user_pages_fast() which really only needs 1 flag.  But perhaps overall we
> would be better off?
> 
> Ira

I certainly think so, yes.


thanks,
-- 
John Hubbard
NVIDIA
> 
> 
> [1] mm/gup.c: Change GUP fast to use flags rather than write bool
> 
> To facilitate additional options to get_user_pages_fast change the
> singular write parameter to be the more generic gup_flags.
> 
> This patch currently does not change any functionality.  New
> functionality will follow in subsequent patches.
> 
> Many of the get_user_pages_fast call sites were unchanged because they
> already used FOLL_WRITE or 0 as appropriate.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  arch/mips/mm/gup.c                         | 11 ++++++-----
>  arch/powerpc/kvm/book3s_64_mmu_hv.c        |  4 ++--
>  arch/powerpc/kvm/e500_mmu.c                |  2 +-
>  arch/powerpc/mm/mmu_context_iommu.c        |  4 ++--
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
>  36 files changed, 81 insertions(+), 65 deletions(-)
> 
> 
