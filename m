From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Wed, 9 Sep 2015 12:06:02 -0400
Message-ID: <55F058EA.90108@redhat.com>
References: <1441729478-19375-1-git-send-email-dledford@redhat.com>
 <CA+55aFzi+hhHuNcHjne_yYO+Dt4Gdkzs-U5y3fAJ8BDYWw4y=Q@mail.gmail.com>
 <CA+55aFyeLEab0qjNV1+V-mX2ZhExs1z5VtdusgpDnMeNBg-d6Q@mail.gmail.com>
 <55EFA2BF.7060006@redhat.com>
 <CA+55aFwg+QCM=xaoK4ic+4AymqCYrF4Ny8WO9iY2hHFBLNT3VQ@mail.gmail.com>
 <55F02006.5020504@redhat.com>
 <CA+55aFxJovuBGpg04YM0AvrzL_TPDoHebkP21R7tO3=QMQUUXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HmJrV61jcUDJBSmtS3k3LNaQPOgT8Bj9r"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFxJovuBGpg04YM0AvrzL_TPDoHebkP21R7tO3=QMQUUXQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HmJrV61jcUDJBSmtS3k3LNaQPOgT8Bj9r
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 09/09/2015 11:44 AM, Linus Torvalds wrote:
> Yes, I see them, thanks for the links.
>=20
> It would have helped if the commit logs had had a record of this
> somehow (ie a "Cc: netdev" etc so that I could tell during the merge
> that this was actually something the networking people knew about).

I'll make sure I include that in the future.

> That would have avoided a lot of my angst. Sorry,

No worries.  And since I didn't spell it out in the commit logs, I
coordinated with Greg K-H on the staging changes and with Anna Schumaker
on the NFS client changes too.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--HmJrV61jcUDJBSmtS3k3LNaQPOgT8Bj9r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV8FjqAAoJELgmozMOVy/dzR8P/Aj/qvNnOWnfcHnIMKNVSkfc
Qyr6mW127b1/+hxJ2w5Sv6ByPism3RqL0Nxv/xKrqev/Tr9WsgZyetPGNtC/aoCv
r+9KqWbwWspl642u1zOJ+iMzp+HIeo/6NH9gWH3ITACj/vYukYzhkm3CbRGSwa71
aKnItKJ0J7RxkEjKsf71gPCWGKU1/DjCtVKZSiOKUdoOfY4+26lf3en/pxYlam0j
/WHS34aRJcyzpIvqExMyyTxS3Z+KVTJWqcGHJNAbhQ5yZnsThoH3PnCf5/tC3Vxc
5lJ1UxWUOHYqFJJ/vOJ9s/O+xPbOIztddaVpq624N8+L0phmaOGCRwhWyME9WhwM
T6Iw6olFsfW7yL4CisRdle0v8XbQnuJzYCkkiMDo6cmgFPn2YC1EL6/7DRqIBQlZ
WNvgG7BC1UDNgKpSoBsbPZtMWnh48bBEoIY4Kpls/LzY1nF9x/hmDc0PPYK1ol1S
hX/hMAR6Fk1eXTi0EivdLsm78muC00iaJagv47lRUVuXThtrHMLR8/oph0bfXJRv
Y6yWcfoNT+f8k35WfxQKTGqm6UgIWKfyRvO4Vxm7T93fv+fOxLdpGmMWBcYprkxW
8mxCev8J5nvZpufSRnUV9tjYjle5n00t8q0I9qT3SWUuZ6Tn2Cr9N8aCtPGVDHXF
GU4YaNBt4EgD1D0aO4sj
=DRcb
-----END PGP SIGNATURE-----

--HmJrV61jcUDJBSmtS3k3LNaQPOgT8Bj9r--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
