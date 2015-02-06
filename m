From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v4 14/19] IB/core: Add IB_DEVICE_OPA_MAD_SUPPORT device
 cap flag
Date: Fri, 06 Feb 2015 15:35:21 -0500
Message-ID: <54D52589.8020305@dev.mellanox.co.il>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com> <1423092585-26692-15-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423092585-26692-15-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/4/2015 6:29 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> OPA MADs share a common header with IBTA MADs but with a different ba=
se version
> and an extended length.  These "jumbo" MADs increase the performance =
of
> management traffic.
>=20
> Sharing a common header with IBTA MADs allows us to share most of the=
 MAD
> processing code when dealing with OPA MADs in addition to supporting =
some IBTA
> MADs on OPA devices.
>=20
> Add a device capability flag to indicate OPA MAD support on the devic=
e.
>=20
> Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
> ---
>  include/rdma/ib_verbs.h | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 3ab4033..2614233 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -128,6 +128,10 @@ enum ib_device_cap_flags {
>  	IB_DEVICE_ON_DEMAND_PAGING	=3D (1<<31),
>  };
> =20
> +enum ib_device_cap_flags2 {
> +	IB_DEVICE_OPA_MAD_SUPPORT	=3D 1
> +};
> +
>  enum ib_signature_prot_cap {
>  	IB_PROT_T10DIF_TYPE_1 =3D 1,
>  	IB_PROT_T10DIF_TYPE_2 =3D 1 << 1,
> @@ -210,6 +214,7 @@ struct ib_device_attr {
>  	int			sig_prot_cap;
>  	int			sig_guard_cap;
>  	struct ib_odp_caps	odp_caps;
> +	u64			device_cap_flags2;
>  	u32			max_mad_size;
>  };
> =20

Why is OPA support determined via a device capability flag ? What are
the tradeoffs for doing it this way versus the other choices that have
been used in the past for other RDMA technologies like RoCE, iWARP,
usNIC, =85 ?

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
