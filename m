From: "Deucher, Alexander" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>
Subject: Enabling peer to peer device transactions for PCIe devices
Date: Mon, 21 Nov 2016 20:36:25 +0000
Message-ID: <MWHPR12MB169484839282E2D56124FA02F7B50@MWHPR12MB1694.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "'linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "'linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "'linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org'" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "'Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <Linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "'dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org'" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "'linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org'" <linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Bridgman, John" <John.Bridgman-5C7GfCeVMHo@public.gmane.org>, "Kuehling,
 Felix" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>, "Sagalovitch,
 Serguei" <Serguei.Sagalovitch-5C7GfCeVMHo@public.gmane.org>, "Blinzer, Paul" <Paul.Blinzer-5C7GfCeVMHo@public.gmane.org>, "Koenig, Christian" <Christian.Koenig-5C7GfCeVMHo@public.gmane.org>, "Suthikulpanit,
 Suravee" <Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org>, "Sander, Ben" <ben.sander-5C7GfCeVMHo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is certainly not the first time this has been brought up, but I'd like to try and get some consensus on the best way to move this forward.  Allowing devices to talk directly improves performance and reduces latency by avoiding the use of staging buffers in system memory.  Also in cases where both devices are behind a switch, it avoids the CPU entirely.  Most current APIs (DirectGMA, PeerDirect, CUDA, HSA) that deal with this are pointer based.  Ideally we'd be able to take a CPU virtual address and be able to get to a physical address taking into account IOMMUs, etc.  Having struct pages for the memory would allow it to work more generally and wouldn't require as much explicit support in drivers that wanted to use it.
 
Some use cases:
1. Storage devices streaming directly to GPU device memory
2. GPU device memory to GPU device memory streaming
3. DVB/V4L/SDI devices streaming directly to GPU device memory
4. DVB/V4L/SDI devices streaming directly to storage devices
 
Here is a relatively simple example of how this could work for testing.  This is obviously not a complete solution.
- Device memory will be registered with Linux memory sub-system by created corresponding struct page structures for device memory
- get_user_pages_fast() will  return corresponding struct pages when CPU address points to the device memory
- put_page() will deal with struct pages for device memory
 
Previously proposed solutions and related proposals:
1.P2P DMA
DMA-API/PCI map_peer_resource support for peer-to-peer (http://www.spinics.net/lists/linux-pci/msg44560.html)
Pros: Low impact, already largely reviewed.
Cons: requires explicit support in all drivers that want to support it, doesn't handle S/G in device memory.
 
2. ZONE_DEVICE IO
Direct I/O and DMA for persistent memory (https://lwn.net/Articles/672457/)
Add support for ZONE_DEVICE IO memory with struct pages. (https://patchwork.kernel.org/patch/8583221/)
Pro: Doesn't waste system memory for ZONE metadata
Cons: CPU access to ZONE metadata slow, may be lost, corrupted on device reset.
 
3. DMA-BUF
RDMA subsystem DMA-BUF support (http://www.spinics.net/lists/linux-rdma/msg38748.html)
Pros: uses existing dma-buf interface
Cons: dma-buf is handle based, requires explicit dma-buf support in drivers.

4. iopmem
iopmem : A block device for PCIe memory (https://lwn.net/Articles/703895/)
 
5. HMM
Heterogeneous Memory Management (http://lkml.iu.edu/hypermail/linux/kernel/1611.2/02473.html)

6. Some new mmap-like interface that takes a userptr and a length and returns a dma-buf and offset?
 
Alex
