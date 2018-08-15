From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH mlx5-next] RDMA/mlx5: Don't use cached IRQ affinity mask
Date: Wed, 15 Aug 2018 09:37:14 +0300
Message-ID: <20180815063714.GQ5325@mtr-leonro.mtl.com>
References: <9a4d8d50-19b0-fcaa-d4a3-6cfa2318a973@mellanox.com>
 <02dc01d41ecd$9cc8a0b0$d659e210$@opengridcomputing.com>
 <c5362a12-4be6-9f17-7f06-a52aed69e3b6@mellanox.com>
 <a9c4a70d-d578-0581-09aa-a3a56f3b2c02@opengridcomputing.com>
 <f936d176-c56b-143e-3311-f6df48f633dd@mellanox.com>
 <20180723164910.GS31540@mellanox.com>
 <c079b7b4-bff8-8ffe-0be5-e470c86479b4@mellanox.com>
 <b0f6a58a-0078-05a2-a7f9-946b2ff21846@grimberg.me>
 <f1442839-ff32-ab80-9eab-6923456fe272@mellanox.com>
 <47178d4d-f730-6e59-5c19-58331cc3864a@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CQDko/0aYvuiEzgn"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47178d4d-f730-6e59-5c19-58331cc3864a@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: Max Gurtovoy <maxg@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, Jason Gunthorpe <jgg@mellanox.com>, 'Doug Ledford' <dledford@redhat.com>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'Saeed Mahameed' <saeedm@mellanox.com>, 'linux-netdev' <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--CQDko/0aYvuiEzgn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 06, 2018 at 02:20:37PM -0500, Steve Wise wrote:
>
>
> On 8/1/2018 9:27 AM, Max Gurtovoy wrote:
> >
> >
> > On 8/1/2018 8:12 AM, Sagi Grimberg wrote:
> >> Hi Max,
> >
> > Hi,
> >
> >>
> >>> Yes, since nvmf is the only user of this function.
> >>> Still waiting for comments on the suggested patch :)
> >>>
> >>
> >> Sorry for the late response (but I'm on vacation so I have
> >> an excuse ;))
> >
> > NP :) currently the code works..
> >
> >>
> >> I'm thinking that we should avoid trying to find an assignment
> >> when stuff like irqbalance daemon is running and changing
> >> the affinitization.
> >
> > but this is exactly what Steve complained and Leon try to fix (and
> > break the connection establishment).
> > If this is the case and we all agree then we're good without Leon's
> > patch and without our suggestions.
> >
>
> I don't agree.=A0 Currently setting certain affinity mappings breaks nvme
> connectivity.=A0 I don't think that is desirable.=A0 And mlx5 is broken in
> that it doesn't allow changing the affinity but silently ignores the
> change, which misleads the admin or irqbalance...

Exactly, I completely agree with Steve and don't understand any
rationale in the comments above. As a summery from my side:
NVMeOF is broken, but we are not going to fix and prohibit
=66rom one specific driver to change affinity on the fly.

Nice.

Thanks

--CQDko/0aYvuiEzgn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbc8oaAAoJEORje4g2clin/4sQALL46xUEPo6SM6vyFlhyPP8N
gp8nWPq4ZcJdflmduT4DYPOUG10acMQAck3M38qOUJGsx9rG/rtC34/mRs0eP9OG
ZLqPEGCA236ajj5fP7C26aI9DJL5yNrKpj1w4sy3J5weXc0ir8z/fpfTxPf0RJam
5f39Avevpzff0RPHFjCz6GjreRWPQfQWfK8LOIeiFduLXUOl2q4y8XJnOfCmlLjX
KF4f/f7oIEbDZnSzZYjIroX+ziPjuVESxaRCxiqO5zkI3GKXCyU8xg5zDneAPX2r
biMOGZ8UbHM4PnriBr4GHWqgFcqXsJutG81l2PsxDMXOQZ/eM92Z0aqY9zQHR1N4
sMTOBRKI0k0QH1kC40brNOzO7FFgkvpTfdIrfPyg71LskJoAUgCwAZl6tM9PWQLV
tADk6PbLSrheNg8cjoj5N/ERPEKAD1WHTW+T16P6ByDeXARghGHToybMD9CvbFqX
f1Z5vpn9m8O3Q5swvxYbaWjl28N5Fb0n6UDJpPrEqasbs5xjp37aHDsagIxzeKY6
RA1A97l9iuA6hRTuSAQIFXbayYqDFWkKabUFnMmr5knIaMjpFExLNu5lcCYt/FYw
WFP3ltI7xsGMjIdX3v7KPr0bd04PCDBzdE4rPdrUIrb7lfmbTIp/5HsC0/PQBeeq
Zt+nr0mlLrNmv6Bn3O5W
=8s+/
-----END PGP SIGNATURE-----

--CQDko/0aYvuiEzgn--
