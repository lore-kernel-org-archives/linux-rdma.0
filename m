From: Bjorn Helgaas <helgaas-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v9 07/13] block: Add PCI P2P flag for request queue and
 check support for requests
Date: Wed, 10 Oct 2018 14:59:01 -0500
Message-ID: <20181010195901.GE5906@bhelgaas-glaptop.roam.corp.google.com>
References: <20181004212747.6301-1-logang@deltatee.com>
 <20181004212747.6301-8-logang@deltatee.com>
 <485de371-0e84-6f20-7f3b-cec5635b87fe@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <485de371-0e84-6f20-7f3b-cec5635b87fe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 05, 2018 at 07:16:04PM -0600, Jens Axboe wrote:
> On 10/4/18 3:27 PM, Logan Gunthorpe wrote:
> > QUEUE_FLAG_PCI_P2P is introduced meaning a driver's request queue
> > supports targeting P2P memory. This will be used by P2P providers and
> > orchestrators (in subsequent patches) to ensure block devices can
> > support P2P memory before submitting P2P backed pages to submit_bio().
> 
> Nit pick, but the subject line still says that it checks support
> for requests. This patch just adds the ability to flag support
> in the queue.

What about the following?  MAINTAINERS doesn't list a specific
maintainer for include/linux/blkdev.h (maybe the "BLOCK LAYER" entry
should have an F: pattern for it?), but I'd really like your ack
before merging this.

commit 7e647ae1eda290786851c3dff4f38189b982386d
Author: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Date:   Thu Oct 4 15:27:41 2018 -0600

    block: Add PCI P2P flag for request queue
    
    Add QUEUE_FLAG_PCI_P2P, meaning a driver's request queue supports targeting
    P2P memory.  This will be used by P2P providers and orchestrators (in
    subsequent patches) to ensure block devices can support P2P memory before
    submitting P2P-backed pages to submit_bio().
    
    Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Bjorn Helgaas <bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
    Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6980014357d4..c32f7171899b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -699,6 +699,7 @@ struct request_queue {
 #define QUEUE_FLAG_SCSI_PASSTHROUGH 27	/* queue supports SCSI commands */
 #define QUEUE_FLAG_QUIESCED    28	/* queue has been quiesced */
 #define QUEUE_FLAG_PREEMPT_ONLY	29	/* only process REQ_PREEMPT requests */
+#define QUEUE_FLAG_PCI_P2PDMA  30	/* device supports PCI p2p requests */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_SAME_COMP)	|	\
@@ -731,6 +732,8 @@ bool blk_queue_flag_test_and_clear(unsigned int flag, struct request_queue *q);
 #define blk_queue_dax(q)	test_bit(QUEUE_FLAG_DAX, &(q)->queue_flags)
 #define blk_queue_scsi_passthrough(q)	\
 	test_bit(QUEUE_FLAG_SCSI_PASSTHROUGH, &(q)->queue_flags)
+#define blk_queue_pci_p2pdma(q)	\
+	test_bit(QUEUE_FLAG_PCI_P2PDMA, &(q)->queue_flags)
 
 #define blk_noretry_request(rq) \
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
