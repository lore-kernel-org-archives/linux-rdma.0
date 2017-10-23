From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 3/7] IB/hfi1: Validate PKEY for incoming GSI MAD
 packets
Date: Mon, 23 Oct 2017 21:38:48 +0300
Message-ID: <20171023183848.GC16127@mtr-leonro.local>
References: <20171023125327.21191.31462.stgit@scvm10.sc.intel.com>
 <20171023130558.21191.30808.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Pk6IbRAofICFmK5e"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171023130558.21191.30808.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Pk6IbRAofICFmK5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 23, 2017 at 06:06:00AM -0700, Dennis Dalessandro wrote:
> From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> These are the use-cases where the pkey needs to be tested to see
> if a packet needs to be dropped.
>
> a) Check if pkey is not FULL_MGMT_P_KEY or LIM_MGMT_P_KEY,
>    drop the packet as it's not part of the management partition.
>    Self-originated packets are an exception.
>
> b) If pkey index points to FULL_MGMT_P_KEY and LIM_MGMT_P_KEY is
>    in the table, the packet is coming from a management node,
>    and the receiving node is also a management node, so it is safe
>    for the packet to go through.
>
> c) If pkey index points to FULL_MGMT_P_KEY and LIM_MGMT_P_KEY is
>    NOT in the table, drop the packet as LIM_MGMT_P_KEY should
>    always be in the pkey table. It could be a misconfiguration.
>
> d) If pkey index points to LIM_MGMT_P_KEY and FULL_MGMT_P_KEY is
>    NOT in the table, it is safe for the packet to go through
>    since a non-management node is talking to another non-managment
>    node.
>
> e) If pkey index points to LIM_MGMT_P_KEY and FULL_MGMT_P_KEY is in
>    the table, drop the packet because a non-management node is
>    talking to a management node, and it could be an attack.
>
> For the implementation, these rules can be simplied to only checking
> for (a) and (e). There's no need to check for rule (b) as
> the packet doesn't need to be dropped. Rule (c) is not possible in
> the driver as LIM_MGMT_P_KEY is always in the pkey table.
>
> Reviewed-by: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/mad.c |   86 +++++++++++++++++++++++++++++++++++++-
>  1 files changed, 84 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/hfi1/mad.c b/drivers/infiniband/hw/hfi1/mad.c
> index 07b80fa..dfe6224 100644
> --- a/drivers/infiniband/hw/hfi1/mad.c
> +++ b/drivers/infiniband/hw/hfi1/mad.c
> @@ -98,6 +98,16 @@ static inline void clear_opa_smp_data(struct opa_smp *smp)
>  	memset(data, 0, size);
>  }
>
> +static inline u16 hfi1_lookup_pkey_value(struct hfi1_ibport *ibp, int pkey_idx)

Please, no "inline-function" in *.c files as it is written in CodingStyle.

Thanks

--Pk6IbRAofICFmK5e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnuNzcACgkQ5GN7iDZy
WKdrIg//WuBvL/LntTYi9/A1ACLfCQo3X3k8hI+cLDj+DxlSFKf2Q3yEyJhX/vvB
PnISoAa/zmpM1Ae5ICs6+Jf9wZ9tY7rI3ngYJDmpIvkbOs6J7rLf/v7JQjkKxCyi
xqK6AFItNaqBtKjHks+PemK2cdGFZnVe7Kp15qIWoIUXc6UM4KO0x2OLQV78FrUL
gxqCf4wJAuGBeatV48EdDRHemodwNx1DUdORJ9z2UTp872jlkai0THGq3C0OjLH2
xnmWC0RBFldAL0JRKli8P8b360U1/uJMgw7D6qT4Z+HVKdITWpSuBZhEnxiGYlU/
E/86BLAZ+kkKpTMcsu/+pIU6/7f8AEySehdJnHzSLeBY55edXRPIH9ItkEr6nMBU
POmLaq3ArglsjEm4wWfw6p/S9vVKwLVX0tFCqRs+u7rnbh8KuvRsYvGOrgenSi/r
j6hSIYsYolIWrUQ/W6S2ONqgh9kCGYXCD3rhqVsLzomhaEl8nhPaHvK+MM1P6JO5
fZIxmUCYGBgzdOwKgLtkiIbnXvn+RCrhNXUN8H6F3usqH82GvIyovqerd3wP6q08
CYfuNM1SArty7mHJIgijSk8enh4OWO+Y8L2qnQH+jK/iXoEv2FXlIiyWO1oB+HXS
1Fa71j3y/g70inAJfOTpenPszycVnwIxZnx698qbe60ga7deMNU=
=VtgB
-----END PGP SIGNATURE-----

--Pk6IbRAofICFmK5e--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
