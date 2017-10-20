From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 00/13] dax: fix dma vs truncate and remove 'page-less'
 support
Date: Thu, 19 Oct 2017 19:38:56 -0700
Message-ID: <150846713528.24336.4459262264611579791.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Alex
List-Id: linux-rdma@vger.kernel.org

Changes since v2 [1]:
* Add 'dax: handle truncate of dma-busy pages' which builds on the
  removal of page-less dax to fix a latent bug handling dma vs truncate.
* Disable get_user_pages_fast() for dax
* Disable RDMA memory registrations against filesystem-DAX mappings for
  non-ODP (On Demand Paging / Shared Virtual Memory) hardware.
* Fix a compile error when building with HMM enabled

---
tl;dr: A brute force approach to ensure that truncate waits for any
in-flight DMA before freeing filesystem-DAX blocks to the filesystem's
block allocator.

While reviewing the MAP_DIRECT proposal Christoph noted:

    get_user_pages on DAX doesn't give the same guarantees as on
    pagecache or anonymous memory, and that is the problem we need to
    fix. In fact I'm pretty sure if we try hard enough (and we might
    have to try very hard) we can see the same problem with plain direct
    I/O and without any RDMA involved, e.g. do a larger direct I/O write
    to memory that is mmap()ed from a DAX file, then truncate the DAX
    file and reallocate the blocks, and we might corrupt that new file.
    We'll probably need a special setup where there is little other
    chance but to reallocate those used blocks.
    
    So what we need to do first is to fix get_user_pages vs unmapping
    DAX mmap()ed blocks, be that from a hole punch, truncate, COW
    operation, etc.

I was able to trigger the failure with "[PATCH v3 08/13]
tools/testing/nvdimm: add 'bio_delay' mechanism" to keep block i/o pages
busy so a punch-hole operation can truncate the blocks before the DMA
finishes.

The solution presented is not pretty. It creates a stream of leases, one
for each get_user_pages() invocation, and polls page reference counts
until DMA stops. We're missing a reliable way to not only trap the
DMA-idle event, but also block new references being taken on pages while
truncate is allowed to progress. "[PATCH v3 12/13] dax: handle truncate of
dma-busy pages" presents other options considered, and notes that this
solution can only be viewed as a stop-gap.

Given the need to poll page-reference counts this approach builds on the
removal of 'page-less DAX' support. From the last submission Andrew
asked for clarification on the move to now require pages for DAX.
Quoting "[PATCH v3 02/13] dax: require 'struct page' for filesystem
dax":

    Note that when the initial dax support was being merged a few years
    back there was concern that struct page was unsuitable for use with
    next generation persistent memory devices. The theoretical concern
    was that struct page access, being such a hotly used data structure
    in the kernel, would lead to media wear out. While that was a
    reasonable conservative starting position it has not held true in
    practice. We have long since committed to using
    devm_memremap_pages() to support higher order kernel functionality
    that needs get_user_pages() and pfn_to_page().
 

---

Dan Williams (13):
      dax: quiet bdev_dax_supported()
      dax: require 'struct page' for filesystem dax
      dax: stop using VM_MIXEDMAP for dax
      dax: stop using VM_HUGEPAGE for dax
      dax: stop requiring a live device for dax_flush()
      dax: store pfns in the radix
      dax: warn if dma collides with truncate
      tools/testing/nvdimm: add 'bio_delay' mechanism
      IB/core: disable memory registration of fileystem-dax vmas
      mm: disable get_user_pages_fast() for dax
      fs: use smp_load_acquire in break_{layout,lease}
      dax: handle truncate of dma-busy pages
      xfs: wire up FL_ALLOCATED support


 arch/powerpc/sysdev/axonram.c         |    1 
 drivers/dax/device.c                  |    1 
 drivers/dax/super.c                   |   18 +-
 drivers/infiniband/core/umem.c        |   49 ++++-
 drivers/s390/block/dcssblk.c          |    1 
 fs/Kconfig                            |    1 
 fs/dax.c                              |  296 ++++++++++++++++++++++++++++-----
 fs/ext2/file.c                        |    1 
 fs/ext4/file.c                        |    1 
 fs/locks.c                            |   17 ++
 fs/xfs/xfs_aops.c                     |   24 +++
 fs/xfs/xfs_file.c                     |   66 +++++++
 fs/xfs/xfs_inode.h                    |    1 
 fs/xfs/xfs_ioctl.c                    |    7 -
 include/linux/dax.h                   |   23 +++
 include/linux/fs.h                    |   32 +++-
 include/linux/vma.h                   |   33 ++++
 mm/gup.c                              |   75 ++++----
 mm/huge_memory.c                      |    8 -
 mm/ksm.c                              |    3 
 mm/madvise.c                          |    2 
 mm/memory.c                           |   20 ++
 mm/migrate.c                          |    3 
 mm/mlock.c                            |    5 -
 mm/mmap.c                             |    8 -
 tools/testing/nvdimm/Kbuild           |    1 
 tools/testing/nvdimm/test/iomap.c     |   62 +++++++
 tools/testing/nvdimm/test/nfit.c      |   34 ++++
 tools/testing/nvdimm/test/nfit_test.h |    1 
 29 files changed, 651 insertions(+), 143 deletions(-)
 create mode 100644 include/linux/vma.h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
