From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH iproute2-next v1 4/4] rdma: Document IB device renaming
 option
Date: Sun, 4 Nov 2018 13:12:52 +0200
Message-ID: <20181104111252.GA3638@mtr-leonro.mtl.com>
References: <20181031071758.6178-1-leon@kernel.org>
 <20181031071758.6178-5-leon@kernel.org>
 <bb0836d9-6ebb-3383-3d61-8347d0d72561@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="X1bOJ3K7DJ5YkBrT"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bb0836d9-6ebb-3383-3d61-8347d0d72561@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 02, 2018 at 10:47:16AM -0600, David Ahern wrote:
> On 10/31/18 1:17 AM, Leon Romanovsky wrote:
> > diff --git a/man/man8/rdma-dev.8 b/man/man8/rdma-dev.8
> > index 461681b6..b2f9964a 100644
> > --- a/man/man8/rdma-dev.8
> > +++ b/man/man8/rdma-dev.8
> > @@ -22,6 +22,12 @@ rdmak-dev \- RDMA device configuration
> >  .B rdma dev show
> >  .RI "[ " DEV " ]"
> >
> > +.ti -8
> > +.B rdma dev set
> > +.RI "[ " DEV " ]"
> > +.BR name
> > +.BR NEWNAME
> > +
> >  .ti -8
> >  .B rdma dev help
> >
> > @@ -33,6 +39,8 @@ rdmak-dev \- RDMA device configuration
> >  - specifies the RDMA device to show.
> >  If this argument is omitted all devices are listed.
> >
> > +.SS rdma dev set - rename rdma device
> > +
>
> 'nroff -u0 -Tlp -man man/man8/rdma-dev.8' shows that you lost the
> spacing between that line and the Examples line.
>
>    rdma dev set - rename rdma device
> EXAMPLES
>        rdma dev
>            Shows the state of all RDMA devices on the system.

Thanks, sending v2 now.

>
> ...
>
>
> >  .SH "EXAMPLES"
> >  .PP
> >  rdma dev
> > @@ -45,6 +53,11 @@ rdma dev show mlx5_3
> >  Shows the state of specified RDMA device.
> >  .RE
> >  .PP
> > +rdma dev set mlx5_3 name rdma_0
> > +.RS 4
> > +Renames the mlx5_3 device to be named rdma_0.
>
> That does not read well. I suggest dropping the 'be named' to make it
> "Renames the mlx5_3 device to rdma_0."
>
> > +.RE
> > +.PP
> >
> >  .SH SEE ALSO
> >  .BR rdma (8),
> >

--X1bOJ3K7DJ5YkBrT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJb3tQ0AAoJEORje4g2clinoxMP/Ro/yPYp/6a0W+rUoidRLvqm
qSJvS9fONvvNX56pnXyHsS1YakzfPvcniHRt7YEN5cLgskES6rJUk6v3HN3NXkMW
0d6L6TNZQ+1U6Js1DrToVQ02O2FuSR+Kw+1IbwaH/JSSxQ1zgyGvbtSrMlYnhDBC
qSUPPMR0plc5wcItZbj7EK3ASk5+u3gokkvDZqXhrLUc9OMf6f1bUzjAA5nmffrO
c3LDhfEh1xu0vkQNtRed2rJnvg7k5SExcg2J0x3wMYWFk2KtTLk1FrvbL3YMxeOG
GjIFH4vsh/w5abmqeO11Y2l3VMpGNoR4I+8XbyH6aoyIgLKYFH6DuM27U9L2Nyb/
wSN/bpi3iE/oCTL1CpJSL4iXEaFMP2trizJ94YZ/lFygntvDD2kH/v80neyNrR4x
lnJZMdJdXZjS4EjsZHfJSC8m2/B64MwtqIJtO5vFipnPNR6b1AGvqymZWPkQpSsq
amzRa72+xXhz59SsOdsSXCehLh5xLF5oH5FO6B/tTHBNRBsbI1qCMaA66tZYLR2H
fA+LPZdJn68Z4iJn4qvkqk+IL3TdAlh0XQgHJ3Dn3w4ytj21L8ZsN9VM3pgNRuWq
sIlt0WWID15ApP5eUKp+R5iTAvYm0RkaQYuKpEnThB2CCTiWQ1fPhnSulcfIB2gw
JW9gSyAh4YhJr/XZoPmR
=tmCc
-----END PGP SIGNATURE-----

--X1bOJ3K7DJ5YkBrT--
