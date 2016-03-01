From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] rds kernel space part of change for rds-stress -D
 option failure
Date: Tue, 1 Mar 2016 20:55:31 +0200
Message-ID: <20160301185530.GA5975@yuval-lap.uk.oracle.com>
References: <1456796846-8596-1-git-send-email-zdai@linux.vnet.ibm.com>
 <1456796846-8596-3-git-send-email-zdai@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456796846-8596-3-git-send-email-zdai-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dai <zdai-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, clsoto-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Please check commit 1d2e3f39.

On Mon, Feb 29, 2016 at 07:47:26PM -0600, David Dai wrote:
> ---
>  net/rds/rdma.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/net/rds/rdma.c b/net/rds/rdma.c
> index b08ca60..d603645 100755
> --- a/net/rds/rdma.c
> +++ b/net/rds/rdma.c
> @@ -657,6 +657,7 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rds_message *rm,
>  		ret = rds_pin_pages(iov->addr, nr, pages, !op->op_write);
>  		if (ret < 0)
>  			goto out;
> +		ret = 0;	
>  
>  		rdsdebug("RDS: nr_bytes %u nr %u iov->bytes %llu iov->addr %llx\n",
>  			 nr_bytes, nr, iov->bytes, iov->addr);
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
