From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] Further timeout paramater verification (Was: [PATCH]
 infiniband-diags: Verify timeout value specified to diagnostics)
Date: Sun, 2 Jan 2011 17:53:17 +0200
Message-ID: <20110102155317.GC6409@me>
References: <20101220215735.GA4020@redhat.com>
 <20101222114707.c6ec051f.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20101222114707.c6ec051f.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Jay Fenlason <fenlason-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11:47 Wed 22 Dec     , Ira Weiny wrote:
> On Mon, 20 Dec 2010 13:57:36 -0800
> Jay Fenlason <fenlason-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> > Sorry if you get this more than once, I seem to have outgoing mail =
misconfiguration here.
> >=20
> > On Wed, Dec 15, 2010 at 11:47:09AM -0800, Ira Weiny wrote:
> > >
> > > Verify timeout value specified to diagnostics
> > >
> > >
> > > Signed-off-by: Ira Weiny <weiny2-eSE4LqFkL++LYFxP40JT4w@public.gmane.org>
> > > ---
> > >  infiniband-diags/src/ibdiag_common.c |   10 +++++++---
> > >  1 files changed, 7 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/infiniband-diags/src/ibdiag_common.c b/infiniband-di=
ags/src/ibdia
> > +g_common.c
> > > index 99861f1..8ccf2fc 100644
> > > --- a/infiniband-diags/src/ibdiag_common.c
> > > +++ b/infiniband-diags/src/ibdiag_common.c
> > > @@ -175,9 +175,13 @@ static int process_opt(int ch, char *optarg)
> > >               ibd_dest_type =3D IB_DEST_GUID;
> > >               break;
> > >       case 't':
> > > -             val =3D strtoul(optarg, 0, 0);
> > > -             madrpc_set_timeout(val);
> > > -             ibd_timeout =3D val;
> > > +             val =3D (int)strtol(optarg, NULL, 0);
> > > +             if (val > 0) {
> > > +                     madrpc_set_timeout(val);
> > > +                     ibd_timeout =3D val;
> > > +             } else
> > > +                     IBERROR("Invalid timeout \"%s\".  Timeout r=
equires a "
> > > +                             "positive integer value.", optarg);
> > >               break;
> > >       case 's':
> > >               /* srcport is not required when resolving via IB_DE=
ST_LID */
> > > --
> > > 1.5.4.5
> >=20
> > This only partially detects invalid timeouts.  For example, timeout=
s
> > of "123skidoo" or 1234534587347895789457897897894578978912902393 wi=
ll
> > be accepted but will not work as expected.  To fully test the
> > conversion, you need to do something more like:
> >=20
> >   long val;
> >   char *endp;
> >=20
> >   ...
> >   errno =3D 0;
> >   val =3D strtol ( optarg, &endp 0 );
> >   if ( errno || ( endp && *endp !=3D '\0' ) || val < 0 || val > INT=
_MAX ) {
> >         /* invalid timeout detected */
> >   ...
> >=20
> > All of the tests are required to detect invalid inputs.
> >=20
> > 		-- JF
>=20
>=20
> Patch below,
> Ira
>=20
>=20
> From: Ira Weiny <weiny2-eSE4LqFkL++LYFxP40JT4w@public.gmane.org>
> Date: Wed, 22 Dec 2010 11:40:33 -0800
> Subject: [PATCH] Further timeout paramater verification
>=20
> suggested by Jay Fenlason <fenlason-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>=20
> Signed-off-by: Ira Weiny <weiny2-eSE4LqFkL++LYFxP40JT4w@public.gmane.org>
> ---
>  infiniband-diags/src/ibdiag_common.c |   18 +++++++++++-------
>  1 files changed, 11 insertions(+), 7 deletions(-)
>=20
> diff --git a/infiniband-diags/src/ibdiag_common.c b/infiniband-diags/=
src/ibdiag_common.c
> index 8ccf2fc..8f5eec3 100644
> --- a/infiniband-diags/src/ibdiag_common.c
> +++ b/infiniband-diags/src/ibdiag_common.c
> @@ -138,7 +138,8 @@ void ibdiag_show_usage()
> =20
>  static int process_opt(int ch, char *optarg)
>  {
> -	int val;
> +	char *endp;
> +	long val;
> =20
>  	switch (ch) {
>  	case 'h':
> @@ -175,13 +176,16 @@ static int process_opt(int ch, char *optarg)
>  		ibd_dest_type =3D IB_DEST_GUID;
>  		break;
>  	case 't':
> -		val =3D (int)strtol(optarg, NULL, 0);
> -		if (val > 0) {
> -			madrpc_set_timeout(val);
> -			ibd_timeout =3D val;
> -		} else
> +		errno =3D 0;
> +		val =3D strtol(optarg, &endp, 0);
> +		if (errno || (endp && *endp !=3D '\0') || val <=3D 0 ||
> +		    val > INT_MAX)

When using INT_MAX <limits.h> header should be included to prevent

	src/ibdiag_common.c:182: error: =E2=80=98INT_MAX=E2=80=99 undeclared

error. I'm fixing this.

Applied. Thanks.

Sasha

>  			IBERROR("Invalid timeout \"%s\".  Timeout requires a "
> -				"positive integer value.", optarg);
> +				"positive integer value < %d.", optarg, INT_MAX);
> +		else {
> +			madrpc_set_timeout((int)val);
> +			ibd_timeout =3D (int)val;
> +		}
>  		break;
>  	case 's':
>  		/* srcport is not required when resolving via IB_DEST_LID */
> --=20
> 1.5.4.5
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
