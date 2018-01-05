From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma for-next] bnxt_re: report RoCE device support at info
 level
Date: Fri, 05 Jan 2018 14:34:49 -0500
Message-ID: <1515180889.3403.35.camel@redhat.com>
References: <ac1582130cbb59814d113ec5a3d1f3805c7e3d7e.1515099853.git.jtoppins@redhat.com>
         <CANjDDBho+uSNdzB3xg0v81fnEF-dbtMikWmftRRC9XyoUdjipw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-n8a4yY7Wbn5j7L3R0udi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANjDDBho+uSNdzB3xg0v81fnEF-dbtMikWmftRRC9XyoUdjipw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-n8a4yY7Wbn5j7L3R0udi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2018-01-05 at 15:22 +0530, Devesh Sharma wrote:
> Acked-By: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>=20
> On Fri, Jan 5, 2018 at 2:34 AM, Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> > Reporting that a device doesn't support RoCE seems like a valuable piec=
e
> > of information to have when trying to determine why a driver is not bin=
ding
> > to a device. Better to report this at info log level instead of requiri=
ng
> > a user to enable all debug messages in the driver.
> >=20
> > Signed-off-by: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-n8a4yY7Wbn5j7L3R0udi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpP01kACgkQuCajMw5X
L92ohg/+No15qx3lIxacudFGLXx/UgAuysFe0vqYULY5A7MlOCMX7qdFj2/gkS5Y
AJBkWBqhVAZAMYjB+7iaIGpnWPNKfGXQxUJ94d/BnRjNe0Wco7BQGcjWFsikvrv1
tNyJTFLADhDYqYmlmBweWwSH00Bjwcg7aBWvUJcTTByLTzYE543IdrohIWvdxh2x
ntoLZgWpgRZezHnvjHYTdn/Pce0vLzXCahi0sPZoe1Fny4nmo5dowjKN2CfSelXH
E6md3YB+NcBZnPJtwvc4UbRMGKtQt+4UEDB0X9I5xpShdtdw1DgooUtx8HYblJjz
wjYa4w4bfbFTPlQ6zSdhhP1lT83U5HfNG1CAhBXyasBsOglcUkILjZQDn0n3UV0l
VftB2PD5mBbqfH+FYgCP7WjO9einZuPpaAiOk6d6omUXQW1Fel0HZyiOpK0Z4+re
lrXwBg+ORBv1eIztWA6SzBjn2Cs5BxZMQyzmXPbOdHG4rCiyh17m6qA1nzthQaLW
gDT3O6vDiyLfvfC5AQCRWbttHBr1Kkp7a4Ffn7wLd/A1zA9ZgCLr9kMbl3SCRwtw
mr3If5ql8gmGx4lbiG0GmYGf/gBFobl+jVBuCyagmsONfWaDXucPMgA5+FT29e7a
7t5QzVOGvlfDPPGRAuBJUrFwLVGe+bKIioV0h8YmtVzU8Kp3NwE=
=VKkz
-----END PGP SIGNATURE-----

--=-n8a4yY7Wbn5j7L3R0udi--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
