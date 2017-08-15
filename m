From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] rdma: Autoload netlink client modules
Date: Tue, 15 Aug 2017 12:56:51 +0300
Message-ID: <20170815095651.GQ24282@mtr-leonro.local>
References: <1502744259-16966-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1502744259-16966-3-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0rEjiS+nMGFQ7Kkj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502744259-16966-3-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--0rEjiS+nMGFQ7Kkj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 14, 2017 at 02:57:39PM -0600, Jason Gunthorpe wrote:
> If a message comes in and we do not have the client in the table, then
> try to load the module supplying that client using MODULE_ALIAS to find
> it.
>
> This duplicates the scheme seen in other netlink muxes (eg nfnetlink).
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  drivers/infiniband/core/cma.c     |  2 ++
>  drivers/infiniband/core/device.c  |  2 ++
>  drivers/infiniband/core/iwcm.c    |  2 ++
>  drivers/infiniband/core/netlink.c |  9 +++++++++
>  drivers/infiniband/core/nldev.c   |  3 +++
>  include/rdma/rdma_netlink.h       | 12 ++++++++++++
>  6 files changed, 30 insertions(+)
>
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index d8edd8b11561ae..b76de2e2b20950 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -4537,5 +4537,7 @@ static void __exit cma_cleanup(void)
>  	destroy_workqueue(cma_wq);
>  }
>
> +MODULE_ALIAS_RDMA_NETLINK(RDMA_NL_RDMA_CM, 1);
> +
>  module_init(cma_init);
>  module_exit(cma_cleanup);
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index fbc92c649be85d..5f9d4ae5eda8eb 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -1251,5 +1251,7 @@ static void __exit ib_core_cleanup(void)
>  	destroy_workqueue(ib_wq);
>  }
>
> +MODULE_ALIAS_RDMA_NETLINK(RDMA_NL_LS, 4);
> +
>  module_init(ib_core_init);
>  module_exit(ib_core_cleanup);
> diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
> index 452a3115e3e6ba..af6015a7a8f361 100644
> --- a/drivers/infiniband/core/iwcm.c
> +++ b/drivers/infiniband/core/iwcm.c
> @@ -1200,5 +1200,7 @@ static void __exit iw_cm_cleanup(void)
>  	iwpm_exit(RDMA_NL_IWCM);
>  }
>
> +MODULE_ALIAS_RDMA_NETLINK(RDMA_NL_IWCM, 2);
> +
>  module_init(iw_cm_init);
>  module_exit(iw_cm_cleanup);
> diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
> index f782697cf4d819..e685148dd3e6c2 100644
> --- a/drivers/infiniband/core/netlink.c
> +++ b/drivers/infiniband/core/netlink.c
> @@ -84,6 +84,15 @@ static bool is_nl_valid(unsigned int type, unsigned int op)
>  		return false;
>
>  	cb_table = rdma_nl_types[type].cb_table;
> +#ifdef CONFIG_MODULES
> +	if (!cb_table) {
> +		mutex_unlock(&rdma_nl_mutex);
> +		request_module("rdma-netlink-subsys-%d", type);
> +		mutex_lock(&rdma_nl_mutex);
> +		cb_table = rdma_nl_types[type].cb_table;
> +	}
> +#endif
> +
>  	if (!cb_table || (!cb_table[op].dump && !cb_table[op].doit))
>  		return false;
>  	return true;
> diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
> index 474022274e09cd..3ba24c428c3bda 100644
> --- a/drivers/infiniband/core/nldev.c
> +++ b/drivers/infiniband/core/nldev.c
> @@ -30,6 +30,7 @@
>   * POSSIBILITY OF SUCH DAMAGE.
>   */
>
> +#include <linux/module.h>
>  #include <net/netlink.h>
>  #include <rdma/rdma_netlink.h>
>
> @@ -320,3 +321,5 @@ void __exit nldev_exit(void)
>  {
>  	rdma_nl_unregister(RDMA_NL_NLDEV);
>  }
> +
> +MODULE_ALIAS_RDMA_NETLINK(RDMA_NL_NLDEV, 5);
> diff --git a/include/rdma/rdma_netlink.h b/include/rdma/rdma_netlink.h
> index e25bf1988846df..2d878596b1e07a 100644
> --- a/include/rdma/rdma_netlink.h
> +++ b/include/rdma/rdma_netlink.h
> @@ -17,6 +17,18 @@ enum rdma_nl_flags {
>  	RDMA_NL_ADMIN_PERM	= 1 << 0,
>  };
>
> +/* Define this module as providing netlink services for NETLINK_RDMA, with
> + * index _index.  Since the client indexes were setup in a uapi header as an
> + * enum and we do no want to change that, the user must supply the expanded
> + * constant as well and the compiler checks they are the same.
> + */
> +#define MODULE_ALIAS_RDMA_NETLINK(_index, _val)                                \
> +	static inline void __chk_##_index(void)                                \
> +	{                                                                      \
> +		BUILD_BUG_ON(_index != _val);                                  \
> +	}                                                                      \
> +	MODULE_ALIAS("rdma-netlink-subsys-" __stringify(_val))
> +

Can it be something like that (untested)?
#define MODULE_ALIAS_RDMA_NETLINK(_index)                                \
	{ \
		char str[32];\
		strncpy(str, 32, "rdma-netlink-subsys-%d", __index);\
		MODULE_ALIAS(str)\
	}


>  /**
>   * Register client in RDMA netlink.
>   * @index: Index of the added client
> --
> 2.7.4
>

--0rEjiS+nMGFQ7Kkj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmSxWMACgkQ5GN7iDZy
WKevrQ//Xo/68LHzrjlTVNOa5Vr3W1TOn6iiuBq4mkjLePZHds3Xb2BDuk7r8ZLx
9gVJjc65IHgvPHgzm+zHs9JHGjzb634RJ5utitH92GDcK/hg3zQAR+14ftDy4oTq
vonAljDZ0pLaTkG0miogFX6ns/dSsGw9VRE2kH4kYwFuJQA2B7Rw6F/tNMiWcL71
9yhuqPt/LZ/3CgWhRYxO0flYGM78HtfBLYoZpS4Pis8fxaCWmLnVHHqELqz++h/N
WtmdUEu7ityl6o3zd15+NP6YnPvgkPXuKhlkj/tTZGxObDvnmDlkDlv7cJJXE0mW
BRKTmuONJydZvPLjNU8LmfKEBjMnxCvNZ9ayBcIJGmZtyzCBl4r3eRe0X81UimlQ
u/xmXpFpeJZOhGLz2qfjBKHSD/MYGG1dzuRxmYofJ1gJG9BdGtiXj/lZ3ZA1vbl9
Bsp4YfVP5KUyCIaPLeNVWPc1rRQMEtqO7GfHRJ2aoVUweUGHr8BlmbSoB7f1F48G
V1j6HfpMy5HMyc+KYrxlrxCAfJ0fVVeGZfsSWdBv2gCK+55U4Mzz/kmgc11/dT2R
nLsLpxIdXukLA0wkdPiVvdAF2Bh24q40Qy/Mep+vbDY43NSZqcWPkEAPBMz15N5z
SR8ZVNI1IRtv3CeiRQHbXbLvZ9sbRbDuHbS5jqX6mg6wHfZDEbY=
=LLPp
-----END PGP SIGNATURE-----

--0rEjiS+nMGFQ7Kkj--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
