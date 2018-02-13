From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 01/15] IB/ipoib: Do not warn if IPoIB debugfs
 doesn't exist
Date: Tue, 13 Feb 2018 20:12:05 +0200
Message-ID: <20180213181205.GV2197@mtr-leonro.local>
References: <20180213101841.20101-1-leon@kernel.org>
 <20180213101841.20101-2-leon@kernel.org>
 <a95eace1-2e3e-e97a-cbaa-ca58771e5cff@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ibq+fG+Ci5ONsaof"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a95eace1-2e3e-e97a-cbaa-ca58771e5cff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ibq+fG+Ci5ONsaof
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 13, 2018 at 11:06:02AM -0500, Dennis Dalessandro wrote:
> On 2/13/2018 5:18 AM, Leon Romanovsky wrote:
> >   	struct ipoib_dev_priv *priv = ipoib_priv(dev);
> > -	WARN_ONCE(!priv->mcg_dentry, "null mcg debug file\n");
> > -	WARN_ONCE(!priv->path_dentry, "null path debug file\n");
> >   	debugfs_remove(priv->mcg_dentry);
> >   	debugfs_remove(priv->path_dentry);
> >   	priv->mcg_dentry = priv->path_dentry = NULL;
> >
>
> Do we really want to keep sending stuff like this for RC? I get that it's a
> trivial patch and all, but it's not actually fixing anything. Just a console
> spam that only happens once.

It is more than simple console spam, but actual crash on the system with
warning == panic.

Thanks

>
> -Denny

--ibq+fG+Ci5ONsaof
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlqDKnUACgkQ5GN7iDZy
WKeYww//e0GpyNOBj6eqA+uerT5IlFw7l/D/iieEV8S8+iucPpGZHbb3aWsfKbFP
XFv746otKPl4fh1BJvsbZjLnv69I26eMYHn2otFFGhJiinc8SyOO7Q0Y0uVTPJO0
S7ZuT438wCmUOWA/DRVfRZYzOhAgwPvU4M2gdSMPMr8uypCacKJOVOrJeEOmnuJ7
Eprn4J+XhAHqaUEPbc5jBxTtke/FWPPPro8u9dPCC3ySd1fHtlarS+EmiPWmZvv0
ziIWp4CPZrY7Rhyfde1Tkfkt8UOjzO0ZAoVbLultjlm3BD3VjKVNO5BwES6CMGTg
6/+t1ATDTO5yeyzJU+67/BpVCKZiXn7CAJGRI4GofR6nWLzoTF8adv1H3C4/GYYp
ZFkoSEUyCrg006PyP4DXKSlBwAulQAEtkGM4i01/pM8fZS5zlVjhqYtncwI8C6tZ
DAih3GKXPYSgYgxnOewoVSWSu2etRa8j+37lvHItDhvx2F2oTGg41E3vAsu4lGSa
ciLFr0RNPsMscpheIkN/IP92eehW2g3E9n++nGtnnw/UO+v0I/mGOB8h6plMk3Kp
5Zv/C13XUMJCUp0jPE1lthfWoBQBL0EyNNEdmeZ9aRFOWY4J4CTJOMdGWnAjYOCV
b6IQGKCFm8S+J11wIjrqJuhMWtglWWQyRZTCoflfJmR0LFoMKBY=
=XZZ5
-----END PGP SIGNATURE-----

--ibq+fG+Ci5ONsaof--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
