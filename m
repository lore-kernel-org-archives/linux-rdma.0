From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] ibacm: Add systemd service file
Date: Sun, 16 Jul 2017 18:20:13 +0300
Message-ID: <20170716152013.GC15371@mtr-leonro.local>
References: <20170714132604.4629-1-benjamin.drung@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eRtJSFbw+EEWtPj3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170714132604.4629-1-benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--eRtJSFbw+EEWtPj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 14, 2017 at 03:26:04PM +0200, Benjamin Drung wrote:
> ibacm ships only a sysvinit script but no corresponding systemd unit
> file. The RedHat package ships its own systemd unit file. Thus make it
> available to all.
>
> Signed-off-by: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
> ---
>  debian/ibacm.install                           | 1 +
>  ibacm/CMakeLists.txt                           | 5 +++++
>  redhat/ibacm.service => ibacm/ibacm.service.in | 4 ++--
>  redhat/rdma-core.spec                          | 1 -
>  4 files changed, 8 insertions(+), 3 deletions(-)
>  rename redhat/ibacm.service => ibacm/ibacm.service.in (63%)
>
> diff --git a/debian/ibacm.install b/debian/ibacm.install
> index c8be4a6f..41cf5bad 100644
> --- a/debian/ibacm.install
> +++ b/debian/ibacm.install
> @@ -1,4 +1,5 @@
>  etc/init.d/ibacm
> +lib/systemd/system/ibacm.service
>  usr/bin/ib_acme
>  usr/include/infiniband/acm.h
>  usr/include/infiniband/acm_prov.h
> diff --git a/ibacm/CMakeLists.txt b/ibacm/CMakeLists.txt
> index 7eba294b..5e3ea5e2 100644
> --- a/ibacm/CMakeLists.txt
> +++ b/ibacm/CMakeLists.txt
> @@ -64,3 +64,8 @@ rdma_subst_install(FILES "ibacm.init.in"
>    DESTINATION "${CMAKE_INSTALL_INITDDIR}"
>    RENAME "ibacm"
>    PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ OWNER_EXECUTE GROUP_EXECUTE WORLD_EXECUTE)
> +
> +rdma_subst_install(FILES "ibacm.service.in"
> +  DESTINATION "${CMAKE_INSTALL_SYSTEMD_SERVICEDIR}"
> +  RENAME ibacm.service
> +  PERMISSIONS OWNER_WRITE OWNER_READ GROUP_READ WORLD_READ)
> diff --git a/redhat/ibacm.service b/ibacm/ibacm.service.in
> similarity index 63%
> rename from redhat/ibacm.service
> rename to ibacm/ibacm.service.in
> index bb28928c..3879dc45 100644
> --- a/redhat/ibacm.service
> +++ b/ibacm/ibacm.service.in
> @@ -1,12 +1,12 @@
>  [Unit]
>  Description=Starts the InfiniBand Address Cache Manager daemon
> -Documentation=man:ibacm file:/etc/rdma/ibacm_opts.cfg
> +Documentation=man:ibacm file:@CMAKE_INSTALL_SYSCONFDIR@/rdma/ibacm_opts.cfg

Jason's comment on github:
"We don't have rdma.service in rdma-core, that is a redhat specific target.. It should be stripped out before moving.."

Please resubmit.

Thanks

--eRtJSFbw+EEWtPj3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllrhC0ACgkQ5GN7iDZy
WKeTNBAAnNuWyyv4k+PK75aMn1D46anz3b3SHLR9Z1Y835UQOPvEaFJVHel8P0Lk
TeGfAaopYpOo/DiBHRw9UOEDBPTIlv0TcHB1LJ9dTKwb5/YjaDgGNoKefzIMseRS
39qQAWFaUyn2KpNpMeqwJ4vdPSxlFohkdiHicgwqP694PUNp0H27ZlmpiTcLfy36
HcMlXkUFwP31fP5Z8/svhpXhGvfNX+ZU3hWI/6m8vI/FDKg+j5nPBaSrUzRS9CeT
JVz8Pbjjmq4R1QQxWV9OiaiAhVgl2T9uUH14zsJQCzGi7FHdABkRtBWLvgFt7jTw
GspVVNq15grnw+lPSatcYVr361FhMzzSGaESncZehg2ro74kd6m8Ds0lwB+GWXiB
KVgCHD2nykb1pePhf1XE+DeAAo3T0JzeNw4oqPSt1GoBELXtxmooRfSoI7nrwy6V
RUVnnyI3vd/7rItqA8oqqJwg+KbISG+05FA93Zd3oByw0MFbnk1AOUys2OmrN0aj
8rPHWVNMmcxh0BCHrI5ZWutQczd4Q0bKljtWknCgMCxSp8z6dDM4PXZfUcnYo8SJ
WQLPHzC9BloOda0Yt0KvVM5fi+AQvsy2n6vlhOPaYNDVB8JES4bjYoOzjo6YRY35
qrAm2UP6TYAc5OMXL8Q8H9AkEnFo6NVB95s63Zr7puWpyyjtpn4=
=OaBO
-----END PGP SIGNATURE-----

--eRtJSFbw+EEWtPj3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
