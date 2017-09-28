From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-4.14-rc] RDMA/netlink: Restore nlmsg_len calculation
 in ibnl_put_attr
Date: Thu, 28 Sep 2017 16:24:57 +0300
Message-ID: <20170928132457.GW2297@mtr-leonro.local>
References: <20170928114953.9600-1-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Chn8nxio6L/4biUD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170928114953.9600-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Chn8nxio6L/4biUD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 28, 2017 at 06:49:53AM -0500, Shiraz Saleem wrote:
> Commit 1a1c116f3dcf removes nlmsg_len calculation in
> ibnl_put_attr causing netlink messages to be rejected due
> to incorrect length.
>
> Restore the netlink message header length calculation
> to include the added attribute.
>
> Fixes: 1a1c116f3dcf ("RDMA/netlink: Simplify the put_msg and put_attr")
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/core/netlink.c | 4 ++++
>  1 file changed, 4 insertions(+)
>

The length supposed to be updated in ibnl_put_msg, where you should
supply correct length from the beginning. The suggested way to supply
length for unknown data is to provide NLMSG_DEFAULT_SIZE while allocating
new netlink message.

NLMSG_DEFAULT_SIZE ensures that netlink fits into one page.

It is better to avoid messing with message length after allocations,
especially for the attributes.

Thanks

> diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
> index e685148..889d091 100644
> --- a/drivers/infiniband/core/netlink.c
> +++ b/drivers/infiniband/core/netlink.c
> @@ -150,10 +150,14 @@ EXPORT_SYMBOL(ibnl_put_msg);
>  int ibnl_put_attr(struct sk_buff *skb, struct nlmsghdr *nlh,
>  		  int len, void *data, int type)
>  {
> +	unsigned char *prev_tail;
> +
> +	prev_tail = skb_tail_pointer(skb);
>  	if (nla_put(skb, type, len, data)) {
>  		nlmsg_cancel(skb, nlh);
>  		return -EMSGSIZE;
>  	}
> +	nlh->nlmsg_len += skb_tail_pointer(skb) - prev_tail;
>  	return 0;
>  }
>  EXPORT_SYMBOL(ibnl_put_attr);
> --
> 2.8.3
>

--Chn8nxio6L/4biUD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnM+CkACgkQ5GN7iDZy
WKfc0Q//SkhqvQAfMzRgBIhmnw4XgDTBUTm2Oc3+FNoRv6uqXW6Ujb+CTODZ5E+w
0fzv3JnGrm37tQ7Ct0Sepnk+Q52VwIkhWfDGyAic7J3/1b6oXX6k4aYLU+Mr1jsE
e+Mgp/nAu9I9D+nZZtglLLp9MmkgLAg4jtbxaktFX4tVqLJrlmmKtw6Ox38lE3bu
vWEZDUm4ZXwYt5iKRaPlTPAYQP3FF3AEGp0LwNr7b3Iiep2lE5uTFWrKH6S1sbtD
2QLtOUfwnSVWeRH74Bs4bCj5PJUspuoob5VtryCrGw+dGRThXpz59u8wRi0wtld7
kMDXygd6Ju80OiRirhfrw91MJB0aYphVx7HsiWQOPB4pfsISfZZEyD/C6WRP+EEg
xAeJ29zpUQ8Olz2Ov45CkYuQBQzHFEQlwBVKjyFBhUhY3tve61IMjaT6A+6SZE+3
aqk3nH8YbKt6aniz5LVOA3l43zgfgTOZoWFYF+7qfPBqwbN+k2E+OSkTeGpVbfwA
SmaipT/51vY3yU01DguvSt6lfi5yPpHwZcZWJ0SA+nd/+UiKNtHPGZtqrsfWxPeK
cPmXjWVrLjL6C8lbPioC/G6bibr4h0rNVJAat1GnyZRbvPc+rK0e/oN8EL56EkE0
bOD7HFiJC+2Zrph2KLoRRiq7BrIic64ZlCDmx+XWNQ5qn72iPE8=
=yRlV
-----END PGP SIGNATURE-----

--Chn8nxio6L/4biUD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
