From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V2 03/22] IB/core: Add ib_find_exact_cached_pkey()
 to search for 16-bit pkey match
Date: Tue, 11 Sep 2012 16:34:44 -0400
Message-ID: <504FA064.6040002@redhat.com>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il> <1343983258-6268-4-git-send-email-jackm@dev.mellanox.co.il> <504F70FB.6030806@redhat.com> <CAL1RGDW6D25s+R8HuxK-DMrsS_wvKDTL+LSp2X-TK8gB8Vm2Fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6F89CCFD6C4C98A0B034FA65"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDW6D25s+R8HuxK-DMrsS_wvKDTL+LSp2X-TK8gB8Vm2Fg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Mascarenhas, Edward" <edward.mascarenhas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6F89CCFD6C4C98A0B034FA65
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 9/11/2012 3:07 PM, Roland Dreier wrote:
> On Tue, Sep 11, 2012 at 10:12 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> As a second note, I would like to know why Intel (previously QLogic)
>> does not use these functions in their driver and what it would take to=

>> get all drivers to use the functions.  Do we need to add more to them?=

>> In my opinion these should be generally useful and used by all drivers=
=2E
>=20
> Use which functions?  The P_Key lookup functions?
>=20
> What would a low-level driver use them for?  I thought these are for
> use by upper-level protocols.

Well, at this point, the mlx4 driver uses them, the rdmacm kernel driver
uses them, and both QLogic/Intel drivers have their own internal pkey
table implementation.  So, it isn't so much upper layer as it is drivers.=



--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig6F89CCFD6C4C98A0B034FA65
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQT6BrAAoJELgmozMOVy/dY5YQAI6CHF+nvFaH4+i4QpULvI7a
0e3Ebd5tlftDYAWn4+coBTk6A1USdER4GZ5DVNZsrAXKAfEQROR2i2xn2QAi0+ol
9qq9vv/7vV2DtKCBx6LZOdkWUJOZTBN2Rb/oXShVbza49h2empuS37nqHDMm8Ec+
DVJQwJ7IOzO01WhKzc3hyNCsB7+OoVXBWf2c05evm134erhQjNY2xFMEiDxH5Am6
p+HA9V+HNXvOdu89Bau5o6WRbwHYETcpNYGnBM4aohn/hm6HQpdtbeGQqbh+fSco
ONDg/CAjm1sKOZweataZN1IY3GPCFMPSsE68uQfnNwG3G9xblYFHNHJl7ddXeh7u
mW0j9Ef8OOQxrJeG0Yoxo7zZ39fcAExvVI5XBgbwpbI0DQKB7qehOOsGQiLA49kT
CkxNMlRlMNwXbu8e+zn3pSqwQEBP2tVcLbPd1VhlC6dgoBX1lo8VVFZQHCRIeswB
iARXbH8Nxe2AeCk5QtpCxVt9BdOiwEstycnRVCarTCWXqG67ck/U91VyDKtO4d+H
zyyUiJryQfEMvD3b1UFIfghhzsAV/iwdk12YmOwSMcH+ewYUk785WHRK0VcWfXrs
EDQsEcaFYA7reBIPYrtmxGosgDBjh/0LWhNBEAmM2rf0dmGzyFNArHDIZlhkdJ3B
sWzVeX31TLhB+iD0YIxe
=Q9ox
-----END PGP SIGNATURE-----

--------------enig6F89CCFD6C4C98A0B034FA65--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
