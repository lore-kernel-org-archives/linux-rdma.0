From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Change rdma_protcol_iboe to roce
Date: Wed, 20 May 2015 14:58:12 -0400
Message-ID: <1432148292.28905.3.camel@redhat.com>
References: <1431630106-28829-1-git-send-email-ira.weiny@intel.com>
	 <1431702851.4214.3.camel@opteya.com>
		 <2807E5FD2F6FDA4886F6618EAC48510E1107F5B2@CRSMSX101.amr.corp.intel.com>
	 <1431725566.11477.15.camel@opteya.com>
	 <cdc5efd8a350e6a98c98f5f8169fe487@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-pNA+q++a9WktuDMuIkFA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cdc5efd8a350e6a98c98f5f8169fe487-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav.pandit-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-pNA+q++a9WktuDMuIkFA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-05-18 at 21:45 +0530, Parav Pandit wrote:
> Hi,
>=20
> At present we have chosen to call it RoCE. However I believe IBoE is more
> generic for the reason where,
> If the future RoCE versions may work on non-converged Ethernet, IBoE woul=
d
> be more appropriate name in long haul.

I don't think that's much of a concern.  If you change RoCE to work over
non-converged ethernet (really meaning lossy ethernet), then you have to
have an underlying transport that guarantees packet delivery in the face
of losses...like TCP...and then you have iWARP ;-)

Anyway, I picked this up for 4.2 Ira.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD


--=-pNA+q++a9WktuDMuIkFA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVXNlEAAoJELgmozMOVy/dY5sQALaWG9pRjyCw8LtzwUlMbuxp
bDuA7pZVXnssrkKTeQcH8z9xHspPaNhx6j48XBJWxBcPWnZSe1+ddOiUOxV2QD2Z
8UsBW5gdYSWh8q2rMFLU0rX8QT3H4+pdViuaN8jbZdxiWRQvQFaZf9zfbX4IO2AS
PGPUCu92cBwlBA6MZ/ktYU7ASZvG+vi6fJyYD5GWbNKAKhA0EuGf1S5G95lxL5U3
1l7QWnE2y6TglTym3TMWR0ucXg6L7dGM0IoKetT8NpZUpgx0woKpvH//c4xLoM7Q
urbkGAqxO7IglYJ2MQKxRCGqEfsnqL2k4iGv2FmCJFaj/cs/pJJ/C2H0IaA2x5ow
EzRSyzvsRPlGfwi6/43un/KfBtCXSiN8pHoNgmvx8t0baFKFXu+A27T1o2xtZ+70
YbA4vpIVkqPGViR8TYUEewKVsJVg/ebCErKNeBMnrC4pcVmMPpbbjRY9gga8UDYr
d2rywUVIarfUL1o8nct657Of3TGm+A9590KJba7a2twuYyozlvww/6tJ0xPcYMDi
FITT7CzgWfo/acjCbccfzIy12KIEVpuvXPuXwaJ2hSkjMLsvcUKwNFqZbxTs5blR
qbMyehR5qBInfbLfMTCQeLXXSLOWAt9/Ldqdv6LBacSZfon7h7yQ3mkkEMheJCA+
idJXECtoTUwzU8JkATpd
=ekhh
-----END PGP SIGNATURE-----

--=-pNA+q++a9WktuDMuIkFA--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
