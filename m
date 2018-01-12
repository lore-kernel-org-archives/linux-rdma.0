From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] cbuild: Add Fedora 27 container
Date: Fri, 12 Jan 2018 20:32:33 +0200
Message-ID: <20180112183233.GO15760@mtr-leonro.local>
References: <20180112115209.17437-1-leon@kernel.org>
 <20180112180855.GF15974@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mI5TpPl/qDRoXxBg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180112180855.GF15974-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--mI5TpPl/qDRoXxBg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 12, 2018 at 11:08:55AM -0700, Jason Gunthorpe wrote:
> On Fri, Jan 12, 2018 at 01:52:09PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Add Fedora 27 to the list of cbuild targets.
> >
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >  buildlib/cbuild | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >
> > diff --git a/buildlib/cbuild b/buildlib/cbuild
> > index 3f659bf8..0ef80b60 100755
> > +++ b/buildlib/cbuild
> > @@ -141,6 +141,20 @@ class fc26(Environment):
> >              " ".join(sorted(self.pkgs))));
> >          return res;
> >
> > +class fc27(Environment):
> > +    docker_parent = "fedora:27";
> > +    pkgs = (centos7.pkgs - {"make"}) | {"ninja-build"};
> > +    name = "fc27";
> > +    specfile = "redhat/rdma-core.spec";
> > +    ninja_cmd = "ninja-build";
> > +    is_rpm = True;
> > +
> > +    def get_docker_file(self):
> > +        res = DockerFile(self.docker_parent);
> > +        res.lines.append("RUN dnf install -y %s && dnf clean all"%(
> > +            " ".join(sorted(self.pkgs))));
> > +        return res;
> > +
> >  # -------------------------------------------------------------------------
> >
> >  class APTEnvironment(Environment):
> > @@ -337,6 +351,7 @@ environments = [centos6(),
> >                  jessie(),
> >                  stretch(),
> >                  fc26(),
> > +                fc27(),
>
> I've been keeping only 1 fc container, no need to test old fedora.

I'll remove the rest.

>
> Jason

--mI5TpPl/qDRoXxBg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpY/0EACgkQ5GN7iDZy
WKc/fQ/+P0amt+ZQug4QZZgIFcTcXPiUHr4w6kHBVs9PWAnMVLKALUUkbdgWS/XO
MZ8EGKX7hWYmF5Xr7HfCw6cZpHe4d/KFFHTPw2e+90xoPV7vTG0hLOcw5UizjQdq
qoXvVTRgVFCnozaHTtRY7Vui8mkfV+seXimrw2c/LQE0bcGnLSjQP1WIjVF6rCbP
BD5IETKnC4XA/LH0P59+Xa1BE3hGhjhakmucJAnFD65+XBnw1S4xIz+WTiqwhrzE
BrdAp3/uB+KRUc7N95UGudkPLV5eVR96MvxsSRWs+v0IDP0C0uU5z3K8evbsuquH
fpiKRt7TTr4Uswm+bXCP/7/dUryJGWHr7J3jduvKFRVHVbAUt4hwbwN0KwYlh2g/
2n/edPxfmPUGOsQ9lbdAU7swEMT+byVHZoJcyklpCPBDmQmf6HKeQh0KMbuwbbSN
x1iA+Z72TVyP05PSo7dvENuAXf0eiDNWPcytNDpDQ3pF9RIfX76aghCCvwKEVFxT
XzggdvnwqCzpQEogbyXQjhQ8lcXBa/UtCWAAs5LjIvFMwnV4vTNmzHxmeLnZAgrv
v8GUXXTW6nZPRjOd7p4Dorwyh9ou3Dm0Xlo2NvkvMD3hIt4XxkykgCOWUVhEI54K
wmw7MrvQYoQgH1OuhTCmBOUR0f8kXnrgPSLpLMg6V7oFPxjYaQ4=
=6UTd
-----END PGP SIGNATURE-----

--mI5TpPl/qDRoXxBg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
