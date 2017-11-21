From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-rc 1/2] IB/core: Only enforce security for InfiniBand
Date: Tue, 21 Nov 2017 22:40:20 +0200
Message-ID: <20171121204020.GA18825@mtr-leonro.local>
References: <9bb92ec4-d29f-55b7-d3ba-33bfe451ea6c@mellanox.com>
 <20171121151409.GA29826@mellanox.com>
 <3eff140b-8f0f-1c4f-07b7-9dec46090a1e@mellanox.com>
 <410e7b54-02f5-849c-e3ad-56cc61f66647@mellanox.com>
 <20171121160442.GB18272@ziepe.ca>
 <20171121163454.GW18825@mtr-leonro.local>
 <20171121163648.GC18272@ziepe.ca>
 <20171121164802.GY18825@mtr-leonro.local>
 <fa4b7d56-5617-2b9f-65dc-386ab69c4e8f@redhat.com>
 <20171121185744.GF18272@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+wesONWNZXg3eyIu"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171121185744.GF18272@ziepe.ca>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Don Dutile <ddutile@redhat.com>, Daniel Jurgens <danielj@mellanox.com>, Mark Bloch <markb@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Paul Moore <paul@paul-moore.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--+wesONWNZXg3eyIu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 21, 2017 at 11:57:44AM -0700, Jason Gunthorpe wrote:
> On Tue, Nov 21, 2017 at 01:16:43PM -0500, Don Dutile wrote:
>
> > >>I don't really think it is really too user visible.. Only the device
> > >>and port number change, but only if running in mixed mode.
> > >
> > >Ahh, correct me if I'm wrong, you are proposing to split mlx4_ib devices
> > >to two devices once it is configured in mixed mode, so everyone will
> > >have one port only. Did I understand you correctly?
>
> > Which would require splitting resources that are shared now? other
> > splitting issue(s)?
>
> A change like this would be almost transparent to most users. The cx3
> card in mixed mode will look like a mlx5 card does: two single port
> RDMA devices.
>
> I think only a minimal amount of stuff is actually shared between
> ports, and as cx5 already demonstrates there isn't really a notable
> downside to having two kernel RDMA devices.

CX4+ cards have completely different HW architecture in opposite to CX3,
and mlx5 implementation doesn't mean that your suggestion is doable for
mlx4. It worth to check it.

Thanks

>
> Jason

--+wesONWNZXg3eyIu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloUjzQACgkQ5GN7iDZy
WKeNjQ//f2mmJdW0iG+Yn9eiM7GnRuvY+RDyPH0NGIbjeh9y87j6btkvVEBCc/RF
NZg68E+GYxsW/lYHgsH99NnDzv/zno6YN04gN8odjbIuhKZy9eUaQnDZINu2HVWI
dbGNlgcQkCYXBiXIdGfFX82+f4X8xqL3MNKX3eoAOEHsGKOaJqd0zyONDrF0ziyG
gGQXp48NPcqRzuG2O1VxIDDsub1KoSSnATkuwKaKeO14FEonoENENWTHK52k6ktz
ShXc46iAxagYeio4wHFjxZwKsk4reup6wKwsU/ybaKvfm+/Ngm7iy2ZM2P8DUoCc
KOxCDXiLknn6wltb0EyIH4SCaKZvHP5AHkQG6WgbqBkMfrR+K9hQ+xATx00oOUhE
uioc0UXGgo3IAbUHu9T1U48Q8s+rM1j12CZjNVULwgXMsNF9rc7alc2RDasGhSbA
G4quF8rhn2UYUxEPpIvXE+6melhubf+ryiK00f3m102KWJIsJaayYafgf9RsxYx/
q2ZxiVoOMPJQxhEeHLGjZgLso0fO9AFuJ0Sl87z2SPVPQ/F+L6KBCgSksJM3azgM
DgXYkro30mZHVnUpdYc65FXL3tFFiq9e3y3ArGmdLJn3kj95TiM6NkYFvj2aZ/8R
8WhmdbXTHnKtnBBPCbAcrclHwNKoLh3a/4pFugl4AzINgNB/eEo=
=8QTD
-----END PGP SIGNATURE-----

--+wesONWNZXg3eyIu--
