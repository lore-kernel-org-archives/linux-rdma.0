From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] ibacm: Incorrect list used for subnet list causes a
 segfault.
Date: Mon, 16 Oct 2017 07:58:16 +0300
Message-ID: <20171016045816.GB2106@mtr-leonro.local>
References: <20171013184347.28410.87093.stgit@phlsvslse11.ph.intel.com>
 <20171013184352.28410.32200.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ds9maZbwT7uk2FVi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171013184352.28410.32200.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ds9maZbwT7uk2FVi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 13, 2017 at 02:43:52PM -0400, Michael J. Ruhl wrote:
> From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> When using the ibacm from rdma-core commit bf03566e0aa976afc5df,

That commit is unrelated to ibacm. I think that we can remove this line.

> setting the provider keyword in the ibacm_opts.cfg file to something
> other than 'default' will cause ibacm to segfault on startup:
>
> ibacm[32739]: segfault at 302e40 ip 000000000040432d
> sp 00007ffe4039e1c0 error 4 in ibacm[400000+c000]
>
> To re-produce the segfault, change the provider keyword in
> ibacm_opts.cfg from:
>
> provider ibacmp default
>
> to:
>
> provider ibacmp 0xFE80000000000000
>
> When adding subnets to a provider subnet list, the incorrect list is
> used.  The list used is the provider_list (list of all providers)
> rather than the (specific) provider subnet list.
>
> This corrupts the provider_list, and causes ibacm to crash with the
> above segfault.
>
> Use the correct list when adding subnet information to a provider.
>
> Fixes: 26e05f8304a506 ("ibacm: use ccan/list.h")
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  ibacm/src/acm.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
> index 1ccef94..a67001d 100644
> --- a/ibacm/src/acm.c
> +++ b/ibacm/src/acm.c
> @@ -2587,8 +2587,8 @@ static void acm_load_prov_config(void)
>  					return;
>  				}
>  				subnet->subnet_prefix = htobe64(prefix);
> -				list_add_after(&provider_list, &prov->entry,
> -						&subnet->entry);
> +				list_add_tail(&prov->subnet_list,
> +					      &subnet->entry);
>  			}
>  		}
>  	}
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--ds9maZbwT7uk2FVi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnkPGcACgkQ5GN7iDZy
WKcY1w/9EYh/k6vj9AesCtqdauD48eLvseRCoxakXFz1Yf3pPhBjqiEa9F1pGJVO
g1gLzoPCasVUpzEWrg6FelzjtmiYg/uhzhRkseTfJXjN567MZ+i2GwutFQyrfRUk
seeQkxQaNj6T0LsVoCvhPjzDWfm0dXAddr6zQjXDYGJMRvWkgqrs51zsTk8m4WnI
e3XPTRg9vqTU0lXmNGEbcIjONLVabcHwRXpzwMku9Arquxtw+PRAFf/89ROHgpFt
pgwUcIhtUY9c7VZMd0GPHlyKYtrWepsmjPdZrCD0vBwWH6VlrI7jocg3HR4+GfJd
Q75iOzbWakkKByI1NdKG6mCI7aOWYPV0nAIGLOl/3XqDizjz55wGX+nwrfbiE+lT
IAprbPqn+c1GKZ1Yx7PtBVsgsn4B0jerOXCs+LOxt0GWCQBYHZ/eXYDTVv8L728m
+bCK0E2agm3r+5Vvr+QYS2QXOkMloE7y1zxvqJb/hVD6RDTPkBng9cJo7t+KIazt
q4Qwe3wgXYGtrVlPMB6Yih2EHC/IPQhVof8EARwe8grQb9pse+C0uZ03CThLjqIF
wS/utMIcO1VqV6lQabmX+4MBEhek9Yp+ygXfQKVWdviF8QdgFTjtY1gulLwLT/08
M7heNKQUEkq/KsI38X/k+quA34lBlRKyNHfTml7YHYVgJvBbZdY=
=MPEZ
-----END PGP SIGNATURE-----

--ds9maZbwT7uk2FVi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
