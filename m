From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 for-4.14-rc] RDMA/core: Correct nlmsg_len after
 appending attributes
Date: Fri, 29 Sep 2017 17:41:17 +0300
Message-ID: <20170929144117.GA2965@mtr-leonro.local>
References: <20170929132501.15440-1-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170929132501.15440-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 29, 2017 at 08:25:01AM -0500, Shiraz Saleem wrote:
> Commit 1a1c116f3dcf removes nlmsg_len calculation in
> ibnl_put_attr causing netlink messages to be rejected due
> to incorrect length.
>
> Add nlmsg_end after all attributes are appended to calculate
> the nlmsg_len.
>
> Fixes: 1a1c116f3dcf ("RDMA/netlink: Simplify the put_msg and put_attr")
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Except the fact that title is a little bit misleading and better to be
"IB/iwpm: Properly mark end of netlink messages".

Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

And while you are there, can you please fix manual usage of NLMSG_DONE?

The need to call manually to send_nlmsg_done() indicates wrongly
implemented calculations of netlink size and improper handling of
multi messages.

In properly handled netlink code, the NLMSG_DONE is sent automatically.

Thanks

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnOW40ACgkQ5GN7iDZy
WKe3CQ/+MsQPfrbifAgDTQxlLgw8pikgDOVuOMMTKQZ2FFFSmTliCTvH6I10ioCp
cnrDZPdDbeLPapWofY3shHPWp15L+buiL0ymSxAYLFiUDU9R6ZbPUjzA6YhgC6/e
t0jEZHjDv3hwLl0vdJeZj7MITN4fOdEZUKXgT1AiPnuJDR57VMGk/H2JcoqeQbNe
53rjK+ZsudbmIE7sY75gC1YCW9lk3r4rWlJ7mjOKjuzHB8p1jdIFWhrN6CQJ1y6J
Faj3yqocbqhGIZpjAGogGS1LBAwMadluqKZc8OLPkMGiqVrpV9P/xCkQCE5ikHcJ
p1TTV0xR9oRX9wFovhm5Ztfq2DIXPRDJd92qaUL3FwRczZoh/1nFpmhEvoFchuRM
jNB2ic8o7aq9YSoHjuvEwxNEdOEssf3byseA/gtLfG3p2sZZn9CGE/+rUgYlyJtr
6c6mSC51tFZgZ/7EafWA3FtyGvWBquTsG/ZbYclrUE7+g9hzpnK2k7NFt3KPpKMn
2UIucNU+c9buzXlu1Mh8SwUbyyS3wB5lmkUSpzfATz4JFw8/a9kuwzE1+P4GDQrX
7ByVCECdeohAAc5vKIs0dFZ+1reHoB9q4LSFOIzyt7Z3N2N/Is4MgmqlY+/zQgY0
KLU21IdAOM8U+ZJS+9TQ1pRt7wDmqgjmkkTHnyiWicRC5ueRpXs=
=UExY
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
