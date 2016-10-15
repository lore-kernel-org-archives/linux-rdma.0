From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] Enable -Wstrict-prototypes
Date: Sat, 15 Oct 2016 12:45:27 +0300
Message-ID: <20161015094527.GL9282@leon.nu>
References: <1476418211-6277-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="n8d7KAgWmJ23Ts4y"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1476418211-6277-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--n8d7KAgWmJ23Ts4y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 13, 2016 at 10:10:10PM -0600, Jason Gunthorpe wrote:
> All bad cases are fixed now. This is useful to detect non-ISO
> function signatures which use surprising and counter intuitive
> rules.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Thanks, applied

> ---
>  CMakeLists.txt                      | 7 +++++++
>  ibacm/src/acm.c                     | 2 +-
>  ibacm/src/acme.c                    | 2 +-
>  ibacm/src/libacm.h                  | 2 +-
>  libibverbs/examples/xsrq_pingpong.c | 4 ++--
>  librdmacm/cma.h                     | 4 ++--
>  6 files changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/CMakeLists.txt b/CMakeLists.txt
> index 4d291d2c3fb7..1fb634c43991 100644
> --- a/CMakeLists.txt
> +++ b/CMakeLists.txt
> @@ -246,6 +246,13 @@ if (NOT LIBC_HAS_LIBRT)
>  endif()
>
>  #-------------------------
> +# Final warning flags
> +
> +# Old version of cmake used 'main(){..}' as their test program which breaks with -Werror.
> +# So set this flag last.
> +RDMA_AddOptCFlag(CMAKE_C_FLAGS HAVE_C_WSTRICT_PROTOTYPES "-Wstrict-prototypes")
> +
> +#-------------------------
>  # Build Prep
>  # Write out a git ignore file to the build directory if it isn't the source
>  # directory. For developer convenience
> diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
> index 146fbff61857..9186677fcc6f 100644
> --- a/ibacm/src/acm.c
> +++ b/ibacm/src/acm.c
> @@ -2421,7 +2421,7 @@ static void acm_event_handler(struct acmc_device *dev)
>  	ibv_ack_async_event(&event);
>  }
>
> -static void acm_activate_devices()
> +static void acm_activate_devices(void)
>  {
>  	struct acmc_device *dev;
>  	DLIST_ENTRY *dev_entry;
> diff --git a/ibacm/src/acme.c b/ibacm/src/acme.c
> index e96d36ff9fc0..2bce0da4ec8a 100644
> --- a/ibacm/src/acme.c
> +++ b/ibacm/src/acme.c
> @@ -512,7 +512,7 @@ static void show_path(struct ibv_path_record *path)
>  	printf("  packet lifetime: %d\n", path->packetlifetime & 0x1F);
>  }
>
> -static uint32_t get_resolve_flags()
> +static uint32_t get_resolve_flags(void)
>  {
>  	uint32_t flags = 0;
>
> diff --git a/ibacm/src/libacm.h b/ibacm/src/libacm.h
> index 359a6af3bb29..4ef2859fa9d6 100644
> --- a/ibacm/src/libacm.h
> +++ b/ibacm/src/libacm.h
> @@ -34,7 +34,7 @@
>  #include <infiniband/acm.h>
>
>  int ib_acm_connect(char *dest_svc);
> -void ib_acm_disconnect();
> +void ib_acm_disconnect(void);
>
>  int ib_acm_resolve_name(char *src, char *dest,
>  	struct ibv_path_data **paths, int *count, uint32_t flags,
> diff --git a/libibverbs/examples/xsrq_pingpong.c b/libibverbs/examples/xsrq_pingpong.c
> index c22893e0e721..b90f0eb7e27f 100644
> --- a/libibverbs/examples/xsrq_pingpong.c
> +++ b/libibverbs/examples/xsrq_pingpong.c
> @@ -354,7 +354,7 @@ static int send_termination_ack(int index)
>  	return 0;
>  }
>
> -static int pp_client_termination()
> +static int pp_client_termination(void)
>  {
>  	if (send_termination_ack(0))
>  		return 1;
> @@ -364,7 +364,7 @@ static int pp_client_termination()
>  	return 0;
>  }
>
> -static int pp_server_termination()
> +static int pp_server_termination(void)
>  {
>  	int i;
>
> diff --git a/librdmacm/cma.h b/librdmacm/cma.h
> index c2f603d6f439..1610e178dfdb 100644
> --- a/librdmacm/cma.h
> +++ b/librdmacm/cma.h
> @@ -138,8 +138,8 @@ extern int af_ib_support;
>
>  #define RAI_ROUTEONLY		0x01000000
>
> -void ucma_ib_init();
> -void ucma_ib_cleanup();
> +void ucma_ib_init(void);
> +void ucma_ib_cleanup(void);
>  void ucma_ib_resolve(struct rdma_addrinfo **rai, struct rdma_addrinfo *hints);
>
>  struct ib_connect_hdr {
> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--n8d7KAgWmJ23Ts4y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYAfq3AAoJEORje4g2clindn4P/3cphX02LWIGU92Vh9NX+i9d
pWTui0SxYRPDEEPAR61/pE6AO5qEcfoe1SADoGYeaWuyQiXN+HYdQ1NRAc5rey8V
bManKtU5LPp20a2KFPbMJyb3mxVW7SV85LKk3zNmCVysra1siJLE0U3faCyMHnX3
NHUNT9Rvpxcul3xtbuzssMVe8weW+1XE3H2ul2D6YxhU62cAibb2Grbhq0vq5WMf
zAh3qB4aG5WPhi5snj0NSD9BazUUj++6jwdIqoUlLaqh2XpdD3wg7GvkCKcPomJE
+ERzy+NviShiZv+xAYU7el8OVjGkdEcihoZOAyLYahOAjLajqPBMKuIZ5lslEiBW
4E9D7blpyllzGCG7kW4rSVnOmaj1DkJkBSzpqQLOXirAZG6mFhJcO2CD28uy3pjC
voEbwaOKvDpS0oVmTne7GB+Mcb5F9k53osLVtt9Q0sEZECnrNddiCwaZuSa0VgY0
03b7FsJ2NeDvJ1YqWg3RJ/ObbfdVAwKyPvVO5SU6s72A39TKIb7wuew4awo934zy
LZo9C+rqPmFQMhLJVi6DM55BOsAl3fQpN3LSrGeeHVb7Fo2WpVbxL0bsAk06ibfv
8BfJiaRya+yoEbDjKFENddLVZT6urezv6rNsEHIF7dTBiqU4QduMI9wl/UKL0D7e
5gvoXkZ+QD+W8YwyJSjT
=RPSy
-----END PGP SIGNATURE-----

--n8d7KAgWmJ23Ts4y--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
