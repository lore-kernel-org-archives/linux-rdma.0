From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: daily Ubuntu PPA builds for rdma-core
Date: Tue, 7 Nov 2017 14:56:59 +0200
Message-ID: <20171107125659.GH18825@mtr-leonro.local>
References: <1510052419.25086.12.camel@profitbricks.com>
 <20171107113857.GG18825@mtr-leonro.local>
 <1510056129.25086.14.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mYYhpFXgKVw71fwr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510056129.25086.14.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--mYYhpFXgKVw71fwr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 07, 2017 at 01:02:09PM +0100, Benjamin Drung wrote:
> Am Dienstag, den 07.11.2017, 13:38 +0200 schrieb Leon Romanovsky:
> > On Tue, Nov 07, 2017 at 12:00:19PM +0100, Benjamin Drung wrote:
> > > Hi,
> > >
> > > are you interested in having daily Ubuntu PPA [1] builds for the
> > > rdma-
> > > core master branch on Launchpad? I could set them up easily and
> > > they
> > > would produce usable .deb packages for all Ubuntu distributions.
> >
> > Yes, together with Nicholas's openbuild setup, it saves from me to
> > setup packagecloud.io.
>
> Okay. I will do the setup. Following steps are needed:
>
> 1) Convert https://launchpad.net/~linux-rdma into a Launchpad group
> 2) Setup a git import of the rdma-core github repository
> 3) Write a build recipe (very simple)
>
> If you have Launchpad account, you can join the linux-rdma group (once
> created).

Once, you will finish the step (1), please drop the note here and
people will join.

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
> URL: https://www.profitbricks.de
>
> Sitz der Gesellschaft: Berlin
> Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
> Gesch=E4ftsf=FChrer: Achim Weiss, Matthias Steinberg



--mYYhpFXgKVw71fwr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloBrZsACgkQ5GN7iDZy
WKdhYQ/+OxEH1CCq3CPXj8N7zi/+27IBGw0eCal80QNYqcn+qW4heCijAlUF4Lsq
i6JFr4r/GY2fumFpaxTrj9lnKC8wqIgTBMflggxjJs9yzTKXlkePcbEeuvlicA4Z
eLdO7Knkqox7xYNt78eSStGwCjihDq+Rg7LXZXp3afpmPbAtEMTJbGak/ygL5Py+
lEHFNJ9LPWfSuNxJlAzI2ZvIFnjDvyhzz8H6AyH9Kky26ZmRJNULRtDYIb5v1FTT
CbmuQXKXtgEzkPQeidXU6BgQgTpz/WvmSqldlUiv9Ye9wIa0eBma4fg7lO2D3+wP
54DowdG5UoRRZSDY2/kDYBgX2QiNrzFE3zcAZDy4QhidmBGpvFND4b7izrBLHMTK
Hr54KyDKjIv0p7GXheFbPdqzZf6VTbequIfX8vTavx6rQUPeAKAe5UAm2sl1MyCQ
IxZzY/V45Yv7Q2qHsSxW/A5ZdO1Vqu0gljjWW4VhV+OlXz7emamO8zj6RtM1+3gQ
aHjNO0s6eMqRCExuGb6YAXVi6MdhDDWqGJmASahHz4CeT4yFGeVy/LpJT9FHNFQ3
XlznTlQkjtnAK/GSlfOyKYKfekN3gGxpWaqmFoA63o/VransLIoziEbAVpIk9hjJ
G63tG7xjMHrHY+mVvp4m/AdmaYcFakiaRJdHjwfpXqm1SavnmQ0=
=pdkD
-----END PGP SIGNATURE-----

--mYYhpFXgKVw71fwr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
