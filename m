From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH -next] infiniband: fix ipath_chip_init.c build errors
Date: Tue, 11 Oct 2011 11:33:49 +1100
Message-ID: <20111011113349.f1334f2b6df5c14e8cac97f5@canb.auug.org.au>
References: <20111007174230.702f4a0bf1fe71dab5e10961@canb.auug.org.au>
	<4E8F683D.9020604@xenotime.net>
	<CAL1RGDXoiRfR1Ku67tRgbhxzyWQmDrjKCztnVd6wbwi0Uud90Q@mail.gmail.com>
	<4E8F77B8.3000805@xenotime.net>
	<CAL1RGDWXV2=cYTRAvKuZbquOPS7n-p3NJkYnrzyK_ZAbKsJy6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Oct_2011_11_33_49_+1100_fISY29tI=Yx8ZFux"
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <CAL1RGDWXV2=cYTRAvKuZbquOPS7n-p3NJkYnrzyK_ZAbKsJy6A@mail.gmail.com>
Sender: linux-next-owner@vger.kernel.org
To: Roland Dreier <roland@purestorage.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Mike Marciniszyn <infinipath@qlogic.com>, linux-rdma@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-rdma@vger.kernel.org

--Signature=_Tue__11_Oct_2011_11_33_49_+1100_fISY29tI=Yx8ZFux
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Oct 2011 12:02:29 -0700 Roland Dreier <roland@purestorage.com> w=
rote:
>
> On Fri, Oct 7, 2011 at 3:05 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > First I saw it was in today's linux-next (20111007).
>=20
> Got it... a latent problem exposed by some include clean up, probably.

Almost certainly the module.h split up.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__11_Oct_2011_11_33_49_+1100_fISY29tI=Yx8ZFux
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOk47tAAoJEECxmPOUX5FE1+IP/RnXkLf5/Kinm174IHzhM9aK
0dSEsWzm9zr6tRnrXCzx2RC0kplsmvKCeeME/XN/N/Sz//kgeCXheSKtie81snRN
zF11xzDi8c806jQsxgPVwd9NC9mwur8HitORJuY+Jni9Hiu9Q4tuEh5X9xjkrc63
+DH+okSc3y+XUYyoZdU0VYmwJlkkDRE68sTNocPHfFNXKQezSWWigNohT0RVnkV4
5cY1VWM2S/0OhfRXgert4X9/IU7nqD37BPzqJB5D0xhjoVHJO3F3nJwUY2gSzi2q
7rugwUoxDskHAzfNa9Ob+CX4+v7T51rdG7nvsOQ3zxkBAi9VSK2YJuIXqZ7p7l05
W6Uplctu1/Nk67BEPAWg8e5ryTiT5kcwzEMAqEXD8yeCoV6tMk2i8gtYUaS7A8Rb
1blVHC1GbfaJD4ppC0oLvZve+ju07KaKQJ9lQO08Tj2GasIYPybc62/LVDaXoP42
9A8NflDdDtVocT38AC1YXFQR5XvPEZb1A03NPIi9+xt0mogxvawNiXHm3gKxB/ur
fiObGJBMhrpeRG2WYzzDc0v2licGy56FDllu5U+kF8DvIO/WsM5SQo1IpGJoiwFQ
OPj1iCMIboafuKCCuPso7hUZF4iaLIZOnE81LFG8VnfVDuXai7iqoWFr9+6zQhYC
l3Z9B0otY0Nak3F0UIBT
=i2+q
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Oct_2011_11_33_49_+1100_fISY29tI=Yx8ZFux--
