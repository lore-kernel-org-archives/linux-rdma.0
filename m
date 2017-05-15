From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-ndd shipped by infiniband-diags and rdma-core
Date: Mon, 15 May 2017 21:14:14 +0300
Message-ID: <20170515181414.GM3616@mtr-leonro.local>
References: <1494335693.3752.1.camel@profitbricks.com>
 <20170509175406.GJ10073@mtr-leonro.local>
 <2807E5FD2F6FDA4886F6618EAC48510E67CAA0F6@CRSMSX101.amr.corp.intel.com>
 <20170515044419.GW3616@mtr-leonro.local>
 <2807E5FD2F6FDA4886F6618EAC48510E67CAA44F@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vN1VrOpIkjMGbM/7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E67CAA44F-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "'Hal Rosenstock (hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)'" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--vN1VrOpIkjMGbM/7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 15, 2017 at 03:08:49PM +0000, Weiny, Ira wrote:
> > >
> > > Indeed this has been in the plans.
> > >
> > > Leon, as I have said in the past I want to move the infiniband-diags to the
> > Linux-rdma github but only after the libibmad merge.
> > >
> > > For review I have put my proposed new infiniband-diags (planned v2.0) here:
> > >
> > > https://github.com/weiny2/infiniband-diags/tree/master-new
> > >
> > > I'd like to have Hal check it out before I push this officially and release it.
> > >
> > > In the meantime Leon can you set me up a repo on Linux-rdma and once we
> > have settled on the libibmad merge I will push there with a new v2.0 release.
> >
> > Sure, which name do you want for this repo?
>
> infiniband-diags

Done,
https://github.com/linux-rdma/infiniband-diags

>
> Thanks,
> Ira
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--vN1VrOpIkjMGbM/7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkZ7/YACgkQ5GN7iDZy
WKe4Sg/+OBPpaGwCPhvevH1IjVBQtk2nM/JJZvv/DQ2Cp8M6tAzOw8pkfyenEr6L
3MHk/06dnO8jdALi7qdw8xtmEv5k13P+Lp4RbznGs9/eVLZXFVqD2rHQI+A5F1ee
j1OEj+M8boOkBa+xlng/2oON+uhxEdruStQET0LoYqNQKrJ1EWVrzeWt1klV44SW
5A9HESAkvtpLsrfse1t8UC7ZQBABrjcqIzYreSS4HiEDM8zZz2xY7LcVjZXI5nAk
mHgFpK2+eEF/07uEALdqwpKOI+r8Mo0TOzgUrUJwdacLTU2CuVgl6fADjiT02lI2
XBZhTBXBOyheP33zSi+Le6jZ+85eEt/FqXqPVx0SwJf5pktlmb0TN3ZGDdYk6DuH
B+fyk/N8l0O3QG5QZaYwoycbpz7491i69MKsx3YARWuEpZWQzXPuNLvn9fLTkJDI
P4LscSs3cbIgwph9iw95BOlJ/A+HVNOGYmHkwtqL/RRrY+HdNcEU2Z9+qkO+2x+O
KoJGt4zNJf+2Z5qUPWvZ/niCbV8l1awcHld51ERKXp4O6C9Tbzz4xGoesKH42r74
Kh2RTgRCoozD6955Wy6DzD4nnXAIKv+BKk7UpbbmLL5CJmOLW8yNjdgcz7DtcZFL
Iqc/5g2lI5K+1KpRVxBZx8h8iaCZ4A/8KRC9v6vpHFAp4F9Bccs=
=lNPZ
-----END PGP SIGNATURE-----

--vN1VrOpIkjMGbM/7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
