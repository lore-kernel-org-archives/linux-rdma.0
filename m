From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] IB/core: missing curly braces in ib_find_gid()
Date: Sat, 29 Aug 2015 00:02:51 -0400
Message-ID: <55E12EEB.9070207@redhat.com>
References: <20150818092210.GE3965@mwanda>
 <20150829011040.GA2713@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="G1W1IL6DqUvmxiUuNr1R44ONRJxuank4i"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150829011040.GA2713-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Yotam Kenneth <yotamke-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--G1W1IL6DqUvmxiUuNr1R44ONRJxuank4i
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/28/2015 09:10 PM, ira.weiny wrote:
> On Tue, Aug 18, 2015 at 12:22:10PM +0300, Dan Carpenter wrote:
>> Smatch says that, based on the indenting, we should probably add curly=

>> braces here.
>>
>> Fixes: 230145ff8124 ('IB/core: Add RoCE GID table management')
>> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>
>=20
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

I've picked this patch up (earlier today), so I missed your reviewed-by:
tag.  Added.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--G1W1IL6DqUvmxiUuNr1R44ONRJxuank4i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV4S7rAAoJELgmozMOVy/dShcQAJOzK/82QvlqbW1pwevAN9ym
Dsk8sCTo+nVbFql/0AN6eOcMaU8aR312x/XSWdN/Net2P77GX2Z3my34XbnX+8JE
t4TS++V/yGK5y6vOxIggbZ/3e6LStKwFQkySAg3kB/3Ab8EJ6DTyqkNic4VJBThw
v9pLlp6FpbD4wTqE8apBdQMuywNrfGlylYe2xBBLhPUN87iZi/+a/zr5yTTMARl5
NT2Xw2waSHBHkQewJ3455OKh3P2BuRPQwUG4eicIBb0W3mgs5bFFDAkOZJlRflvn
zkn0cTXGarO4XGNMdiMiLE/F5Hck17vtS++WgfYtbJX0pSxk+j73UUarpo26sqql
yeScEPA67yVmFg1DeaBP1zSibKtzlA+F5/HpMayMa6nv8BfcF7Ko/MZ++DxHn8OU
MQTUvuWtkVI5DWoIFOUSjaEjWsJ/Sj/YYeEDxo+oltJD7zwUHpJJuACY5HMtDIt5
6dlPYWZwNcwd1OPAu5O9aNPpp4nQJZz5dJJZ+OQXxRgSrLLmOEd1de/B89+6M1tK
dIyGFTuyo0rMxM+ZN3ZFqLa7QcN/p3j3jWUsk6kmqlLaWIZhAlA8W4yTVIfG4EcZ
cAx9C/R/lYtaMUt88p2DM3aQTV3rQZRXhX+EeXN9ak/VtOnZO7TORPARHKv1zo3C
7YTdWEmIs31g0y+8Dzsa
=w/kj
-----END PGP SIGNATURE-----

--G1W1IL6DqUvmxiUuNr1R44ONRJxuank4i--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
