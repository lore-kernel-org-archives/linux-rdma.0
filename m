From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v2 16/17] IB/mlx4: Add spaces for better code readability
Date: Fri, 21 Apr 2017 12:28:02 -0700
Message-ID: <1492802882.30293.34.camel@perches.com>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
         <1492720654.3041.16.camel@redhat.com>
         <a56f9301-e116-c59c-681a-9108519920e5@users.sourceforge.net>
         <d7f1064f-a70e-83c4-bf45-0467ffba954f@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <d7f1064f-a70e-83c4-bf45-0467ffba954f@users.sourceforge.net>
Sender: kernel-janitors-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, trivial@kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-04-21 at 20:54 +0200, SF Markus Elfring wrote:

> Use space characters at some source code places according to
> the Linux coding style convention.

[]

> diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
[]
> @@ -2599,7 +2599,7 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_ud_wr *wr,
>  		u16 ether_type;
>  		u16 pcp = (be32_to_cpu(ah->av.ib.sl_tclass_flowlabel) >> 29) << 13;
>  
> -		ether_type = (!is_udp) ? ETH_P_IBOE:
> +		ether_type = (!is_udp) ? ETH_P_IBOE :
>  			(ip_version == 4 ? ETH_P_IP : ETH_P_IPV6);

Please refrain from tool generated mechanical changes.

Do try to make the code human readable and correct when
you are also making actual object code differences.

If this is to be modified at all then also please use
consistent ?: condition testing parentheses or perhaps
don't use parentheses at all.

Maybe even align the ETH_P_ uses like:

		ether_type = !is_udp		? ETH_P_IBOE :
			     ip_version == 4	? ETH_P_IP :
						  ETH_P_IPV6;

