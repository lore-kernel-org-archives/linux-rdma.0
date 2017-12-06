From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH net-next] rds: debug: fix null check on static array
Date: Wed, 06 Dec 2017 15:03:08 -0500 (EST)
Message-ID: <20171206.150308.831930810966973509.davem@davemloft.net>
References: <20171206014704.3796-1-bhole_prashant_q7@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171206014704.3796-1-bhole_prashant_q7-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: bhole_prashant_q7-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org
Cc: netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Prashant Bhole <bhole_prashant_q7-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Date: Wed,  6 Dec 2017 10:47:04 +0900

> t_name cannot be NULL since it is an array field of a struct.
> Replacing null check on static array with string length check using
> strnlen()
> 
> Signed-off-by: Prashant Bhole <bhole_prashant_q7-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>

Applied, thank you.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
