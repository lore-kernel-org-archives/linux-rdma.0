From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: Maximum size for memory registration (ibv_reg_mr)
Date: Thu, 07 Oct 2010 11:40:02 +0200
Message-ID: <4CAD9572.5060507@Voltaire.com>
References: <036401cb5c35$85829220$9087b660$@edu>	<adar5giahvd.fsf@cisco.com> <037101cb5c39$b98036f0$2c80a4d0$@edu> <adamxr6ahd3.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adamxr6ahd3.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Bharath Ramesh <bramesh-PjAqaU27lzQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>> max_mr_size returned by calling ibv_devinfo is 0xffffffffffffffff. Does this mean the size is unlimited?
> It means that the query function might be returning bad data.  What adapter is it?

Yep, mlx4_ib_query_device does props->max_mr_size = ~0ull ... 

Jack, what would it take to fix that? I took a look and other settings are taken from 
dev->dev->caps.xxx where caps is of type mlx4_caps which is in turn filled @ drivers/net/mlx4/main.c 
:: mlx4_dev_cap I wasn't sure what field/computation would exactly account for later setting max_mr_size

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
