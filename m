From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [IPoIB] Missing join mcast events causing full machine lockup
Date: Tue, 02 Aug 2016 15:21:12 -0400
Message-ID: <1470165672.18081.37.camel@redhat.com>
References: <57907A37.3000902@kyup.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-qyDN4LMggK/1gHVROxMC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57907A37.3000902-6AxghH7DbtA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SiteGround Operations <operations-/eCPMmvKun9pLGFMi4vTTA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-qyDN4LMggK/1gHVROxMC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-07-21 at 10:31 +0300, Nikolay Borisov wrote:
> Hello,=C2=A0
>=20
> With running the risk of sounding like a broken record, I came
> across=C2=A0
> another case where ipoib can cause the machine to go haywire due to=C2=A0
> missed join requests. This is on 4.4.14 kernel. Here is what I
> believe=C2=A0
> happens:

[ snip long traces ]

> This makes me wonder if using timeouts is actually better than
> blindly relying on completing the join.

Blindly relying on the join completions is not what we do. =C2=A0We are ver=
y
careful to make sure we always have the right locking so that we never
leave a join request in the BUSY state without running the completion
at some time. =C2=A0If you are seeing us do that, then it means we have a
bug in our locking or state processing. =C2=A0The answer then is to find
that bug and not to paper over it with a timeout. =C2=A0Can you find some
way to reproduce this with a 4.7 kernel?

>  So Doug, what would
> you say about the following as a proposed fix (not tested):
>=20
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> index 87799de90a1d..f6f15d36b02d 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -947,7 +947,7 @@ void ipoib_mcast_restart_task(struct work_struct
> *work)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0*/
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0list_for_each_entry_safe(=
mcast, tmcast, &remove_list, list)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0if (test_bit(IPOIB_MCAST_FLAG_BUSY, &mcast->flags))
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0wait_for_=
completion(&mcast->done);
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0wait_for_=
completion_timeout(&mcast->done, 30
> * HZ);
> =C2=A0
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0list_for_each_entry_safe(=
mcast, tmcast, &remove_list, list) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0ipoib_mcast_leave(mcast->dev, mcast);
>=20
> Given the loop afterwards which uses ipoib_mcast_(leave_free) that
> should work?
> Looking at the code in ipoib_mcast_leave it seems we are going to
> trigger a warning,=C2=A0
> which is preferable to putting the machine to a grinding halt?=C2=A0
>=20
> Does the proposed patch break things horribly ?

It violates the intent of the join processing. =C2=A0And if we have the
problem you are seeing, we really need to know if it's broken in IPoIB
or deeper down in the core portion of the stack. =C2=A0Breaking out and
continuing might be OK, but if we do, we are likely going to either
leak something or have a use-after-free or something like that, so I
would have to spend some time thinking about how things might go wrong
and whether or not it's better to stop the machine when this happens,
or continue and hope we don't corrupt memory somehow.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-qyDN4LMggK/1gHVROxMC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoPKoAAoJELgmozMOVy/drHoP/RQkPeRKBefdg2wPq78GCMOO
yE0GISXXgKpfpZPhaXGtCP/9qU9GQBKUp/XoS3nPpYqCe49FUDHol40cPJ/9wJi8
8e7mLfpgwQ0tDB+nYRsUrFXHTDLCoy+5KjiStSuhnNmCMZgemY+/9kh1YxbvCV0V
fp4126LjLoYiwiAHgARrKDuGmZnKgxb7T3pQ9+DIWkbEIOnRgg8NjIIpK9jhUSNz
kXG43MZoHoh2cranX945RLrSyC1OXX7fIcC1H8BJqYaCybD2o1lgaohpYkI7dxTt
M8HTHwdJdjMEd5TzwXMZsmsPmDbvl7x9VGZStHcPPJewG+GvxghhXF0HHzBH0V5G
p9lHrDwmrYdGKLO8GO4+kRJnbbV2WkXH1oTDBetp7Y3rLFlcNR2sjTKW7nInDgCU
6Kifw+5LOvgOaOUy6QpUfbl6Et+TzMOEIZRPrmbPCUEEJlPE3oScU9NTgqsEhi91
aHuQ6he5bicRooadju0GNH6cIFlje1YjK4zmVCadqVDpqM/hcYU/xCkEje2b1cX1
JrHzwiEqO7ex/TYGuwkOyKnTK+Y0d0TIRnq9YimI8OPjp3/CEWZjkthHUrWhz4mv
huYvFSIv2WxEpYO2pc0FzpLTf3jqY6f0KeInL/O1+SMu5YUcuXDccP19KyYnm1QK
lzZ0U+gwwzJY0vEBxGU+
=v1Il
-----END PGP SIGNATURE-----

--=-qyDN4LMggK/1gHVROxMC--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
