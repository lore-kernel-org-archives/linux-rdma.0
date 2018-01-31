From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-core v2 1/3] libbnxt_re: Fix lat test failure in event
 mode
Date: Wed, 31 Jan 2018 15:59:05 -0500
Message-ID: <1517432345.19117.38.camel@redhat.com>
References: <1517412531-25195-1-git-send-email-devesh.sharma@broadcom.com>
         <1517412531-25195-2-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-VZ17HwMkujMdAz1mBPyy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517412531-25195-2-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-VZ17HwMkujMdAz1mBPyy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-01-31 at 10:28 -0500, Devesh Sharma wrote:
> +       if (cq->deferred_arm) {
> +               bnxt_re_ring_cq_arm_db(cq, cq->deferred_arm_flags);
> +               cq->deferred_arm =3D false;
> +               cq->deferred_arm_flags =3D 0;

Minor nit: setting the flags to 0 each time serves no purpose as the
flags are always universally set whenever deferred_arm is set to true.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-VZ17HwMkujMdAz1mBPyy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpyLhkACgkQuCajMw5X
L9099A/7BTFclkD/vYjaUaBuNH9vm9/6wUwquAnqcErmm5KY1zoS1X0VWvW8TnnB
VMZmce64SIR8hQjY5+oCWFvv1zdazSDy9knnVmGeitZUowkZOcR6T+PJyfWUUylq
gxRC+1HGsP9KsktKXkR/A992MdeL9UbEKx3ADZ3ejvKkvhcSlAPZ8XHMBkscO7Dv
D4sltJPa7QDLVE5251A+VQKxQKff3JMxud8u/cHpXBZzhNN5eUBkgbh35YDKfZ5p
rq4HT39uF07MIb/s7G4YBAYHuN+5R0U4u1iZ5Jj5VMsuKvDjBbLzaUHqP6U4vcXN
Fq62jL1M9qc5GXCBu8Xiguup9qTjmjBRCMnrBmqA6/f3D0pWN2oCtU4uS7NTnlzq
6pMQSUT641JjfOaOS1O80aUr0GvipT2ozLCao1XwbalcA/U3jXXe6V+/3aeyzRAy
irTrPMPHgIDcmK+wONGj8nbtz+DH3QsVcfUnQPCLOh3bD/I1CUuO0TOYIrscyZqB
b2DXJ0JEdR6hfnniFIZRSzV08uo1fN6Is1PpAloXVptQcvs3gvXX7FnlDXeVniGp
OCfRbcVx9qF1tylJpZB+EqJfzU45w0pTFiDPriV3t7eekJKlyuQgYWD+r9sP2eSL
Xa6c2Ia50gGyRk+/3aAna7NGiIXc9/aNDM+hERk8eOKP9sEh9Ek=
=F3Rx
-----END PGP SIGNATURE-----

--=-VZ17HwMkujMdAz1mBPyy--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
