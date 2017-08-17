From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [ANNOUNCE] rdma-core-15-rc1 has been tagged/released
Date: Thu, 17 Aug 2017 16:03:32 +0300
Message-ID: <20170817130332.GF23648@mtr-leonro.local>
References: <1501590709.2725.10.camel@redhat.com>
 <20170802054512.GW13672@mtr-leonro.local>
 <1501761459.117042.5.camel@redhat.com>
 <20170816080523.GG24282@mtr-leonro.local>
 <1502902372.33760.17.camel@redhat.com>
 <20170816175144.GX24282@mtr-leonro.local>
 <1502961063.3554.3.camel@profitbricks.com>
 <20170817093648.GD23648@mtr-leonro.local>
 <1502965632.3554.5.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="W5WqUoFLvi1M7tJE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502965632.3554.5.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--W5WqUoFLvi1M7tJE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 17, 2017 at 12:27:12PM +0200, Benjamin Drung wrote:
> Am Donnerstag, den 17.08.2017, 12:36 +0300 schrieb Leon Romanovsky:
> > On Thu, Aug 17, 2017 at 11:11:03AM +0200, Benjamin Drung wrote:
> > > Am Mittwoch, den 16.08.2017, 20:51 +0300 schrieb Leon Romanovsky:
> > > > On Wed, Aug 16, 2017 at 12:52:52PM -0400, Doug Ledford wrote:
> > > > > And I know this particular thread is in reference to the rdma-
> > > > > core
> > > > > package, I haven't forgotten it, I just haven't had a chance to
> > > > > test it
> > > > > yet :-/.
> > > > >
> > > >
> > > > Thanks for the update, I asked it in context of rdma-core,
> > > > because
> > > > Yishai stopped submissions of all our user space patches till the
> > > > official release and it included my one-liner fix to
> > > > ibv_xsrq_pinpong
> > > > :)
> > >
> > > As Debian maintainer, I am waiting for the rdma-core release to
> > > finally
> > > upload that version to Debian unstable. There is no required
> > > improvement from my side any more.
> >
> > This is excellent news, so the rdma-core will be part of Ubuntu 17.10
> > too.
>
> I just checked https://wiki.ubuntu.com/ArtfulAardvark/ReleaseSchedule
> and saw that the feature freeze will be in one week. So I have to
> create a rdma-core snapshot now and upload that to Ubuntu.

Can you wait till Sunday with this "now"?
We have very simple fix to our mlx5 direct verbs API and it is important
to update it before it spreads.

The internal code review is completed and we will send it shortly.

Thanks

>
> --
> Benjamin Drung
> System Developer
> Debian & Ubuntu Developer
>
> ProfitBricks GmbH
> Greifswalder Str. 207
> D - 10405 Berlin
>
> Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
> Web:=A0https://www.profitbricks.com
>
> Sitz der Gesellschaft: Berlin.
> Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
> Gesch=E4ftsf=FChrer: Achim Weiss.



--W5WqUoFLvi1M7tJE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmVlCMACgkQ5GN7iDZy
WKcsmhAAhb/Iqhu9yPMHbpy/Scw5iThAW/Q+4RZySVuTfVfBfCT2ia/ojax2tNS+
UyNOzu6OwBTgwFMr2x2obW7KzE2V71iHVkAm+5DljcqBds2OnKBNTRaISPV7vThi
UN3bkdae5Jy05uenA0njnrnKgpLFw1nniGvENqOvLSmpwvg4tT560ECPwpXytp+J
DlVYYNkNMOPD2OxbRO63DFWSr19t4ceUPpSUOZiHjvYScc1j+9Je95NZQR3JoUgE
S6L6bCLlPdda65SfInctE+5kKMBRmFD7iKqlD9bLKbFQ/6pBh8Cp1xSbZz0n0stD
voiOk9MDzkbLzf0Ib4aq3AKuWUzH0cYCOO9nePT4VVfia7KD7wxH2Blk/mcXRGN7
0NayJyTXSI1MK1lZeUPeG6CKhlAG7VJ2oNGKuojGqvFtbdTmy3oL6DUr7TGVTqW7
yQ91sVQl3M73c5iOjzWr0WaOVv8dCi5WPAYUiLpZCSuszauWfbu9+0Gtm8RQW6x7
XZzQi2fijCr+XN/4G5MZufFFgZD5NpLlvKu43qg8iDfef2FX/It/UEB7wwiTlZLJ
f8gEPHs+uJk9thww+b7ALyxhtNlOtS96LKT5zJnLofgn+Wj1w/52RnF7p4Zl08sx
JZ8T8xjvfYbNjfQlfBEOGlWPycSNCRxmIVzzVjzfluFiSSIHiBU=
=2IHv
-----END PGP SIGNATURE-----

--W5WqUoFLvi1M7tJE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
