From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 09/20] IB/hns: Optimize code of aeq and ceq
 interrupt handle and fix the bug of qpn
Date: Mon, 12 Sep 2016 15:32:55 +0300
Message-ID: <20160912123255.GG8812@leon.nu>
References: <1473417051-99560-1-git-send-email-salil.mehta@huawei.com>
 <1473417051-99560-10-git-send-email-salil.mehta@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="RDS4xtyBfx+7DiaI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1473417051-99560-10-git-send-email-salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--RDS4xtyBfx+7DiaI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 09, 2016 at 06:30:40PM +0800, Salil Mehta wrote:

....

> +			     HNS_ROCE_AEQE_EVENT_QP_EVENT_QP_QPN_M,
> +			     HNS_ROCE_AEQE_EVENT_QP_EVENT_QP_QPN_S);
> +	phy_port = roce_get_field(aeqe->event.qp_event.qp,
> +			HNS_ROCE_AEQE_EVENT_QP_EVENT_PORT_NUM_M,
> +			HNS_ROCE_AEQE_EVENT_QP_EVENT_PORT_NUM_S);
> +	if (qpn <= 1)
> +		qpn = HNS_ROCE_MAX_PORTS * qpn + phy_port;
> +
> +	switch (event_type) {
> +	case HNS_ROCE_EVENT_TYPE_INV_REQ_LOCAL_WQ_ERROR:
> +		dev_warn(dev, "Invalid Req Local Work Queue Error.\n");
> +		dev_warn(dev, "QP %d, phy_port %d.\n", qpn, phy_port);

dev_warn like all other printk flavours supports multi-line messages.

> +		break;

--RDS4xtyBfx+7DiaI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX1qB3AAoJEORje4g2clinUdYP/iXIX6vHN0h+EIWmQQhTObUs
f0PTI4klgjEPJ6AMU4MAPmbHZs3JCmlbYpi9gKTMwQ9vxkZwM6gJlMwQgnmzdXrn
RsUze4NJpbqcAxhwRsXCB9rAWE0Zs8xiLNUICXqB9fOxgocqfPnLmZ44dFvaJQVp
sKEjfdWoDzz/gtUKyTkNSTR750MTWnAIHSvnzhHMkKRPVAlf+/hPi3vcBiwvysDE
MItIKzwqA2aU8USP0Fjv3Cjz9HjXruwsXB0eq0cUcgMSn4144LqBM05o0zYUjvWj
HRGmYdfcMP+SbaVA1wp8chwvXcf5fcbYn82S+usPOBvcEC+SqLoo4vXlZnen4eDD
VewJYMG9YjejyJq88xl0jJdLzNMuZLzpFTS5eUFv4AJl1lEGxpd5DQAqXxygLn6H
9TFeSDsDd11eL5PooFOK25JFqOaB6rh+2050Yp3wYXtWWqVFSiSCYK9AULNSEg90
oIDwGLz4/5hpMVQW72oEPJF+NQqOu5qe4vf/8Pjc6sjd3XrgjgeuSjwb15I9qb45
ShMNY/Z1yWeNbgYaKOL6HnQRTTKNqSw3tfQmz0pIdUVnMbkfuWZ7S3QR6t8O0vht
BGTSxQ5WAY6ZFXC+2H/4synzvfZR3rLTGULMJSDYT8msE9L69B8gALj4MUkEMvfv
RHCbD2jcBT29Oj9VY+gE
=acqV
-----END PGP SIGNATURE-----

--RDS4xtyBfx+7DiaI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
