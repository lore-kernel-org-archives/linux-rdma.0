From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 8/9] IB/ipoib: Replace list_del of the
 neigh->list with list_del_init
Date: Mon, 2 Jan 2017 20:19:54 +0200
Message-ID: <20170102181954.GC12077@mtr-leonro.local>
References: <20161228124728.26619-1-leon@kernel.org>
 <20161228124728.26619-9-leon@kernel.org>
 <20170102122917.GB25669@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170102122917.GB25669-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 02, 2017 at 02:29:18PM +0200, Yuval Shaia wrote:
> On Wed, Dec 28, 2016 at 02:47:27PM +0200, Leon Romanovsky wrote:
> > From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Any reason why this patch, out of 3 in this patch set uses "Replace"
> instead of "Change" in commit header?

No real reason.

>
> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thank you for your reviewes.

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhqmcoACgkQ5GN7iDZy
WKccNxAAypb5O5vmITrBnnFpwP7R/Gsq0DcHxsW034k1rTeW0efSuEzUcH5a/niw
bgWkYmH5/H9bQLDPMfzmEcDB+LSnAaGh3lefqe/ntk1HoB86/Do0zAPmaPYlKJm7
0kttF1ScDQm64Chn4sYv/2NIGF/sBE3GFGfvolPGT2nw2Z3MScEuBbbPkCbfnEpZ
uKIm2igHfEAe4Lk20jFK8tOJ6o0er8TtnouEqtE2Imtvrx0k5mNvLuSH31QGcjzy
4+lVqEfhqTAFY5OlEVn7XZ4ecPAo+i/1h1ygBIJ3/ejuzxaoDX38V5M61gUamuc4
HAOZle/NhDmLaZfLd4ssMfv/o4TsHzwfEi68CH3MHVhXF78UvHsITOB9ldsG2bXR
+nVaG3Q0sZVJcz/BKuHB9NFiPn5O69vYaEwC/keepKQ6Ce2pKOU1ZNN7APcdI+0H
cnqbPNh7ql50MjB0dAXt9vyMbitvrNNnnFDLDw1Ik5Qq44e0SCd7vu5xQ57G8Qa5
88sZXHAf+oT7vHJxTfTIyAhh2IX1jnsu+IRv2OnCSer9bVzHAsXXi5lAOD7GRecu
xGUWwUVn2+WEDkonq5OzZ74QXLUNqScqBgZLnOIcTm8imHY3f8LLJRMZBm8mdDMy
CEeiDL1vrjyUCraenZ4+XZbbpzciy5IzHECFFbZ4M++LKVBhCxw=
=8cDo
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
