From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] cbuild: Add Fedora 27 container
Date: Wed, 17 Jan 2018 20:39:43 +0200
Message-ID: <20180117183943.GR13639@mtr-leonro.local>
References: <20180112115209.17437-1-leon@kernel.org>
 <1516202077.3403.254.camel@redhat.com>
 <20180117161614.GA3764@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="90KBcPA0h13nTGdQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180117161614.GA3764-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--90KBcPA0h13nTGdQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 17, 2018 at 09:16:14AM -0700, Jason Gunthorpe wrote:
> On Wed, Jan 17, 2018 at 10:14:37AM -0500, Doug Ledford wrote:
> > On Fri, 2018-01-12 at 13:52 +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >
> > > Add Fedora 27 to the list of cbuild targets.
> > >
> > > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >  buildlib/cbuild | 15 +++++++++++++++
> > >  1 file changed, 15 insertions(+)
> > >
> > > diff --git a/buildlib/cbuild b/buildlib/cbuild
> > > index 3f659bf8..0ef80b60 100755
> > > +++ b/buildlib/cbuild
> > > @@ -141,6 +141,20 @@ class fc26(Environment):
> > >              " ".join(sorted(self.pkgs))));
> > >          return res;
> > >
> > > +class fc27(Environment):
> > > +    docker_parent = "fedora:27";
> > > +    pkgs = (centos7.pkgs - {"make"}) | {"ninja-build"};
> >
> > Is there some reason why are you pulling a fedora:27 container and then
> > centos packages?
>
> That is the pattern, centos7 has a list of required packages that is
> most similar to fc27. It will make more sense when the patch is respun
> to have fc27 replace fc26..

I'll do.

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--90KBcPA0h13nTGdQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpfmG4ACgkQ5GN7iDZy
WKfuShAAomdmnkvpnfYRasVIoJ3Tyk+dc8IrBsreBdgN4YjVtPIovdZBy7YrTqE+
JReXx3OJ/OeZYjZPFgicWxHMhuaNVCfLd8qYi1WgrSsI2Z8lZyVv5s1+9aDUQVIu
v3XZf4VFIcLYEE87BOZsRmen+JGN/FDyItlRedI8zJU+/aXrIV/JqLAiWf5uxTQW
Q04FlwanJJ9ApEiAEaWiOBDe4pABP7PdGlEn3YTmlaDEt9huNstNFgNH1U031lKt
hE2lHFuJb94WKg0GOMU4QQ7TSkyq2/dyVNpiM/Nyl1FI7m0yvK34UBXdyz6CpLoa
6ciw8wMw9DJE3knQ1nuefGZhJA69XbcEmvaunC6SN982gbg9oDDeD/mdyHkmMJ/j
4V/rkNNm6y8cFOKQCds+OAzJBwm9ARgYT9/WSNV/jtIyG8/NJXhbL2ZIrYpj51S8
agHMZHfdz58xwlQOR7TSTfn5DXMJj4AwsjBLggHvIlAtho/MfPGd2d/5Fjkaf6V/
KeVSx1Qci4PgBxEhpE++boHDm+MTYKVZ20b9iENYxSQ7s9877E4FTrCmSz5Y7FMZ
othtSuSl3DqFKl5W9IUuX+65HCuAqWq5rfZMqm/PQcXvXHKvzGhrmiT2ONLD6tcI
s17rq6HLa40J68caYcMgk2NdkBNZI9kCsWK1V7+0dmW7O/g3KyI=
=8zW9
-----END PGP SIGNATURE-----

--90KBcPA0h13nTGdQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
