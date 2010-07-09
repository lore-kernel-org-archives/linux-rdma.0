From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: linux-next: build failure after merge of the infiniband tree
Date: Fri, 09 Jul 2010 04:05:45 +0100
Message-ID: <1278644745.4854.119.camel@localhost>
References: <20100709110427.c05987cc.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SDxkJnFeFJD33hkNdZuF"
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20100709110427.c05987cc.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Roland Dreier <rdreier@cisco.com>, linux-rdma@vger.kernel.org, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--=-SDxkJnFeFJD33hkNdZuF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-07-09 at 11:04 +1000, Stephen Rothwell wrote:
> Hi all,
>=20
> After merging the infiniband tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> make[2]: *** No rule to make target `firmware/qlogic/sd7220.fw', needed b=
y `__fw_modbuild'.  Stop.
>=20
> Probably caused by commit bd4d621eacaa6455da1c23260909da89ef4c1a01
> ("IB/qib: Use request_firmware() to load SD7220 firmware").
>=20
> I have used the version of the infiniband tree from next-20100708 for
> today.

The patch that I sent included the addition of
firmware/qlogic/sd7220.fw.ihex but it seems to have been lost somewhere
along the way.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-SDxkJnFeFJD33hkNdZuF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATDaSA+e/yOyVhhEJAQIS2w/9ErspPMPPD1t1i9hVJiYXuQKE4ljL5HxK
Y/yk3AiZsRrlI7+YJFTWCeivrRsGbW0MZxPKEVwNBB4nIFhwLa1ZJMOhZ+FFbdg9
YIvMjTWC1n8jCHUS/HQN6dUBEJDxMG3i6RcmSHkqodxEyby55fgOpi9z00sQNrbl
1K1lBWV8s40onYBPBnf9JE7vHav3b5bsxn4MJxDMtFOmOdpE1OegM6OmN9wT+xIb
1TiSncJGK10M8NveXO9aK8pTX9twdnxaZzceRa8BjixxAQlwxw47jznJDQjNie7g
gyHmBy+odZOX+DVvLkQceuCOLKMJgfP6F5lD05z5XrhNxYJ5DzK5ykHy6+zqrjuV
LO/LJFnccRbxNyTduozZIvRhg1mUQ4IDm/V8d+4RPSF12WVyLSb6/MH0QOuEkXpz
vBNKTeBK6p72LfuzLsCByAoms58eVqbO/vJw/J3yD4iJBgkpNDlvfSG2k2WajN6w
4q2DflC1NdpNivsLRwskSXVKNB/ejq1WvnN7RyckYcXqrWp5OT7ZJRE7hsk7Ah8x
xp8eXs/t0XCe1nnhK+95YI0EVbeFuuBHqfsoRVWNKanEXI/hyVWgDJUyIcn4ePSp
isPVJgkAgM1UgNNttIrk3O9PUqSQLdLV00W6UUzZu1ZQGKGqmTX3K6zGFMEtggTE
gfdJm1LsvAY=
=KZ/3
-----END PGP SIGNATURE-----

--=-SDxkJnFeFJD33hkNdZuF--
