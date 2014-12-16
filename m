From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 07/17] IB/core: Add flags for on demand paging support
Date: Tue, 16 Dec 2014 13:02:58 +0100
Message-ID: <1418731378.2779.6.camel@opteya.com>
References: <1418310266-9584-1-git-send-email-haggaie@mellanox.com>
	 <1418310266-9584-8-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418310266-9584-8-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jerome Glisse <j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le jeudi 11 d=C3=A9cembre 2014 =C3=A0 17:04 +0200, Haggai Eran a =C3=A9=
crit :
> From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> * Add a configuration option for enable on-demand paging support in t=
he
>   infiniband subsystem (CONFIG_INFINIBAND_ON_DEMAND_PAGING). In a lat=
er patch,
>   this configuration option will select the MMU_NOTIFIER configuratio=
n option
>   to enable mmu notifiers.
> * Add a flag for on demand paging (ODP) support in the IB device capa=
bilities.
> * Add a flag to request ODP MR in the access flags to reg_mr.
> * Fail registrations done with the ODP flag when the low-level driver=
 doesn't
>   support this.
> * Change the conditions in which an MR will be writable to explicitly
>   specify the access flags. This is to avoid making an MR writable ju=
st
>   because it is an ODP MR.
> * Add a ODP capabilities to the extended query device verb.
>=20
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/Kconfig           | 10 ++++++++++
>  drivers/infiniband/core/umem.c       |  8 +++++---
>  drivers/infiniband/core/uverbs_cmd.c | 25 +++++++++++++++++++++++++
>  include/rdma/ib_verbs.h              | 28 ++++++++++++++++++++++++++=
--
>  include/uapi/rdma/ib_user_verbs.h    | 15 +++++++++++++++
>  5 files changed, 81 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
> index 77089399359b..089a2c2af329 100644
> --- a/drivers/infiniband/Kconfig
> +++ b/drivers/infiniband/Kconfig
> @@ -38,6 +38,16 @@ config INFINIBAND_USER_MEM
>  	depends on INFINIBAND_USER_ACCESS !=3D n
>  	default y
> =20
> +config INFINIBAND_ON_DEMAND_PAGING
> +	bool "InfiniBand on-demand paging support"
> +	depends on INFINIBAND_USER_MEM
> +	default y
> +	---help---
> +	  On demand paging support for the InfiniBand subsystem.
> +	  Together with driver support this allows registration of
> +	  memory regions without pinning their pages, fetching the
> +	  pages on demand instead.
> +
>  config INFINIBAND_ADDR_TRANS
>  	bool
>  	depends on INFINIBAND
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core=
/umem.c
> index 6f152628e0d2..c328e4693d14 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -107,13 +107,15 @@ struct ib_umem *ib_umem_get(struct ib_ucontext =
*context, unsigned long addr,
>  	umem->page_size =3D PAGE_SIZE;
>  	umem->pid       =3D get_task_pid(current, PIDTYPE_PID);
>  	/*
> -	 * We ask for writable memory if any access flags other than
> -	 * "remote read" are set.  "Local write" and "remote write"
> +	 * We ask for writable memory if any of the following
> +	 * access flags are set.  "Local write" and "remote write"
>  	 * obviously require write access.  "Remote atomic" can do
>  	 * things like fetch and add, which will modify memory, and
>  	 * "MW bind" can change permissions by binding a window.
>  	 */
> -	umem->writable  =3D !!(access & ~IB_ACCESS_REMOTE_READ);
> +	umem->writable  =3D !!(access &
> +		(IB_ACCESS_LOCAL_WRITE   | IB_ACCESS_REMOTE_WRITE |
> +		 IB_ACCESS_REMOTE_ATOMIC | IB_ACCESS_MW_BIND));
> =20
>  	/* We assume the memory is from hugetlb until proved otherwise */
>  	umem->hugetlb   =3D 1;
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniban=
d/core/uverbs_cmd.c
> index c7a43624c96b..f9326ccda4b5 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -953,6 +953,18 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *=
file,
>  		goto err_free;
>  	}
> =20
> +	if (cmd.access_flags & IB_ACCESS_ON_DEMAND) {
> +		struct ib_device_attr attr;
> +
> +		ret =3D ib_query_device(pd->device, &attr);
> +		if (ret || !(attr.device_cap_flags &
> +				IB_DEVICE_ON_DEMAND_PAGING)) {
> +			pr_debug("ODP support not available\n");
> +			ret =3D -EINVAL;
> +			goto err_put;
> +		}
> +	}
> +
>  	mr =3D pd->device->reg_user_mr(pd, cmd.start, cmd.length, cmd.hca_v=
a,
>  				     cmd.access_flags, &udata);
>  	if (IS_ERR(mr)) {
> @@ -3289,6 +3301,19 @@ int ib_uverbs_ex_query_device(struct ib_uverbs=
_file *file,
>  	copy_query_dev_fields(file, &resp.base, &attr);
>  	resp.comp_mask =3D 0;
> =20
> +#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> +	if (cmd.comp_mask & IB_USER_VERBS_EX_QUERY_DEVICE_ODP) {
> +		resp.odp_caps.general_caps =3D attr.odp_caps.general_caps;
> +		resp.odp_caps.per_transport_caps.rc_odp_caps =3D
> +			attr.odp_caps.per_transport_caps.rc_odp_caps;
> +		resp.odp_caps.per_transport_caps.uc_odp_caps =3D
> +			attr.odp_caps.per_transport_caps.uc_odp_caps;
> +		resp.odp_caps.per_transport_caps.ud_odp_caps =3D
> +			attr.odp_caps.per_transport_caps.ud_odp_caps;
> +		resp.comp_mask |=3D IB_USER_VERBS_EX_QUERY_DEVICE_ODP;
> +	}

You need to clear the tail of the response otherwise, kernel will leak
stack content to userspace:

+ #else /* !CONFIG_INFINIBAND_ON_DEMAND_PAGING */
+	resp.odp_caps.general_caps =3D 0;
+	resp.odp_caps.per_transport_caps.rc_odp_caps =3D 0;
+	resp.odp_caps.per_transport_caps.uc_odp_caps =3D 0;
+	resp.odp_caps.per_transport_caps.ud_odp_caps =3D 0;
 =09
> +#endif
> +

+	resp.odp_caps.reserved =3D 0

>  	err =3D ib_copy_to_udata(ucore, &resp, sizeof(resp));
>  	if (err)
>  		return err;
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 97a999f9e4d8..a41bc5a39ebf 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -123,7 +123,8 @@ enum ib_device_cap_flags {
>  	IB_DEVICE_MEM_WINDOW_TYPE_2A	=3D (1<<23),
>  	IB_DEVICE_MEM_WINDOW_TYPE_2B	=3D (1<<24),
>  	IB_DEVICE_MANAGED_FLOW_STEERING =3D (1<<29),
> -	IB_DEVICE_SIGNATURE_HANDOVER	=3D (1<<30)
> +	IB_DEVICE_SIGNATURE_HANDOVER	=3D (1<<30),
> +	IB_DEVICE_ON_DEMAND_PAGING	=3D (1<<31),
>  };
> =20
>  enum ib_signature_prot_cap {
> @@ -143,6 +144,27 @@ enum ib_atomic_cap {
>  	IB_ATOMIC_GLOB
>  };
> =20
> +enum ib_odp_general_cap_bits {
> +	IB_ODP_SUPPORT =3D 1 << 0,
> +};
> +
> +enum ib_odp_transport_cap_bits {
> +	IB_ODP_SUPPORT_SEND	=3D 1 << 0,
> +	IB_ODP_SUPPORT_RECV	=3D 1 << 1,
> +	IB_ODP_SUPPORT_WRITE	=3D 1 << 2,
> +	IB_ODP_SUPPORT_READ	=3D 1 << 3,
> +	IB_ODP_SUPPORT_ATOMIC	=3D 1 << 4,
> +};
> +
> +struct ib_odp_caps {
> +	uint64_t general_caps;
> +	struct {
> +		uint32_t  rc_odp_caps;
> +		uint32_t  uc_odp_caps;
> +		uint32_t  ud_odp_caps;
> +	} per_transport_caps;
> +};
> +
>  struct ib_device_attr {
>  	u64			fw_ver;
>  	__be64			sys_image_guid;
> @@ -186,6 +208,7 @@ struct ib_device_attr {
>  	u8			local_ca_ack_delay;
>  	int			sig_prot_cap;
>  	int			sig_guard_cap;
> +	struct ib_odp_caps	odp_caps;
>  };
> =20
>  enum ib_mtu {
> @@ -1073,7 +1096,8 @@ enum ib_access_flags {
>  	IB_ACCESS_REMOTE_READ	=3D (1<<2),
>  	IB_ACCESS_REMOTE_ATOMIC	=3D (1<<3),
>  	IB_ACCESS_MW_BIND	=3D (1<<4),
> -	IB_ZERO_BASED		=3D (1<<5)
> +	IB_ZERO_BASED		=3D (1<<5),
> +	IB_ACCESS_ON_DEMAND     =3D (1<<6),
>  };
> =20
>  struct ib_phys_buf {
> diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib=
_user_verbs.h
> index e8a96071e352..4275b961bf60 100644
> --- a/include/uapi/rdma/ib_user_verbs.h
> +++ b/include/uapi/rdma/ib_user_verbs.h
> @@ -202,15 +202,30 @@ struct ib_uverbs_query_device_resp {
>  	__u8  reserved[4];
>  };
> =20
> +enum {
> +	IB_USER_VERBS_EX_QUERY_DEVICE_ODP =3D		1ULL << 0,
> +};
> +
>  struct ib_uverbs_ex_query_device {
>  	__u32 comp_mask;
>  	__u32 reserved;
>  };
> =20
> +struct ib_uverbs_odp_caps {
> +	__u64 general_caps;
> +	struct {
> +		__u32 rc_odp_caps;
> +		__u32 uc_odp_caps;
> +		__u32 ud_odp_caps;
> +	} per_transport_caps;
> +	__u32 reserved;
> +};
> +
>  struct ib_uverbs_ex_query_device_resp {
>  	struct ib_uverbs_query_device_resp base;
>  	__u32 comp_mask;
>  	__u32 reserved;
> +	struct ib_uverbs_odp_caps odp_caps;
>  };

Hopefully, no kernel was released with ib_uverbs_ex_query_device_resp
without odp_caps (eg. in between '[PATCH v3 06/17] IB/core: Add support
for extended query device caps' and this one, or=20
ib_uverbs_ex_query_device() should have been modified
to handle shorter ib_uverbs_ex_query_device_resp to accomodate the ABI
variations.

> =20
>  struct ib_uverbs_query_port {

Regards.

--=20
Yann Droneaud


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
