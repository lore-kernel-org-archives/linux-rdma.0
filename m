From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] ib_core: Enable and expose force_mr module parameter
Date: Tue, 20 Jun 2017 10:32:36 +0300
Message-ID: <20170620073236.GO17846@mtr-leonro.local>
References: <20170619152351.2866.11046.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Iys0Un1O+0sigPHU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170619152351.2866.11046.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: doug.ledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Iys0Un1O+0sigPHU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 19, 2017 at 11:26:40AM -0400, Chuck Lever wrote:
> The fourth parameter of the module_param_named macro is a set of
> file permissions. Passing 0 there means that module parameter is
> not created and that adding "options ib_core force_mr=1" to a
> modprobe.conf file has no effect.
>
> The default setting of rdma_rw_force_mr continues to be 0, or false.
>
> Fixes: a060b5629ab0 ("IB/core: generic RDMA READ/WRITE API")
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> Hi Doug-
>
> This doesn't seem appropriate to go through Bruce's tree for 4.13.
>
> Last discussion didn't seem to conclude with full consensus.
> Probably people don't care enough one way or another. But I'd like
> to see this get fixed if there aren't strong objections. Would you
> take it for 4.13?

I care and believe that it should be removed from exposure to users.
The variable force_mr should be leaved in the code for the debug,
but module_param should be removed.

Thanks


>
>
>  drivers/infiniband/core/rw.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
> index dbfd854..1cc8f07 100644
> --- a/drivers/infiniband/core/rw.c
> +++ b/drivers/infiniband/core/rw.c
> @@ -23,7 +23,7 @@ enum {
>  };
>
>  static bool rdma_rw_force_mr;
> -module_param_named(force_mr, rdma_rw_force_mr, bool, 0);
> +module_param_named(force_mr, rdma_rw_force_mr, bool, 0644);
>  MODULE_PARM_DESC(force_mr, "Force usage of MRs for RDMA READ/WRITE operations");
>
>  /*
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Iys0Un1O+0sigPHU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllIz5QACgkQ5GN7iDZy
WKcXMxAAnH9frGDASJjzm9FAu4/Nvupsm1Ggnnr2aryAor/0DUtF0B8K8r1pYb5y
7FaN8IW9+DdUotx8ofppvCtzPVE/iRSchdl0P1AelAHyYyZ3tgcEQCkM7Mm+UsGO
7bO8iIpgc3vZSl4NXQob/yJJezv8ncqtXhcgDO2KAcTBc3kNC+4Eu2a0iTtc+7PW
AzCFiHDv+GYMsNwokoD0Rnbxuh8GGvGHNyvfg5THe2HzPrTGXgr2TmBucG81VHUi
aXc4/otK2lYP5XOvzfHU4KXbhE7GWtRwpIhY3bWw4a+rsbW27CTIeH+f9hhiWNJr
LbnHKfTLnXb23syuLdLLhvyoxu22NiwdBTshrXJpfBf32Q1xUCsCtamleKpY/lRe
p+gIIH70/6WpMU00sRPoBaTzBHbNpcyvu7KO434Zt3SQWZINXLVwYZr8pXPXrDvW
gh5Ril/3LGULosn5enPLIQaf0VeZExWZvTgyyCCa/Xo8BkWHP9iU5KKUaPNQkPcK
x7B9ED6v/bu38ja3xcH7LdepqP6+qr2xrWx1ZeXUfXZ1SzCcTyHCK1GnUv4lHhmA
c87ofPecAeGtHNzIPAkhmGJ6ijgPMLtjt6eYH3l05DvDm1+Qz1E8l/X1x5DJxCr9
1IvSFUCGfOSfhsye6fRlojcSMnz/HXBPaGge2L95hDORwIv70Ps=
=JMBJ
-----END PGP SIGNATURE-----

--Iys0Un1O+0sigPHU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
