From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Use vmalloc for WR buffers when needed
Date: Thu, 24 Sep 2015 11:07:02 +0300
Message-ID: <5603AF26.9040403@mellanox.com>
References: <1443077547-12246-1-git-send-email-wen.gang.wang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443077547-12246-1-git-send-email-wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/24/2015 9:52 AM, Wengang Wang wrote:
>   	} else {
> -		kfree(qp->sq.wrid);
> -		kfree(qp->rq.wrid);
> +		if (is_vmalloc_addr(qp->sq.wrid))
> +			vfree(qp->sq.wrid);
> +		else
> +			kfree(qp->sq.wrid);
> +
> +		if (is_vmalloc_addr(qp->rq.wrid))
> +			vfree(qp->rq.wrid);
> +		else
> +			kfree(qp->rq.wrid);
>   	}

NO

just call kvfree, see commit 914efb0 "mlx4: don't duplicate kvfree()"
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
