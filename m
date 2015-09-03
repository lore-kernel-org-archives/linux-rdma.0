From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/ipoib: Suppress warning for send only join
 failures
Date: Thu, 3 Sep 2015 17:20:47 -0400
Message-ID: <55E8B9AF.10605@redhat.com>
References: <1440200053-18890-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1440200053-18890-2-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GNiWxOouOWNg28rcAflpFpIp5rwCBHhWr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440200053-18890-2-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GNiWxOouOWNg28rcAflpFpIp5rwCBHhWr
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/21/2015 07:34 PM, Jason Gunthorpe wrote:
> We expect send only joins to fail, it just means there are no listeners=

> for the group. The correct thing to do is silently drop the packet
> at source.
>=20
> Eg avahi will full join 224.0.0.251 which causes a send only IGMP packe=
t
> to 224.0.0.22, and then a warning level kmessage like this:
>=20
>  ib0: sendonly multicast join failed for ff12:401b:ffff:0000:0000:0000:=
0000:0016, status -22
>=20
> If there is no IP router listening to IGMP.
>=20
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--GNiWxOouOWNg28rcAflpFpIp5rwCBHhWr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6LmvAAoJELgmozMOVy/dJoAP/19Zx58SS/a5ZOh5Z1DXQwLI
q8WJSGJflJKFKYvUby6LksAc6Y9Q7YANsAMdYxcgy6etb2a0zP2M82A6zOLeGUKy
rnMD7JqOK4AgXuSmHz1BZ3oh2DcD8yg5TL82VS0tLr8WYWxHq4+ehhhQaRFBX6cd
qRHMrleNMXZBZDBKWBOt7uWoTNfxCeYKiyeksYdtBB1hY8EVaBtslTp75nb/ogHy
3/S80ob6TF8xiHZ+4wA8ERiJlAUez8uIFtpzgeiS/j0IxKUCtEIfbeVKRwP3nejM
22DU4ILOudG0pybGQ6mLJre+K0nMHlz4UQ2OETLZpjKImBlWvE3xTb9XTA+I/LtL
2GeMYzKRc8jxMEq75NYgcNWxoZodt81C1ydgde9xHxDYLDYvfIBhDWUmQp3ryaEn
VgHR/ZYrj/oy0BhEMVDJYa7ODIR6uVzOe1H7lp+RNnoVoBUkSRqoRXOyOQYU6KF6
lntj7GlcpStcHwu9ePF3xN1FaNvDZCTOfyxLeAyabxvLd9WUPUnB+Xwx+WUSnELu
Lt6ecodR1sJtgG5nP+P6QJOjHK2odjivv+01acZq5V2Fat6iD5KtIgEJTv/PdIAb
2B3hmdRoJCERXK59f4RflmLRQmxAQv10Y8UCvY2OVue7jyIzmbPtCufnLzWWkeud
H/bHj+scdP1sx25Naypx
=gMdd
-----END PGP SIGNATURE-----

--GNiWxOouOWNg28rcAflpFpIp5rwCBHhWr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
