From: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/3] iopmem : A block device for PCIe memory
Date: Tue, 18 Oct 2016 15:42:14 -0600
Message-ID: <1476826937-20665-1-git-send-email-sbates@raithlin.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, jim.macdonald-FgSLVYC75IpWk0Htik3J/w@public.gmane.org, sbates-Rgftl6RXld5BDgjK7y7TUQ@public.gmane.org, logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch follows from an RFC we did earlier this year [1]. This
patchset applies cleanly to v4.9-rc1.

Updates since RFC
-----------------
  Rebased.
  Included the iopmem driver in the submission.

History
-------

There have been several attempts to upstream patchsets that enable
DMAs between PCIe peers. These include Peer-Direct [2] and DMA-Buf
style patches [3]. None have been successful to date. Haggai Eran
gives a nice overview of the prior art in this space in his cover
letter [3].

Motivation and Use Cases
------------------------

PCIe IO devices are getting faster. It is not uncommon now to find PCIe
network and storage devices that can generate and consume several GB/s.
Almost always these devices have either a high performance DMA engine, a
number of exposed PCIe BARs or both.

Until this patch, any high-performance transfer of information between
two PICe devices has required the use of a staging buffer in system
memory. With this patch the bandwidth to system memory is not compromised
when high-throughput transfers occurs between PCIe devices. This means
that more system memory bandwidth is available to the CPU cores for data
processing and manipulation. In addition, in systems where the two PCIe
devices reside behind a PCIe switch the datapath avoids the CPU
entirely.

Consumers
---------

We provide a PCIe device driver in an accompanying patch that can be
used to map any PCIe BAR into a DAX capable block device. For
non-persistent BARs this simply serves as an alternative to using
system memory bounce buffers. For persistent BARs this can serve as an
additional storage device in the system.

Testing and Performance
-----------------------

We have done a moderate about of testing of this patch on a QEMU
environment and on real hardware. On real hardware we have observed
peer-to-peer writes of up to 4GB/s and reads of up to 1.2 GB/s. In
both cases these numbers are limitations of our consumer hardware. In
addition, we have observed that the CPU DRAM bandwidth is not impacted
when using IOPMEM which is not the case when a traditional path
through system memory is taken.

For more information on the testing and performance results see the
GitHub site [4].

Known Issues
------------

1. Address Translation. Suggestions have been made that in certain
architectures and topologies the dma_addr_t passed to the DMA master
in a peer-2-peer transfer will not correctly route to the IO memory
intended. However in our testing to date we have not seen this to be
an issue, even in systems with IOMMUs and PCIe switches. It is our
understanding that an IOMMU only maps system memory and would not
interfere with device memory regions. (It certainly has no opportunity
to do so if the transfer gets routed through a switch).

2. Memory Segment Spacing. This patch has the same limitations that
ZONE_DEVICE does in that memory regions must be spaces at least
SECTION_SIZE bytes part. On x86 this is 128MB and there are cases where
BARs can be placed closer together than this. Thus ZONE_DEVICE would not
be usable on neighboring BARs. For our purposes, this is not an issue as
we'd only be looking at enabling a single BAR in a given PCIe device.
More exotic use cases may have problems with this.

3. Coherency Issues. When IOMEM is written from both the CPU and a PCIe
peer there is potential for coherency issues and for writes to occur out
of order. This is something that users of this feature need to be
cognizant of. Though really, this isn't much different than the
existing situation with things like RDMA: if userspace sets up an MR
for remote use, they need to be careful about using that memory region
themselves.

4. Architecture. Currently this patch is applicable only to x86_64
architectures. The same is true for much of the code pertaining to
PMEM and ZONE_DEVICE. It is hoped that the work will be extended to other
ARCH over time.

References
----------
[1] https://patchwork.kernel.org/patch/8583221/
[2] http://comments.gmane.org/gmane.linux.drivers.rdma/21849
[3] http://www.spinics.net/lists/linux-rdma/msg38748.html
[4] https://github.com/sbates130272/zone-device

Logan Gunthorpe (1):
  memremap.c : Add support for ZONE_DEVICE IO memory with struct pages.

Stephen Bates (2):
  iopmem : Add a block device driver for PCIe attached IO memory.
  iopmem : Add documentation for iopmem driver

 Documentation/blockdev/00-INDEX   |   2 +
 Documentation/blockdev/iopmem.txt |  62 +++++++
 MAINTAINERS                       |   7 +
 drivers/block/Kconfig             |  27 ++++
 drivers/block/Makefile            |   1 +
 drivers/block/iopmem.c            | 333 ++++++++++++++++++++++++++++++++++++++
 drivers/dax/pmem.c                |   4 +-
 drivers/nvdimm/pmem.c             |   4 +-
 include/linux/memremap.h          |   5 +-
 kernel/memremap.c                 |  80 ++++++++-
 tools/testing/nvdimm/test/iomap.c |   3 +-
 11 files changed, 518 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/blockdev/iopmem.txt
 create mode 100644 drivers/block/iopmem.c

--
2.1.4
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
