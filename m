From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 2/9] IB/core: allow passing mapping an offset into the SG
 in ib_map_mr_sg
Date: Mon, 29 Feb 2016 15:13:56 -0800
Message-ID: <56D4D0B4.3040307@sandisk.com>
References: <1456784410-20166-1-git-send-email-hch@lst.de>
 <1456784410-20166-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456784410-20166-3-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Cc: "swise@opengridcomputing.com" <swise@opengridcomputing.com>, "sagig@mellanox.com" <sagig@mellanox.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 02/29/2016 02:20 PM, Christoph Hellwig wrote:
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index 5af6d02..1d04cea 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -1557,6 +1557,7 @@ EXPORT_SYMBOL(ib_check_mr_status);
>    * @mr:            memory region
>    * @sg:            dma mapped scatterlist
>    * @sg_nents:      number of entries in sg
> + * @sg_offset:     offset in byes into sg
>    * @page_size:     page vector desired page size
>    *
>    * Constraints:

Hi Christoph,

Please spell this and the second occurrence as "bytes".

Thanks,

Bart.
