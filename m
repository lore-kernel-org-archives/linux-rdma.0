From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma_cm NULL deref in 4.11.0+
Date: Mon, 29 May 2017 08:27:25 +0300
Message-ID: <20170529052725.GX17751@mtr-leonro.local>
References: <acc72471-eb22-4474-04f5-db23227faadd@grimberg.me>
 <VI1PR0502MB30083E6CB505CA90A9E047C0D1FB0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20170521154443.GD17751@mtr-leonro.local>
 <20170524163832.GA23034@obsidianresearch.com>
 <20170524185256.GT17751@mtr-leonro.local>
 <47078d0f-dc39-4a34-b641-0348877ca718@googlegroups.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vEk28Nl/eckWL8CC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <47078d0f-dc39-4a34-b641-0348877ca718-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sbranden-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: ml-mirrors <ml-mirrors-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--vEk28Nl/eckWL8CC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 28, 2017 at 01:54:59PM -0700, sbranden-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> Hi Leon,
>
> On Wednesday, May 24, 2017 at 11:53:07 AM UTC-7, Leon Romanovsky wrote:
> >
> > On Wed, May 24, 2017 at 10:38:32AM -0600, Jason Gunthorpe wrote:
> > > On Sun, May 21, 2017 at 06:44:43PM +0300, Leon Romanovsky wrote:
> > > > On Sun, May 21, 2017 at 02:30:04PM +0000, Parav Pandit wrote:
> > > > > Hi Sagi,
> > > > >
> > > > > Majd encountered same sometime back and reported [1].
> > > > > He has the fix should be posting the fix soon.
> > > > >
> > > > > Majd/Leon?
> > > >
> > > > The fix is in our rdma-rc branch.
> > > >
> > https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/com=
mit/?h=3Drdma-rc&id=3Df1fff656d55c52aeb12129f57347886b02f90e1d
> > > >
> > > > I planned to submit it today.
> > >
> > > Is someone going to look at the segfault in librdmacm?
> >
> > Does it reproduce with these two patches?
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/com=
mit/?h=3Drdma-rc&id=3Df1fff656d55c52aeb12129f57347886b02f90e1d
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/com=
mit/?h=3Drdma-rc&id=3D1d6af11df23f7df4963af7513a3dad109acbcd4c
> >
> > We are successfully run our regression suite on my rdma-rc branch.
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/log=
/?h=3Drdma-rc
> >
> > Are these patches going to make it into linux-next soon or do they need
> any more changes?

=46rom my point of view, they are ready.
I submitted them to the ML [1, 2] and they supposed to be added to linux-ne=
xt and forwarded to Linus by Doug.

[1] https://patchwork.kernel.org/patch/9739177/
[2] https://patchwork.kernel.org/patch/9739173/

Thanks


>
> > >
> > > Jason
> >
>
> Thanks,
>  Scott


--vEk28Nl/eckWL8CC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkrsT0ACgkQ5GN7iDZy
WKcRKxAA0HAzikJ0Je34c1My74dQh7ZPzA4m764Xgvj02L+CY/O2CWvLQ0ltC8YN
6JGbhvST6kiL6n2h0YJWvBaqpbboMgvgcpS1Y3rjTDwbKUszmDauKgv77yPo9J/R
1BEQvFDawjuIRqu63YagjEsPrrlZmESOcI4GmkDJuNk3+B86rpe8v2zCNRY52hZm
/dfcfCLqT1gLAYLR1XU64hpdAeS3n0v0ok1mp7Sdle6UuvhA1rbWZvFcTdNpY8xa
w0xoTVbBhJrhf3TLmIWu2PKXpIKHk8TZ7zIe8LKHBeje9vmaF5Bnfyt/NZmmj1W0
oqUyhUDYt0XwLz9H+yUWfjiiKZ8/Xf2d+/3HAB54diaRYbkV2ePVyquwNAJBfdc2
Rgx7ul7GTbK+rAAKrpINkOXKI0Y7laVWr/0nWCyGhhKj3bUfLlXOkzQsSCA8tSM6
IfIhFUPZ6h3mvVyWB+42/Lz8Wqhhy8G3LSSsJk2TNcrqM2Hn+4IXmqSyxM4GGSPf
Al7FWfo+ydGiJcohEbHLYhJthr0tNs5KmqzhjRDyLE9TLbggFJhoUbxrQWzXoWZR
L8oD+ZRGCHw4gNhlH7olpoE34IrUou1UL2qtbnpIq7wfeEr82wiV+Npjs9O34cNe
e2BmXq1YsDZYzwphDkuS7HqA4vQxNUDIl1G9cpp5o+R0YsfmZ0w=
=CtZn
-----END PGP SIGNATURE-----

--vEk28Nl/eckWL8CC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
