From: Oliver <oohall-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 07/10] nvme-pci: Use PCI p2pmem subsystem to manage the
 CMB
Date: Mon, 5 Mar 2018 12:33:29 +1100
Message-ID: <CAOSf1CEj1vmLLd27-642=XSnL9ODkpEC0qLHA2_W5_7rV5+4Pg@mail.gmail.com>
References: <20180228234006.21093-1-logang@deltatee.com>
 <20180228234006.21093-8-logang@deltatee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180228234006.21093-8-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 1, 2018 at 10:40 AM, Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org> wrote:
> Register the CMB buffer as p2pmem and use the appropriate allocation
> functions to create and destroy the IO SQ.
>
> If the CMB supports WDS and RDS, publish it for use as p2p memory
> by other devices.
>
> Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/nvme/host/pci.c | 75 +++++++++++++++++++++++++++----------------------
>  1 file changed, 41 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> index 73036d2fbbd5..56ca79be8476 100644
> --- a/drivers/nvme/host/pci.c
> +++ b/drivers/nvme/host/pci.c
> @@ -29,6 +29,7 @@
>  #include <linux/types.h>
>  #include <linux/io-64-nonatomic-lo-hi.h>
>  #include <linux/sed-opal.h>
> +#include <linux/pci-p2pdma.h>
>
>  #include "nvme.h"
>
> @@ -91,9 +92,8 @@ struct nvme_dev {
>         struct work_struct remove_work;
>         struct mutex shutdown_lock;
>         bool subsystem;
> -       void __iomem *cmb;
> -       pci_bus_addr_t cmb_bus_addr;
>         u64 cmb_size;
> +       bool cmb_use_sqes;
>         u32 cmbsz;
>         u32 cmbloc;
>         struct nvme_ctrl ctrl;
> @@ -148,7 +148,7 @@ struct nvme_queue {
>         struct nvme_dev *dev;
>         spinlock_t q_lock;
>         struct nvme_command *sq_cmds;
> -       struct nvme_command __iomem *sq_cmds_io;
> +       bool sq_cmds_is_io;
>         volatile struct nvme_completion *cqes;
>         struct blk_mq_tags **tags;
>         dma_addr_t sq_dma_addr;
> @@ -429,10 +429,7 @@ static void __nvme_submit_cmd(struct nvme_queue *nvmeq,
>  {
>         u16 tail = nvmeq->sq_tail;

> -       if (nvmeq->sq_cmds_io)
> -               memcpy_toio(&nvmeq->sq_cmds_io[tail], cmd, sizeof(*cmd));
> -       else
> -               memcpy(&nvmeq->sq_cmds[tail], cmd, sizeof(*cmd));
> +       memcpy(&nvmeq->sq_cmds[tail], cmd, sizeof(*cmd));

Hmm, how safe is replacing memcpy_toio() with regular memcpy()? On PPC
the _toio() variant enforces alignment, does the copy with 4 byte
stores, and has a full barrier after the copy. In comparison our
regular memcpy() does none of those things and may use unaligned and
vector load/stores. For normal (cacheable) memory that is perfectly
fine, but they can cause alignment faults when targeted at MMIO
(cache-inhibited) memory.

I think in this particular case it might be ok since we know SEQs are
aligned to 64 byte boundaries and the copy is too small to use our
vectorised memcpy(). I'll assume we don't need explicit ordering
between writes of SEQs since the existing code doesn't seem to care
unless the doorbell is being rung, so you're probably fine there too.
That said, I still think this is a little bit sketchy and at the very
least you should add a comment explaining what's going on when the CMB
is being used. If someone more familiar with the NVMe driver could
chime in I would appreciate it.

>         if (++tail == nvmeq->q_depth)
>                 tail = 0;
> @@ -1286,9 +1283,18 @@ static void nvme_free_queue(struct nvme_queue *nvmeq)
>  {
>         dma_free_coherent(nvmeq->q_dmadev, CQ_SIZE(nvmeq->q_depth),
>                                 (void *)nvmeq->cqes, nvmeq->cq_dma_addr);
> -       if (nvmeq->sq_cmds)
> -               dma_free_coherent(nvmeq->q_dmadev, SQ_SIZE(nvmeq->q_depth),
> -                                       nvmeq->sq_cmds, nvmeq->sq_dma_addr);
> +
> +       if (nvmeq->sq_cmds) {
> +               if (nvmeq->sq_cmds_is_io)
> +                       pci_free_p2pmem(to_pci_dev(nvmeq->q_dmadev),
> +                                       nvmeq->sq_cmds,
> +                                       SQ_SIZE(nvmeq->q_depth));
> +               else
> +                       dma_free_coherent(nvmeq->q_dmadev,
> +                                         SQ_SIZE(nvmeq->q_depth),
> +                                         nvmeq->sq_cmds,
> +                                         nvmeq->sq_dma_addr);
> +       }
>  }
>
>  static void nvme_free_queues(struct nvme_dev *dev, int lowest)
> @@ -1368,12 +1374,21 @@ static int nvme_cmb_qdepth(struct nvme_dev *dev, int nr_io_queues,
>  static int nvme_alloc_sq_cmds(struct nvme_dev *dev, struct nvme_queue *nvmeq,
>                                 int qid, int depth)
>  {
> -       /* CMB SQEs will be mapped before creation */
> -       if (qid && dev->cmb && use_cmb_sqes && (dev->cmbsz & NVME_CMBSZ_SQS))
> -               return 0;
> +       struct pci_dev *pdev = to_pci_dev(dev->dev);
> +
> +       if (qid && dev->cmb_use_sqes && (dev->cmbsz & NVME_CMBSZ_SQS)) {
> +               nvmeq->sq_cmds = pci_alloc_p2pmem(pdev, SQ_SIZE(depth));
> +               nvmeq->sq_dma_addr = pci_p2pmem_virt_to_bus(pdev,
> +                                               nvmeq->sq_cmds);
> +               nvmeq->sq_cmds_is_io = true;
> +       }
> +
> +       if (!nvmeq->sq_cmds) {
> +               nvmeq->sq_cmds = dma_alloc_coherent(dev->dev, SQ_SIZE(depth),
> +                                       &nvmeq->sq_dma_addr, GFP_KERNEL);
> +               nvmeq->sq_cmds_is_io = false;
> +       }
>
> -       nvmeq->sq_cmds = dma_alloc_coherent(dev->dev, SQ_SIZE(depth),
> -                                           &nvmeq->sq_dma_addr, GFP_KERNEL);
>         if (!nvmeq->sq_cmds)
>                 return -ENOMEM;
>         return 0;
> @@ -1449,13 +1464,6 @@ static int nvme_create_queue(struct nvme_queue *nvmeq, int qid)
>         struct nvme_dev *dev = nvmeq->dev;
>         int result;
>
> -       if (dev->cmb && use_cmb_sqes && (dev->cmbsz & NVME_CMBSZ_SQS)) {
> -               unsigned offset = (qid - 1) * roundup(SQ_SIZE(nvmeq->q_depth),
> -                                                     dev->ctrl.page_size);
> -               nvmeq->sq_dma_addr = dev->cmb_bus_addr + offset;
> -               nvmeq->sq_cmds_io = dev->cmb + offset;
> -       }
> -
>         nvmeq->cq_vector = qid - 1;
>         result = adapter_alloc_cq(dev, qid, nvmeq);
>         if (result < 0)
> @@ -1685,9 +1693,6 @@ static void nvme_map_cmb(struct nvme_dev *dev)
>                 return;
>         dev->cmbloc = readl(dev->bar + NVME_REG_CMBLOC);
>
> -       if (!use_cmb_sqes)
> -               return;
> -
>         size = nvme_cmb_size_unit(dev) * nvme_cmb_size(dev);
>         offset = nvme_cmb_size_unit(dev) * NVME_CMB_OFST(dev->cmbloc);
>         bar = NVME_CMB_BIR(dev->cmbloc);
> @@ -1704,11 +1709,15 @@ static void nvme_map_cmb(struct nvme_dev *dev)
>         if (size > bar_size - offset)
>                 size = bar_size - offset;
>
> -       dev->cmb = ioremap_wc(pci_resource_start(pdev, bar) + offset, size);
> -       if (!dev->cmb)
> +       if (pci_p2pdma_add_resource(pdev, bar, size, offset))
>                 return;
> -       dev->cmb_bus_addr = pci_bus_address(pdev, bar) + offset;
> +
>         dev->cmb_size = size;
> +       dev->cmb_use_sqes = use_cmb_sqes && (dev->cmbsz & NVME_CMBSZ_SQS);
> +
> +       if ((dev->cmbsz & (NVME_CMBSZ_WDS | NVME_CMBSZ_RDS)) ==
> +                       (NVME_CMBSZ_WDS | NVME_CMBSZ_RDS))
> +               pci_p2pmem_publish(pdev, true);
>
>         if (sysfs_add_file_to_group(&dev->ctrl.device->kobj,
>                                     &dev_attr_cmb.attr, NULL))
> @@ -1718,12 +1727,10 @@ static void nvme_map_cmb(struct nvme_dev *dev)
>
>  static inline void nvme_release_cmb(struct nvme_dev *dev)
>  {
> -       if (dev->cmb) {
> -               iounmap(dev->cmb);
> -               dev->cmb = NULL;
> +       if (dev->cmb_size) {
>                 sysfs_remove_file_from_group(&dev->ctrl.device->kobj,
>                                              &dev_attr_cmb.attr, NULL);
> -               dev->cmbsz = 0;
> +               dev->cmb_size = 0;
>         }
>  }
>
> @@ -1918,13 +1925,13 @@ static int nvme_setup_io_queues(struct nvme_dev *dev)
>         if (nr_io_queues == 0)
>                 return 0;
>
> -       if (dev->cmb && (dev->cmbsz & NVME_CMBSZ_SQS)) {
> +       if (dev->cmb_use_sqes) {
>                 result = nvme_cmb_qdepth(dev, nr_io_queues,
>                                 sizeof(struct nvme_command));
>                 if (result > 0)
>                         dev->q_depth = result;
>                 else
> -                       nvme_release_cmb(dev);
> +                       dev->cmb_use_sqes = false;
>         }
>
>         do {
> --
> 2.11.0
>
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
