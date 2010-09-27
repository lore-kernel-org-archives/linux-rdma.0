From: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: Re: Maximum size for memory registration (ibv_reg_mr)
Date: Mon, 27 Sep 2010 13:18:26 +0200
Message-ID: <4CA07D82.7000207@mellanox.co.il>
References: <036401cb5c35$85829220$9087b660$@edu>
	<adar5giahvd.fsf@cisco.com> <037101cb5c39$b98036f0$2c80a4d0$@edu>
	<adamxr6ahd3.fsf@cisco.com> <037e01cb5c3b$2ca02630$85e07290$@edu>
	<adaiq1uagwi.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaiq1uagwi.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Bharath Ramesh <bramesh-PjAqaU27lzQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/25/2010 12:57 AM, Roland Dreier wrote:
> All Mellanox adapters have some limit on the amount of memory they can
> register.  You can mess around with module parameters to adjust it.
>
>    
You can use mlx4_core module parameter (log_mtts_per_seg) to enlarge 
number of MTTs per segment.
This enable to register more memory with the same number of segments.
In OFED 1.5.2 the max value was enlarged to 7

Tziporet


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
