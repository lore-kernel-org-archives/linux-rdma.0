From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] IB/usnic: Fix error return code
Date: Mon, 22 Aug 2016 14:24:07 -0400
Message-ID: <b6ea2a2f-fd60-d235-cc24-0fec5e453de9@redhat.com>
References: <1470843901-16506-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="CeHbaqsDjRumFK1PbNhqbSB8c2j59d24c"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470843901-16506-1-git-send-email-christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, benve@cisco.com, dgoodell@cisco.com, sean.hefty@intel.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CeHbaqsDjRumFK1PbNhqbSB8c2j59d24c
Content-Type: multipart/mixed; boundary="Icl45dbmOD7JN2oj0MqhreR2l1rfEvI6k"
From: Doug Ledford <dledford@redhat.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, benve@cisco.com,
 dgoodell@cisco.com, sean.hefty@intel.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org
Message-ID: <b6ea2a2f-fd60-d235-cc24-0fec5e453de9@redhat.com>
Subject: Re: [PATCH] IB/usnic: Fix error return code
References: <1470843901-16506-1-git-send-email-christophe.jaillet@wanadoo.fr>
In-Reply-To: <1470843901-16506-1-git-send-email-christophe.jaillet@wanadoo.fr>

--Icl45dbmOD7JN2oj0MqhreR2l1rfEvI6k
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 8/10/2016 11:45 AM, Christophe JAILLET wrote:
> If 'pci_register_driver' fails, we return 'err' which is known to be 0.=

> Return the error instead.
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Thanks, applied.


--=20
Doug Ledford <dledford@redhat.com>
    GPG Key ID: 0E572FDD


--Icl45dbmOD7JN2oj0MqhreR2l1rfEvI6k--

--CeHbaqsDjRumFK1PbNhqbSB8c2j59d24c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXu0NHAAoJELgmozMOVy/dirUP/1erX1qjuagMf1ut5VwXTBX+
5w6ssEcxL7oHda43AlXHqvdbNvF+vD3MQwUP2KS38EyyAZaDr0ULOR/xjEQyiLOo
DKkmEDDWyIV0xnlDTJuW4G9kjLvNIXw0lw3l0WUimS8R1naAWr/qQNrdAwkRCE2L
/BoWapfwYUYO/LIHgODBTn6IN8eAP+Bjp/JQuIhkJCy1OmiqJh7Jf+pFavTVsN4Z
IoKbsBaqGEweJ02V24jt0/oaoy1I5DloyAxZKsDZMEX/q/lb6Y3DV9lstqeBbnx4
aPHkw0EOyVliZk2Elqq9Ts2ksUIlkhPfN9PQCdPuqaMsSy3GJstQuGxRpCc8vB1D
xawF2C/jNH2HpYTlMABwlKjyjHkM/VEELuvq49qzAg1LdkTWtxllJ+n+z4KkME9/
STBm+SzGPuHFMDjhY2qGF6tb9lhIPKDmem+qtqNidwLdiYOuWGArPT0ZGh/mWnl3
j55Lp+TuyVyERNaSBFRdT4GuC7NisePAkhR3UUh3Lc9GstyZOnCD0fKgs/5H/mzi
eAj/suCI/kbc88pBYq/u4IH3ACT1RDHdwa0vIV8Bee0igHl9NRBHl9coAWQEuFLg
ZZzYl1PUyYFZs5FxEyZXTVC97FBgkUToIn/tCQv5SyspUdp4TDVm5qOZ/tdBw0ex
dSPNGNkaXOTLT4lOENBm
=ge2/
-----END PGP SIGNATURE-----

--CeHbaqsDjRumFK1PbNhqbSB8c2j59d24c--
