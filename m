From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/iser: fix max_sectors calculation
Date: Wed, 27 Apr 2016 18:45:10 +0300
Message-ID: <5720DE86.6060503@mellanox.com>
References: <1461013588-8825-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461013588-8825-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 4/19/2016 12:06 AM, Christoph Hellwig wrote:
> iSER currently has a couple places that set max_sectors in either the host
> template or SCSI host, and all of them get it wrong.
>
> This patch instead uses a single assignment that (hopefully) gets it right:
> the max_sectors value must be derived from the number of segments in the
> FR or FRM structure, but actually be one lower than the page size multiplied

* FRM ==> FMR

> by the number of sectors, as it has to handle the case of non-aligned I/O.
>
> Without this I get trivivial to reproduce hangs when running xfstests
> (on XFS) over iSER to Linux targets.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>   drivers/infiniband/ulp/iser/iscsi_iser.c | 14 ++++++++++----
>   1 file changed, 10 insertions(+), 4 deletions(-)
>

Looks good.

Reviewed-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
