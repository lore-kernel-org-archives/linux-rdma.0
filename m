From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v2 0/2] Handle mlx4 max_sge_rd correctly
Date: Tue, 8 Dec 2015 13:17:28 -0500
Message-ID: <56671EB8.6010207@redhat.com>
References: <1446031696-19022-1-git-send-email-sagig@mellanox.com>
 <5641C8BC.40507@dev.mellanox.co.il> <20151203142730.GA20520@infradead.org>
 <56605AB7.3000705@dev.mellanox.co.il> <20151208170139.GA425@infradead.org>
 <56671A31.7090401@redhat.com> <56671DAC.7060001@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IbOAXICVLL0Mpixr7Q3dGtp9ap5BdPmbu"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <56671DAC.7060001@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Christoph Hellwig <hch@infradead.org>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IbOAXICVLL0Mpixr7Q3dGtp9ap5BdPmbu
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/08/2015 01:13 PM, Sagi Grimberg wrote:
>=20
>> I've pulled these in.  Both of them failed to apply, and the first one=

>> was just flat baffling in terms of how Sagi is working from a source
>> base so different than the one in the upstream kernel.  They should be=

>> double checked just to make sure I'm not missing something since they
>> were so far off from applying to an upstream kernel.
>=20
> Hi Doug,
>=20
> I mentioned this in v1. This patch set is applied over Christoph's
> device attributes patch. Will it go in as well?

No, that's too big and not the right sort of fix for 4.4-rc.  I had it
on my radar for getting into for-next.  So, it'll have to be fixed up to
apply over the top of your patches which will already be applied.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--IbOAXICVLL0Mpixr7Q3dGtp9ap5BdPmbu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWZx64AAoJELgmozMOVy/dv2MP/A0HxEjkU1DOqtpiyWUyNSQm
DKwfCVXkBJA5dGwKjZbUB+z7Keqd41yboa44mo+9yo7Ttkp1kkfC5rndfk57HQ2v
7P3tzDxURa0PyOHE91PJ2RRdqsdcq1DBOZnLr5+ozMhO3W6cTJXug2RSuYYNNsfE
vlVxrjhs8JE34lPi2t02PBb2f6/3lOqGZDUc3L6FoCTyEndbt+wSh8dAtQIKbeQ1
LbAr0+YPNRsUy3fYU6g7kg3vT2jEYSvJ+Fe7oRZ0KVnOKA8Yg2FMaxSr7P7ZJzLM
c7tjTodNdYvn5bBOsTYPJcuZRxt2+gk9tORicDcrZkwIKFoSerp8miV/deW4ceAF
OVru8pU+htjx689inrmLaFkhczEh2X6movON7Z47irOpprhAw7McuzsYVnlL48n0
bDUltc08vfCN889SE/XEBOH77FpivG+LaJdNuv8cqR3W2InM5RpHull/bTPrQSg6
R9OI98acf4hvITpTTOZbDVfkDVagjxu5YIOGclozMq64ycZ2BZZpTqbk7I1B8KOe
kCM3H252eGm79mTrA2KFMHgJ+0jhddli9nXTrN8N9vsyxcb7Ee0IZtJLY7Nv/3aU
Qglx6eMqDP1zTltVLWq+7vzJnO+wxloERvA/o3e1fM2mF3eW5tuwqXFwR3ejA2xz
bgG3Jh9/Wt8ajm66j6G+
=s6jA
-----END PGP SIGNATURE-----

--IbOAXICVLL0Mpixr7Q3dGtp9ap5BdPmbu--
