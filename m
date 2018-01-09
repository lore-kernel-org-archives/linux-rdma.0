From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 2/6] RDMA/hns: Add gsi qp support for modifying
 qp in hip08
Date: Tue, 09 Jan 2018 10:12:58 -0500
Message-ID: <1515510778.3403.140.camel@redhat.com>
References: <1515039563-73084-1-git-send-email-oulijun@huawei.com>
         <1515039563-73084-3-git-send-email-oulijun@huawei.com>
         <1515446459.3403.94.camel@redhat.com>
         <66c69e6b-8f74-be2e-1404-3e0c8c4a4024@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-uLprEOX4lrXGC2CWK5sy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <66c69e6b-8f74-be2e-1404-3e0c8c4a4024-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, jgg-uk2M96/98Pc@public.gmane.org
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-uLprEOX4lrXGC2CWK5sy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-01-09 at 09:04 +0800, oulijun wrote:
> =E5=9C=A8 2018/1/9 5:20, Doug Ledford =E5=86=99=E9=81=93:
> > On Thu, 2018-01-04 at 12:19 +0800, Lijun Ou wrote:
> > > @@ -2342,7 +2366,7 @@ static void modify_qp_init_to_init(struct ib_qp=
 *ibqp,
> > >                        V2_QPC_BYTE_80_RX_CQN_S, 0);
> > > =20
> > >         roce_set_field(context->byte_252_err_txcqn, V2_QPC_BYTE_252_T=
X_CQN_M,
> > > -                      V2_QPC_BYTE_252_TX_CQN_S, to_hr_cq(ibqp->recv_=
cq)->cqn);
> > > +                      V2_QPC_BYTE_252_TX_CQN_S, to_hr_cq(ibqp->send_=
cq)->cqn);
> >=20
> > This looks like a bugfix unrelated to the rest of the patch.
> >=20
>=20
> Sure, This is found for debugging CM and The other modification of qp con=
text in
> this patch is unified for CM. As a result, I put it into the patch-set of=
 CM.
>=20
> Do I need to send PATCHv2?

That depends.  What's the effect of this bug?  Is it something that
should be sent to stable?  If the common case is that the send and recv
cq sizes are the same, and this bug is mostly never an issue, then no,
no v2 is necessary.  If this is something we should send to stable, then
yes, pull out the bugfix, tag it for stable, and submit v2.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-uLprEOX4lrXGC2CWK5sy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpU2/oACgkQuCajMw5X
L92QNRAAlnAQ84hlM9iy729zqKRyjfMrywgNXdqcDnTOqkGz8IcbdET00T9c9GvD
QdGfOWnro+HaGfxmybo21LW/8uU9QctdWrBguaaHnnXO5hcL6DJL4GUGhwLwKwJY
yBFMUbdI+NeAWPpxmsr5RCPcEVQeNeKCi4Ab7JeAhkeY9inhSlHmI+0r9q6R0ScH
inz5kwomAC2tL9cGrjvKl96QpSAs2+YxOGfgbMsq66kda1JiUGXHvIav2LqeWEVV
q0/f4FzOgkLlEiCpr/z92f7Ki0UL7yJY70dRietpakXPBo1v/G+98ilItprATpdZ
6hXbwQxCJuy2ue3QgtAUu6sTwTohpRvSWe591ETjto3s9M+v9igBYtyx3OF4TTGV
iQ+vfcJ0msF+a04ZLgRj6qsKfcLJ9OCV/lhDHKx4oARSHaYheZm5WswHHp/b6Mp8
tIHT7bWBHzpYbiJfC6UaGRoVq9Mn6ZjKrNREJzCK06JNvCp1e/3EzcG7T7Vtvu4q
uAM/H/GGX7sIw2/PLcofD44PhYzmWY2CHgLM3OT9AUsujR+Sbfqhy+y3aTg690/W
mavm5lV2ERx2a1s35HYaRq7G+35Ku7ArAdV4s4mLRk1HMPVD4JV2IIaZTkj9qiiD
xXximiFcQop4nyLW1apS5BtY6bm0D5yKbwBZyEu8ewd39lu9GSw=
=hiwo
-----END PGP SIGNATURE-----

--=-uLprEOX4lrXGC2CWK5sy--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
