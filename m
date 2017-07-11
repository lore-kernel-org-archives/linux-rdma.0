From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] librdmacm: Fix incorrect return value/type in
 a few man pages
Date: Tue, 11 Jul 2017 11:39:21 +0300
Message-ID: <20170711083921.GX1528@mtr-leonro.local>
References: <20170630223026.57939-1-david@omnibond.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="u4YTXYx8N/vaYnQM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170630223026.57939-1-david-gqc3UtWaqJ5Wk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Reynolds <david-gqc3UtWaqJ5Wk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--u4YTXYx8N/vaYnQM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 30, 2017 at 06:30:26PM -0400, David Reynolds wrote:
> Signed-off-by: David Reynolds <david-gqc3UtWaqJ5Wk0Htik3J/w@public.gmane.org>
> ---
>  librdmacm/man/rdma_dereg_mr.3              | 2 +-
>  librdmacm/man/rdma_destroy_event_channel.3 | 3 +--
>  librdmacm/man/rdma_destroy_srq.3           | 3 +--
>  3 files changed, 3 insertions(+), 5 deletions(-)
>

Thanks, applied.

--u4YTXYx8N/vaYnQM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllkjrkACgkQ5GN7iDZy
WKcB2BAAvI6NU+zkNv6e7cao8Zd4ouWeyhyugWDPxvU47Yik0WF5SVqMyzaXobZ9
Q8gxUbgnCJaySkWgiMwWsFJKNh74N/VobeVSRv213RYnRFDJJNlce2YCWERDniIf
NB2GfJ+1vzl2UNIulrEVaNp31ozyV44ol/cg7kO4lcoW9qxOsDphvMy7b3UfwsfR
tqK5WztgQHKrZHNmG5pmPGRnF2LEkqjMLmIrqku44falV7/amb2y9l6zQx9TEDHh
8YLmZjnBx/pu9+2Uvm562s9zpUNF9x8pe7rgEvoTn0Xe/dRb/fzdTrUOzcpP/1zE
yzGGDKMKoI51YVEFcuqZdGOW5zz+DfRFqoHIPUTbSmTrta1+ufkRY6MCuv7YZ31k
SyBqqxWsNfEdY/BK9LyiVsuS461P1pf2ROkSSrqM7wuE81LCj0GKybqoKslNdQWz
Di8cxMjaV/TYmjuIIgOkERQ4R3UPuxUmKTYJzEAW2VuIzwoQMZtnECFRoSViYQxf
KS4XpEtWqbaDgsIzmOafcvEOPQwzemBE+mEMoxOFm1Rkcq92EpsYpjYdbCtETl7e
dwJl3fuZpN+UatwzJv/NW5ms6xtHb/AsmpHGYw85pvYN2xuMZlgQ3O4gyQ0SaDCf
WB3Q2O7kZIl4zy7FKIdh6isuv+jePY42xVvQLDcQy1dO1k8HgYA=
=znHT
-----END PGP SIGNATURE-----

--u4YTXYx8N/vaYnQM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
