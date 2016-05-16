From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] ib core: Make device counter infrastructure dynamic
Date: Mon, 16 May 2016 11:43:59 -0400
Message-ID: <041c6da0-e022-2bd1-5f00-e569c077e154@redhat.com>
References: <20160315155441.222586021@linux.com>
 <20160315155455.173645653@linux.com>
 <057c8ac8-1d34-e7b9-c0ad-91d805c81139@redhat.com>
 <alpine.DEB.2.20.1605160851370.23895@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="BxUV6soTe0RQRbxn0DD2tLs0uHfUwmmlW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1605160851370.23895-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BxUV6soTe0RQRbxn0DD2tLs0uHfUwmmlW
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/16/2016 09:52 AM, Christoph Lameter wrote:
> On Fri, 13 May 2016, Doug Ledford wrote:
>=20
>> I don't like this entire chunk.  Please handle both the cxgb3 and cxgb=
4
>> changes like you did the mlx4 changes.  Specifically, use an enum to
>> define the array index for names and an array of offsets so that the
>> textual names from the enum can be used to access the array.  The way
>> things are here is horribly fragile.
>=20
> Ok but I cannot separate this out in a a distinct patch.

That's fine.

>> Secondly, do *not* use a BUG_ON in this patch.  I saw at least two of
>> them.  There is nothing in this patch so serious that we should crash
>> the kernel.  Any failure here is something we can work around and keep=

>> running.
>=20
> WARN_ON_ONCE then?
>=20

Yep.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--BxUV6soTe0RQRbxn0DD2tLs0uHfUwmmlW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXOeq/AAoJELgmozMOVy/dB9EQAMQMjscwWnQghkPlnhuTIzpU
kld9tlwLoa1S2PqG2gdbcju9w/8lsFeJWLN2Jb0+P/DRZ/sogVZl9S429X6uEXhD
1xxTdps5gGIptGUi+zzj7lklY0gMQr1YuMxGBc2hao1hVCFnK47BDETcWxeYhkeK
2fxU74DPiJLHz+Wx7itWFwdpOYcPgYQ7/Tj1lV2poIwbwvOhX6yAPE3nn4Bf4zh2
C9A1PqNfIn5xFxsBocQQtPnn4+RAtOyqoWtiu4g7KiWRH7TLTGPxHXrSbIhE98FT
TZC1tXkfNOYJZPYiTdpz1PQOKUsR7qXplG3hRoXr3h6ncjiW8OlHnnaKE5cJht2P
pxroNDv10fEkPsI8OJmBNLfs0520o+vGoO3cGANON4xcc2oK6eLZNI+KAu2UJC12
lt3z5lR+NntPVSakTofpzYzL70z4/yZsl0s44U5AX1nx2pzHXtETXLLp2iU/K3A/
kNhI5mx0/1SkpFzZij+IwOpBIGzI/p4eqewIVifM8Hp/CXTIQvKKQhCOKUg+XHk0
CcvbMWmF9nwoLzHZ/OyhbJUNZV9w/cDOS9DeEprI/baAmCsrfdKd0BxW2q62tFyc
RZFQYvW4+tvSpgaj3NuoWB6dM/R2p3H1Rxt/qcAcXwub37iy35zBbE2tFaHmNTbD
esbSLmwFPXQs1brjslvV
=IV3t
-----END PGP SIGNATURE-----

--BxUV6soTe0RQRbxn0DD2tLs0uHfUwmmlW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
