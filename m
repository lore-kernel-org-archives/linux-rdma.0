From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] infiniband: add checks for the status of nla_put
Date: Wed, 26 Dec 2018 21:49:44 +0200
Message-ID: <20181226194944.GI10329@mtr-leonro.mtl.com>
References: <20181226021141.71538-1-kjlu@umn.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KdquIMZPjGJQvRdI"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181226021141.71538-1-kjlu@umn.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Kangjie Lu <kjlu@umn.edu>
Cc: pakki001@umn.edu, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Parav Pandit <parav@mellanox.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, Artemy Kovalyov <artemyko@mellanox.com>, Alex Estrin <alex.estrin@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--KdquIMZPjGJQvRdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 25, 2018 at 08:11:39PM -0600, Kangjie Lu wrote:
> The fix inserts multiple checks for nla_put, and issues warnings if it
> fails.
>
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---

I didn't look very close, but it strange that failure in nla_put()
doesn't follow by canceling of netlink message.

Plus extensive usage of pr_warn() is not needed here.

Thanks



>  drivers/infiniband/core/sa_query.c | 39 ++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
> index be5ba5e15496..0e5d7a6dde36 100644
> --- a/drivers/infiniband/core/sa_query.c
> +++ b/drivers/infiniband/core/sa_query.c
> @@ -775,28 +775,37 @@ static void ib_nl_set_path_rec_attrs(struct sk_buff *skb,
>  	/* Now build the attributes */
>  	if (comp_mask & IB_SA_PATH_REC_SERVICE_ID) {
>  		val64 = be64_to_cpu(sa_rec->service_id);
> -		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_SERVICE_ID,
> -			sizeof(val64), &val64);
> +		if (nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_SERVICE_ID,
> +			sizeof(val64), &val64))
> +			pr_warn("nla_put failed\n");
> +	}
> +	if (comp_mask & IB_SA_PATH_REC_DGID) {
> +		if (nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_DGID,
> +			sizeof(sa_rec->dgid), &sa_rec->dgid))
> +			pr_warn("nla_put failed\n");
> +	}
> +	if (comp_mask & IB_SA_PATH_REC_SGID) {
> +		if (nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_SGID,
> +			sizeof(sa_rec->sgid), &sa_rec->sgid))
> +			pr_warn("nla_put failed\n");
> +	}
> +	if (comp_mask & IB_SA_PATH_REC_TRAFFIC_CLASS) {
> +		if (nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_TCLASS,
> +			sizeof(sa_rec->traffic_class), &sa_rec->traffic_class))
> +			pr_warn("nla_put failed\n");
>  	}
> -	if (comp_mask & IB_SA_PATH_REC_DGID)
> -		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_DGID,
> -			sizeof(sa_rec->dgid), &sa_rec->dgid);
> -	if (comp_mask & IB_SA_PATH_REC_SGID)
> -		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_SGID,
> -			sizeof(sa_rec->sgid), &sa_rec->sgid);
> -	if (comp_mask & IB_SA_PATH_REC_TRAFFIC_CLASS)
> -		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_TCLASS,
> -			sizeof(sa_rec->traffic_class), &sa_rec->traffic_class);
>
>  	if (comp_mask & IB_SA_PATH_REC_PKEY) {
>  		val16 = be16_to_cpu(sa_rec->pkey);
> -		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_PKEY,
> -			sizeof(val16), &val16);
> +		if (nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_PKEY,
> +			sizeof(val16), &val16))
> +			pr_warn("nla_put failed\n");
>  	}
>  	if (comp_mask & IB_SA_PATH_REC_QOS_CLASS) {
>  		val16 = be16_to_cpu(sa_rec->qos_class);
> -		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_QOS_CLASS,
> -			sizeof(val16), &val16);
> +		if (nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_QOS_CLASS,
> +			sizeof(val16), &val16))
> +			pr_warn("nla_put failed\n");
>  	}
>  }
>
> --
> 2.17.2 (Apple Git-113)
>

--KdquIMZPjGJQvRdI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcI9tXAAoJEORje4g2clinJG0QALp3DTEw0ouwT2G6r5s1ReMh
1naoBDXwbmqqfNvBbPatEYjZc0t/9pigxjtQAeuQhYqtBXWz+sPOkCkq+vuxIPA0
uRQgeoRVdRGT7opN5A/I4y6tANZkLDq4kuFIdAQ/1uqtcTDOqevRvNTrc3YLiZXU
TQrHn1qqrDwnnn2I8aFpHkhDpdytFQPY9dp4G1yxyJ89Be917s6JvF6NBaZgZOGE
U5tcOpwbcfbDI8rIg9VH7NJQnTViq9cvne6dMZEJhtlQBZrI06snOvnag/DrvhcD
acJR/S2bBCSK5QP6SvAoq6Bg1O+OWyqPENQwSrZAB9Di0/v66Z5iYWa21yuUXbww
P2/qd5xNnLO+q0wXDhpbx+DKdc9nWqzNWlETxvL8uA/LweTyVXJnQLxuKxsrjYjT
QDYjU79ZggDXHHUUsxgb8h/jydQB9uqUV1F1f/b1SuYb+LGpOiFr/2nJ1A7wcLtW
wQnjfNQ88IzA2Z30AnN8gN+pAhsxVlInhoii5yE/cFbOlGLq+aFoBl+JlS1YqsL2
30sYBX6atTcc9Y6fY4slKirBxmON5Rx8iK+LGG5QOm8NQvr1bfg5uUDypqjseDRH
svlB+iSXf6WOEAMalUlJfx6Yu+KtonFWBHKPmDPywYodFrzpIBBfSY389615rxl1
qFjo6xZD1Gz2a2NJs5Qi
=r9E5
-----END PGP SIGNATURE-----

--KdquIMZPjGJQvRdI--
