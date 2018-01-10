From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH net-next] net/mlx5e: fix error return code in
 mlx5e_alloc_rq()
Date: Wed, 10 Jan 2018 15:55:23 -0500 (EST)
Message-ID: <20180110.155523.215374808059512815.davem@davemloft.net>
References: <1515569453-63865-1-git-send-email-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515569453-63865-1-git-send-email-weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, brouer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Date: Wed, 10 Jan 2018 07:30:53 +0000

> Fix to return a negative error code from the xdp_rxq_info_reg() error
> handling case instead of 0, as done elsewhere in this function.
> 
> Fixes: 0ddf543226ac ("xdp/mlx5: setup xdp_rxq_info")
> Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
