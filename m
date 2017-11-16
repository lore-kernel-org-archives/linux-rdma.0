From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/2] Debian packaging changes for 15-2
Date: Thu, 16 Nov 2017 15:15:32 +0200
Message-ID: <20171116131532.GJ18825@mtr-leonro.local>
References: <20171116122937.31770-1-benjamin.drung@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IPwq7vKbcnUIujWQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171116122937.31770-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--IPwq7vKbcnUIujWQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 16, 2017 at 01:29:35PM +0100, Benjamin Drung wrote:
> In addition to my previous set of packaging changes, here are the remaining
> changes from my rdma-core 15-2 upload to Debian unstable. Let's see if
> rdma-core builds now on all architectures. Build log overview:
> https://buildd.debian.org/status/package.php?p=rdma-core
>
> In addition, I added myself to MAINTAINERS.
>
> Benjamin Drung (2):
>   debian: Don't install disabled providers on archs that miss coherent
>     DMA
>   Add myself as Debian packaging maintainer
>
>  MAINTAINERS  |  5 +++++
>  debian/rules | 12 ++++++++++++
>  2 files changed, 17 insertions(+)
>

Thanks, merged.

--IPwq7vKbcnUIujWQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloNj3QACgkQ5GN7iDZy
WKcyoQ//dm0/hZhLUWsvAz86FNaTn9DfI5535RU6FTmiWQ9FUIqv4JmwduY416AI
O07voi2X/pD/Skd6PRVyBm3QhlwA8vKUxWWIngPAZj7wgzxzuXCCQWkiERGs7fYv
XfzzzrB4Gyu1reoKmWo8sX2yCKGTyyht2ZlLs6+NuVmJ3YfpIdmrrb5hv28Iw0la
imr1lcvsVHGCTf40KT7ZLtOdutpebM8X6No9YQAw5IMdNA2w/V5txxJuaCvHDoed
+SD6MUXvNunH11HO8LLr/Z2YMO6vWy1y1qD8BnZWbJcuqiuSXJiuXk1URrWczUNA
Xwb45l20zsXUMNHdo0ntOxuSrZV2AgGP+Ebad7TcXXYUkVaCkbddUczzTaP8WWqr
lFqIn0Ivtd+rOfErQy8NR36P8zMKP9pG8slxX7qkkdwnl+F2uftO3w/nSQxGic43
PulxYdnUWcPmddB79dProo4rvZmu4Nc1iJaHGm9D/izI6SjI4sxmsbtwOPIYhvAC
6sVBLhJyIM3QMeHuAi3VhD1ONVX4dUTW+wq6J3HlQowzfkOUiJUoXAgJ+qCOMcj6
1j0orV6KH1ZAfh5XBl1jnVNOKXXLVwxxBTr3SsNupxQxxu1DkfYuy/cNpox9s8lb
RXSs9xaP/+Frzkfo4n3UHbreZ3Re1AjnnTqoLQvrT+PfJrnwNb0=
=B6zj
-----END PGP SIGNATURE-----

--IPwq7vKbcnUIujWQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
