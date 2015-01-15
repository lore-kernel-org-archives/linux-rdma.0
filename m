From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 16/20] IB/mad: Add Intel Omni-Path Architecture defines
Date: Thu, 15 Jan 2015 09:10:22 -0500
Message-ID: <54B7CA4E.5050809@dev.mellanox.co.il>
References: <1421082672-22588-1-git-send-email-ira.weiny@intel.com> <1421082672-22588-17-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1421082672-22588-17-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 1/12/2015 12:11 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> OPA_MIN_CLASS_VERSION -- OPA Class versions are > 0x80
> OPA_SMP_CLASS_VERSION -- Defined at 0x80
> OPA_MGMT_BASE_VERSION -- Defined at 0x80
>=20
> Increase max management version to accommodate OPA

Allocation of MAD base and class version numbers is owned by the IBTA.
It doesn=92t seem appropriate to arbitrarily claim code points without
proper approval.

-- Hal

>=20
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/core/mad_priv.h |    4 +++-
>  include/rdma/ib_mad.h              |    5 ++++-
>  2 files changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/=
core/mad_priv.h
> index d71ddcc..a7041b0 100644
> --- a/drivers/infiniband/core/mad_priv.h
> +++ b/drivers/infiniband/core/mad_priv.h
> @@ -56,11 +56,13 @@
> =20
>  /* Registration table sizes */
>  #define MAX_MGMT_CLASS		80
> -#define MAX_MGMT_VERSION	8
> +#define MAX_MGMT_VERSION	0x83
>  #define MAX_MGMT_OUI		8
>  #define MAX_MGMT_VENDOR_RANGE2	(IB_MGMT_CLASS_VENDOR_RANGE2_END - \
>  				IB_MGMT_CLASS_VENDOR_RANGE2_START + 1)
> =20
> +#define OPA_MIN_CLASS_VERSION	0x80
> +
>  struct ib_mad_list_head {
>  	struct list_head list;
>  	struct ib_mad_queue *mad_queue;
> diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
> index 80e7cf4..8938f1e 100644
> --- a/include/rdma/ib_mad.h
> +++ b/include/rdma/ib_mad.h
> @@ -42,8 +42,11 @@
>  #include <rdma/ib_verbs.h>
>  #include <uapi/rdma/ib_user_mad.h>
> =20
> -/* Management base version */
> +/* Management base versions */
>  #define IB_MGMT_BASE_VERSION			1
> +#define OPA_MGMT_BASE_VERSION			0x80
> +
> +#define OPA_SMP_CLASS_VERSION			0x80
> =20
>  /* Management classes */
>  #define IB_MGMT_CLASS_SUBN_LID_ROUTED		0x01

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
