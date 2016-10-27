From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/12] blk-mq: Introduce blk_mq_queue_stopped()
Date: Thu, 27 Oct 2016 07:49:13 +0200
Message-ID: <d1afa90c-b1ee-8185-0fac-40a812ed195c@suse.de>
References: <b22edafc-725f-0419-d074-34d35d57d126@sandisk.com>
 <f68b2997-8b0d-7aea-2859-5fbda4f6bf71@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <f68b2997-8b0d-7aea-2859-5fbda4f6bf71@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lei <tom.leiming@gmail.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-rdma@vger.kernel.org

On 10/27/2016 12:52 AM, Bart Van Assche wrote:
> The function blk_queue_stopped() allows to test whether or not a
> traditional request queue has been stopped. Introduce a helper
> function that allows block drivers to query easily whether or not
> one or more hardware contexts of a blk-mq queue have been stopped.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/blk-mq.c         | 20 ++++++++++++++++++++
>  include/linux/blk-mq.h |  1 +
>  2 files changed, 21 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
