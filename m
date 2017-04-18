From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] util: Add common mmio macros
Date: Tue, 18 Apr 2017 20:38:15 +0300
Message-ID: <20170418173815.GC14088@mtr-leonro.local>
References: <1492123127-6266-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1492123127-6266-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <b35958cf-5e87-3149-5413-eb754ec89b4d@dev.mellanox.co.il>
 <20170418172852.GD7181@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/Uq4LBwYP4y1W6pO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170418172852.GD7181-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--/Uq4LBwYP4y1W6pO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 18, 2017 at 11:28:52AM -0600, Jason Gunthorpe wrote:
> On Tue, Apr 18, 2017 at 06:52:00PM +0300, Yishai Hadas wrote:
>
> We could use a hash scheme or something to multiple the lock, but I'm
> really not sure that 32 bit performance matters to anyone anymore?

In a hard way, I learned that we have a customer who expects that his 32bit
application will continue to work, so the answer is - no, I care.

Thanks

--/Uq4LBwYP4y1W6pO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlj2TwcACgkQ5GN7iDZy
WKc4nQ//cCjS4eu4F2sYAb5JhElCcUS2nzRnS+d3bnauLHJOOL7RClfgZ94Ghqco
Bb//pZ3LC4mB4vV0E90X9Spck67D/uFd6IFJ7OeaOD1l9ebdQPK3/PftYHkJyepY
0/Nn3APh63EdcRMRpvGIy7h2nqHRYiNFZVzFeuQIvZMdBWvpG3zloQkCN50jRWSS
RECIe0NpDCfsJov9QykwtN8xVDhc5OnFWEzUddR4Kmqt1tRIYbGZi5deZBxiI+VY
3GnYe56NrR6OD+l17C9y/IuT4tXAERVIcIfTn1ggOmH+lk73UAs8Q+3rr+Xa64t8
anm74v88kF6KUZ0H+bLk3luREbRi5Z3fTpPCNo+SAsVb1iOPNs5cBnODA/i2LUle
4tPLOEbQPw1dgJ0edd2UA39YgpMLdUemSeYR8xtdREHg0P+hP6L5mncjJw4GeB0C
rOrQFM34MoJJV7BdXgOsVZlL3/ORAE27uSQhE/hzd7DbzuiXbF+EYWHu0PPX4FKO
dwQOQQMuR8GEjwFZ5bNAmathYpwf37Y+DYq6u/BXWeA8NUvxoPIkDiJ46AD0iKo7
vZlllwFCawnp02ydDlDIdTMpDW5B5dsGvoglZp0Hw2SDB08E6mmZu0imYeNHVy9x
iGBYlYYlvd4Jh37pSOFQA8y/klplbbVQK4nqh3d9nHbk4o6LF7M=
=zt8F
-----END PGP SIGNATURE-----

--/Uq4LBwYP4y1W6pO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
