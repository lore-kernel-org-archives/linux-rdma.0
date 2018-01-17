From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 00/14] IB/srpt: Add RDMA/CM support
Date: Wed, 17 Jan 2018 18:33:06 -0500
Message-ID: <1516231986.3403.296.camel@redhat.com>
References: <20180117001418.7852-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Xh3XC/g+Ff8hSS8KJDTd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180117001418.7852-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-Xh3XC/g+Ff8hSS8KJDTd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-01-16 at 16:14 -0800, Bart Van Assche wrote:
> Hello Jason and Doug,
>=20
> This patch series not only adds RDMA/CM support to the SRP target driver =
but
> also fixes a number of race conditions in that driver.
>=20
> The RDMA/CM listener port number has to be specified as an ib_srpt kernel
> module parameter. The default value for that parameter is zero which mean=
s
> that RDMA/CM support is disabled.
>=20
> Note: since this patch series uses the srp_login_req_rdma structure that =
was
> introduced by the IB/srp RDMA/CM patch series, this series depends on the
> IB/srp RDMA/CM patch series.
>=20
> This patch series, just like v4 of the IB/srp RDMA/CM patch series, passe=
s
> Laurence Oberman's tests.
>=20
> Please consider this patch series for inclusion in the upstream kernel.
>=20
> Thanks,
>=20
> Bart.
>=20
> Changes compared to v1:
> - Added patch "Fix a race condition related to wait list processing".
> - Fixed the size of the character arrays used to store the initiator port=
 ID
>   and session name. This fixes a login failure that was reported by Laure=
nce
>   Oberman.

Overall, this series looks mostly good.  I'm still wondering if the
configuration details need more work.  In particular, it seems the host
is lacking in the fundamental controls needed for implemented server
side ACLs in regards to RDMA_CM connections.  The current code assumes
it is safe to listen on the wildcard address on the target port, and I
don't think that's a safe assumption.  We might use different
vlans/pkeys to segment off different namespaces, and in that case we
would want to listen only on the vlans/pkeys that correspond to allowed
namespace clients.  So I think that needs correcting.  The first 11
patches of this series seem standalone and can go in now at this point.=20
Would you agree?  If so, I'll pull those in while we discuss the
configuration stuff.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-Xh3XC/g+Ff8hSS8KJDTd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpf3TIACgkQuCajMw5X
L92F/Q//WEYqeD35dtqV1MqDrve59Y1tI2mUkE/jyrVi77VhaTPEaOXRjTRFsvqi
vtChHw5I0GfLsMusTrFmXbwkICKcfFlwlcpsSTru3TUTQNvpOukS5ks8O4/7y2G6
rKQiROotvkS5ttw/Mv+LHad2ezKAkJpad1sNWeoYYWqdYo9pXj+IHf0LLdwKkb95
azmnqy+3ik0hHZkLdmbZB1gV8diYsiCIvCaWHj8VPO9SezA0DBUMk8NVD/YgWOne
3Lk0wXoOOufSNmg/1D7T/rrM9spDKk3d5q+lunUFOcZeard3L6dwjhhE8V4eFNet
ZxJQcq09mCdFn9fyKjlsOQg3W+E0qKy2OrMbCb3IfWzY/lyhMqYKSP9e5jExl+zu
EhcB21nna8cOEfAUj/n7iapqCayiCIrTEyqk+/MVbpThRSop0DiXJRnmGOUFCKcS
EN5248LdKLwjARbYBwrM+MUyUcORTEMaIbErS7Dwggxot04tnfZisFv4qF5KE+kg
dEOuNqWB8VGc+UUfh4mCT7rTQpxeMfA1Ud6vGqcc9t/GLbTC8irUmVsaPVwZ+EBu
dQiMiG9So7zrU0+TlQvpd7ZhuwmjzrC3kqG9rg57dxbPlk5nEqt1+HAuHe5JyZl6
JwbxChSkhybNkfPSpqhZ3lMFA9R5h62FcZMWLZDeFAWbLsvzR/k=
=4gHi
-----END PGP SIGNATURE-----

--=-Xh3XC/g+Ff8hSS8KJDTd--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
