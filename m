From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 08/13] IB/srpt: chain RDMA READ/WRITE requests
Date: Thu, 10 Dec 2015 10:42:30 -0800
Message-ID: <5669C796.5010406@sandisk.com>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
 <1449521512-22921-9-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1449521512-22921-9-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 12/07/2015 12:51 PM, Christoph Hellwig wrote:
> Remove struct rdma_iu and instead allocate the struct ib_rdma_wr array
> early and fill out directly.  This allows us to chain the WRs, and thus
> archive both less lock contention on the HCA workqueue as well as much
   ^^^^^^^

Did you perhaps intend "achieve" ?

>   struct srpt_send_ioctx {
>   	struct srpt_ioctx	ioctx;
>   	struct srpt_rdma_ch	*ch;
> -	struct rdma_iu		*rdma_ius;
> +	struct ib_rdma_wr	*rdma_ius;

Please rename the "rdma_ius" member into "wr" or any other name that 
shows that this member is now a work request array and nothing else.

Otherwise this patch looks fine to me.

Bart.
