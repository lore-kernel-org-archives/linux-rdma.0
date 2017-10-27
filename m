From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Use common error handling code in
 __mlx4_ib_create_flow()
Date: Fri, 27 Oct 2017 22:44:57 +0300
Message-ID: <20171027194457.GK16127@mtr-leonro.local>
References: <0bcea3cf-91e3-01d5-8d80-34cd6b611fb1@users.sourceforge.net>
 <70843f43-03c5-8295-643a-4f228ff2e907@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iamKNtDj9HjMhSdE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <70843f43-03c5-8295-643a-4f228ff2e907-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--iamKNtDj9HjMhSdE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 26, 2017 at 08:33:39PM -0400, Dennis Dalessandro wrote:
> On 10/26/2017 12:12 PM, SF Markus Elfring wrote:
> > From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> > Date: Thu, 26 Oct 2017 17:54:15 +0200
> >
> > Add a jump target so that a bit of exception handling can be better reused
> > at the end of this function.
>
> I'm not sure this is that big of a win. I mean you aren't really making the
> code any smaller and it's not making it any easier to read really.
>
> > This issue was detected by using the Coccinelle software.
>
> Assuming there was no testing done for this?
>
> > Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
> > ---
> >   drivers/infiniband/hw/mlx4/main.c | 10 +++++-----
> >   1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
> > index c636842c5be0..4a598c48ea1c 100644
> > --- a/drivers/infiniband/hw/mlx4/main.c
> > +++ b/drivers/infiniband/hw/mlx4/main.c
> > @@ -1691,8 +1691,8 @@ static int __mlx4_ib_create_flow(struct ib_qp *qp, struct ib_flow_attr *flow_att
> >   				mdev, qp, default_table + default_flow,
> >   				mailbox->buf + size);
> >   		if (ret < 0) {
> > -			mlx4_free_cmd_mailbox(mdev->dev, mailbox);
> > -			return -EINVAL;
> > +			ret = -EINVAL;
> > +			goto free_mailbox;
>
> This might be a good opportunity to bubble up the return value rather than
> just blindly returning -EINVAL. That's really a question for Mellanox
> though.

It is worth to check it, especially for parse_flow_attr() which can
return -ENOTSUPP (need to fix return -EOPNOTSUPP).

Thanks


>
> -Denny

--iamKNtDj9HjMhSdE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnzjLkACgkQ5GN7iDZy
WKeUXg//dNA7qSUj31zAkc4Km53Yo1veCbyfVB2KcP1cxwgRqAcIKewY0qZXhhHK
ht28rbGUWIvCxt/LHU0D2vuEIJ7gaeZ7A4yXuQwr26CcmNXyU719XTlLqLqCFREf
6P1TU9I7SoIMITi2dv/kpQjdTxHN5RR8ROlOuoak6s0NPTka+GST0KIEi7wcXEFQ
QlWP088Hlnx6JrjR799j1+UlZPZFhUPDLzMlomAZRxiyPk2ydwZKBBnVUFExDKRu
XJWwvT8vqds/uHnPAz+Cihxg2W5tW3LuCq8Q5vRFpTkeXTpOMW/hgpPf6yvYLT9L
vwKH8tf11zjRIzir+cfwO0onEqgcR7W7fEE0rOGu2ENLkm5PF8SzjF+gSEh80iUa
ZPp9/L5De+Zn6noh2YiEQWFePwb0v+WnM3XKKRF9lyFPTMs2UauDAKDfqApO+9Lt
j3LPgwjt0iZ4SJOzBex4+kd0fpyTJ91XNMobSieDL3qbP3QiFj8sUQjXCYxdbyxb
7EVx+kUTrpkOClYJePLFKHchxiuOpi2Z6xxW8N0RF42zSoQDiMTGrdv2T+ni9jPu
EwWhSSHtGJnYyHQNFEwAq1j21eFd2CnjQfEwLHwnd/p3HH3Hn+DMoSrVWIY+VVsE
gNt1lLOjYUCL7HlNXVHFMekOEDHabH/RR+WaQJoomhnZvLf1rkI=
=FiuH
-----END PGP SIGNATURE-----

--iamKNtDj9HjMhSdE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
