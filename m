From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/cxgb4: Protect from possible dereference
Date: Mon, 30 Oct 2017 07:30:24 +0200
Message-ID: <20171030053024.GQ16127@mtr-leonro.local>
References: <20171029193435.314-1-leon@kernel.org>
 <001201d350fd$0dd04fa0$2970eee0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Zqu75NDXmDJGUu04"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <001201d350fd$0dd04fa0$2970eee0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Zqu75NDXmDJGUu04
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 29, 2017 at 04:29:50PM -0500, Steve Wise wrote:
> >
> > Smatch tool reports the following error:
> >   drivers/infiniband/hw/cxgb4/qp.c:1886
> > 	c4iw_create_qp() error: we previously assumed 'ucontext'
> > 	could be null (see line 1804)
> >
> > Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/cxgb4/qp.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/hw/cxgb4/qp.c
> > b/drivers/infiniband/hw/cxgb4/qp.c
> > index 57b23e33eb8b..4b3267358dff 100644
> > --- a/drivers/infiniband/hw/cxgb4/qp.c
> > +++ b/drivers/infiniband/hw/cxgb4/qp.c
> > @@ -1843,7 +1843,7 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd,
> > struct ib_qp_init_attr *attrs,
> >  	if (ret)
> >  		goto err_destroy_qp;
> >
> > -	if (udata) {
> > +	if (udata && ucontext) {
> >  		sq_key_mm =3D kmalloc(sizeof(*sq_key_mm), GFP_KERNEL);
> >  		if (!sq_key_mm) {
> >  			ret =3D -ENOMEM;
>
>
> Hey Leon, doesn't udata imply ucontext?   It's not a big deal, though, I
> guess.

Yes, it is, but I don't see any other option to clean RDMA.

=E2=9E=9C  linux-rdma git:(rdma-next) x checks
Preparing /tmp/tmp.rkPKPYnNE2 (identifier tmp.rkPKPYnNE2)
Checking out files: 100% (61292/61292), done.
HEAD is now at e183225dff87 RDMA/cxgb4: Protect from possible dereference
Redirecting the output to /tmp/tmp.VZsidBz0jJ
There are 387 errors/warnings

>
> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>

Thanks

>

--Zqu75NDXmDJGUu04
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln2uPAACgkQ5GN7iDZy
WKfuHBAAgU7lMc8ypII3kdT1P4hAaz4DMrzTZ6HkJXTbEJ3/oK5CTzyUprugUCrC
zOojRDZ7usbdv/4zUIxH325RjRK6aHxNJHzypwMepg3ilRwaHhgCCLcnsyc9mNJ1
XW1XuMhXsCjkZCuelkyhm6kSuYjeFVFGykmzag6Rgs45cE0/McR66lXyP1qezvCI
REFfgOJk64oFnEvWggZIrJv4Edv4tY96zJJxfzLske4uSoQZ4SBLANfaipu1f4jV
w1c67zZ1KWZDEGPopyvEr2wvtxPPdDICpMrTFTrQqUgODScohInhDihsJ8gxF9XL
jvRyaDu7t6REiD/dNvzV6W6gszLd7KPQgoUCwJ1D47Pt7in20dXDcTs1tYcIDlIG
LdpkQamtNGZ0rOyRo6ntF8eq/Hxr0wFUuIqsQ9BcPfVhKKli7xUlR4k50gY95agl
xaPilaALKuRG084/ALQfphXdtKeLDEPer67sn6JUg5kqk5Ny44RAjzpJ72IJET2M
/JQNrzD2CI5odEbU4/qRUpbNDUqO0wKr8UVIr5d5QASH4cyYKOdhGTXj+KLbXG8S
4NdI+d/uXvo+8BOid6y4T68nR4YHz1mPwmFM5iYyty8CssFc6jb1iq0Wljhb5uwB
EDJlABzB9VuLtQBJD+pVhYmE8NLuUpFE45xg0iMk/9jEz6Wet6I=
=KQ1Y
-----END PGP SIGNATURE-----

--Zqu75NDXmDJGUu04--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
