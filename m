From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC ABI 8/8] IB/core: Implement device_create with the new ABI
Date: Thu, 26 May 2016 09:00:42 +0300
Message-ID: <20160526060042.GS25500@leon.nu>
References: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
 <1464100526-31730-9-git-send-email-leonro@mellanox.com>
 <20160524220720.GF7950@obsidianresearch.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NAmHCRPXNp23hR9r"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160524220720.GF7950-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--NAmHCRPXNp23hR9r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 24, 2016 at 04:07:20PM -0600, Jason Gunthorpe wrote:
> On Tue, May 24, 2016 at 05:35:26PM +0300, Leon Romanovsky wrote:
>=20
> > +	ucontext->device =3D ib_dev;
> > +	INIT_LIST_HEAD(&ucontext->pd_list);
> > +	INIT_LIST_HEAD(&ucontext->mr_list);
> > +	INIT_LIST_HEAD(&ucontext->mw_list);
> > +	INIT_LIST_HEAD(&ucontext->cq_list);
> > +	INIT_LIST_HEAD(&ucontext->qp_list);
> > +	INIT_LIST_HEAD(&ucontext->srq_list);
> > +	INIT_LIST_HEAD(&ucontext->ah_list);
> > +	INIT_LIST_HEAD(&ucontext->xrcd_list);
> > +	INIT_LIST_HEAD(&ucontext->rule_list);
> [..]
>=20
> Please don't cut and paste like this.
>=20
> Considering your approach I'd suggest just go ahead and immediately
> implement a compat wrapper for each replaced write() style call.
>=20
> eg replace ib_uverbs_get_context with something that forms a
> new-style-command and calls the netlink version directly.
>=20

Thank you and Sean for reviewing it.

We will do our best to address all comments from this discussion in our
next RFC version.

--NAmHCRPXNp23hR9r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXRpEKAAoJEORje4g2clinRTwP/jgCr5qbtxc/PnRZyNWhUmOS
Zz7VRTMqjaJyjZyKn7vO0MzE9oY6kqAhDrRRMFbCtRTSIIKn0tbrlDibNBvCNGgb
Se97FSa8+o/fkSNC+deO0Yq0vvxauUg+DlqDkiuvL3ae46W13BZbSFRdah7Lqy+Z
5wR1GhgMbUzlz8O+15AFAi5Ozq/DiMRI5Jc41I2MUX4ftXxJnGlufipdydS7YOeQ
sBJgVeR3ap1U+hzKkBNqMn7/GYC/84bEUrgXJqroUgXsAysg+uozDWn/LiEh0XxT
YHPv+luRhSMewPeTJCiofgYoE+5o0sqsfYQHcy09t4ASMNcSVORj+t+bx/bIlItW
sAO2kSkCqecTrGi8I0+TxUVeaBSQ4TwiShskNkx1Y2Q9hc1iw/ByzTvsTNS6VIZV
pvd7xMb+S/hV8LNpqsLbo1NyA/h0QnYDyex1LIy/gf/7NWqUWAdLGJLiAHJWgoB7
hCkFDjHYTQLUqCsx/egVSotQyjjrmQeWxfDDEngbETJRSSkvSgxtf+hYP+q59PGc
qV1BsyOtVtbfz+AoLtApga30ysaOn6IZmJfwQge1ZT8pu/m7poMw9jcAigcm9/tq
6+vVs7ygmMpUaPQDFe4OMZZnerAf8543y5OabZ4nR+W/rI9o9fkq0zwDSgFImuld
iHRXhe6DSbrxoq8xxuxN
=qLLj
-----END PGP SIGNATURE-----

--NAmHCRPXNp23hR9r--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
