From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next] RDMA/qedr: Fix rdma_type initialization
Date: Tue, 26 Sep 2017 09:10:05 +0300
Message-ID: <20170926061005.GD1230@mtr-leonro.local>
References: <1505842717-26646-1-git-send-email-Michal.Kalderon@cavium.com>
 <20170919174721.GL5788@mtr-leonro.local>
 <CY1PR0701MB2012B48FC05034ED663DB1D188610@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <1a07af53-0729-956e-129c-2c914e0e3d0c@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/3yNEOqWowh/8j+e"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1a07af53-0729-956e-129c-2c914e0e3d0c-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--/3yNEOqWowh/8j+e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 25, 2017 at 08:29:58AM -0400, Dennis Dalessandro wrote:
> On 9/20/2017 1:42 AM, Kalderon, Michal wrote:
> > From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Sent: Tuesday, September 19, 2017 8:47 PM
> >
> > On Tue, Sep 19, 2017 at 08:38:37PM +0300, Michal Kalderon wrote:
> > > > Initialize the rdma_type (iWARP or RoCE) which is set according to
> > > > device configuration in qed.
> > > >
> > > > Signed-off-by: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> > > > Signed-off-by: Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> > > > ---
> > >
> > > Please add Fixes.
> > >
> > > Thanks
> > sure, i'll send v1
>
> Does just responding with a "Fixes" tag get appended automagically by
> Patchworks?

I don't think so, but let's check with fixes line from v1.
Fixes: e6a38c54faf ("RDMA/qedr: Add support for registering an iWARP device")

The v0 patch is here https://patchwork.kernel.org/patch/9959815/

Thanks



>
> -Denny
>

--/3yNEOqWowh/8j+e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnJ7z0ACgkQ5GN7iDZy
WKdLdw//W7rqfGYGwmyHTbkOqhCU5xKApRiJpazucJIUTM3MkMMc3/GBDnfAoQBL
5MWKCqAeih2QtPAYajZlytBTxzh6aMoUUthu700BKvLSWWAMhljzrq10eNiuc9NE
uqGPQTYH2TH10Vmb841B/cFnYWb72MfKDUGtslwXoHJiu9DVrZSlvhl9s20N4qut
2ied8Xj55zpqkCtsQSTgimPjAkZ7oJnNjZVVO4PiHW/jHJLGEIOZrqna4nbDmtEO
sp1g3MbJ2QlcNPIZDOWQYj/JjqnnlI6XA2T1C4B4oqzkQJEAVYAx7ekxCFhJaWRG
dLBAknr2bciAjfO2R+3qRaN7fIupL+6QXgtehO1Q0Qt6Of98FgD/34zuR6myB36l
cohbM8LjP9FQHQkBdLa2XqABOg4fENJSsnLQrPF4M+8b3M4RD4EAOnSfewVZuxaO
Px9haJbuJXsLWD9WHJEYcZXT5VFZXXUQwQj23Id2sW8SQWhANbNbWJNxd07Hk6+N
ixFGCQuqfmXpgNo+t3ITLZXrSTFFLitEu9VQ87OoBUNMj4lioaHfoko2JtzR/kT7
PmzEC1FLvLVr+A9PagltDhh2Q1WcFIH0FGhQuZbh2etJSTjxD2Rs3Jwl+EHR/Hcn
UaXPzAuUJtcwRo/HfhjC7nuUJzqMPt+2hcEiwA4UOIawM0PXCzk=
=6IWy
-----END PGP SIGNATURE-----

--/3yNEOqWowh/8j+e--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
