From: Rajouri Jammu <rajouri.jammu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv8 10/11] ib_core: Add VLAN support to IBoE
Date: Mon, 28 Jun 2010 16:09:00 -0700
Message-ID: <AANLkTimBj5Vg7feSo1dvolFdQazY8wXyQ3fxKc76uW2p@mail.gmail.com>
References: <20100218172443.GK12286@mtls03>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1921585912=="
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <20100218172443.GK12286@mtls03>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Mime-version: 1.0
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--===============1921585912==
Content-Type: multipart/alternative; boundary=0016e6476634c8979a048a1f342c

--0016e6476634c8979a048a1f342c
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Eli,

I'm getting build failure of our kernel module with OFED-1.5.2-rc1.

/usr/src/ofa_kernel/include/rdma/ib_addr.h: In function
=91iboe_addr_get_sgid=92:
/usr/src/ofa_kernel/include/rdma/ib_addr.h:160: error: implicit declaration
of function =91vlan_dev_vlan_id=92

I'm using a standard Redhat EL 5.3 setup.
kernel is 2.6.18-128.7.1.el5

include/linux/autoconf.h has the following defined but the function doesn't
seem to be defined in the kernel.

CONFIG_VLAN_8021Q_MODULE 1

I can work around the problem by hacking
/usr/src/ofa_kernel/include/rdma/ib_addr.h
with undefining the VLAN stuff.

#undef CONFIG_VLAN_8021Q
#undef CONFIG_VLAN_8021Q_MODULE

Any ideas to fix this in a graceful way?

On Thu, Feb 18, 2010 at 10:24 AM, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org> wrote:

> Add 802.1q vlan support to IBoE. The vlan tag is encoded within the GID
> derived from a link local address in the following way:
>
> GID[11] GID[12] contain the vlan ID.
> The 3 bit user priority field is identical to the 3 bits of the SL.
>
> In case rdma_cm apps, the TOS field is used to generate the SL field by
> doing a
> shift right of 5 bits effectively taking to 3 MS bits of the TOS field. I=
n
> order to support userspace verbs consumers, ib_uverbs_get_mac has changed
> into
> ib_uverbs_get_eth_l2_addr and now returns both MAC and VLAN information.
>
> Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
> ---
>  drivers/infiniband/core/cma.c       |   20 ++++++++-----
>  drivers/infiniband/core/ucma.c      |   13 ++++++++-
>  drivers/infiniband/core/ud_header.c |   31 ++++++++++++++++++++-
>  include/rdma/ib_addr.h              |   49
> ++++++++++++++++++++++++++++++++---
>  include/rdma/ib_pack.h              |   19 ++++++-------
>  5 files changed, 106 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.=
c
> index df5f636..108d1bb 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -1763,6 +1763,7 @@ static int cma_resolve_iboe_route(struct
> rdma_id_private *id_priv)
>        struct sockaddr_in *src_addr =3D (struct sockaddr_in
> *)&route->addr.src_addr;
>        struct sockaddr_in *dst_addr =3D (struct sockaddr_in
> *)&route->addr.dst_addr;
>        struct net_device *ndev =3D NULL;
> +       u16 vid;
>
>        if (src_addr->sin_family !=3D dst_addr->sin_family)
>                return -EINVAL;
> @@ -1782,14 +1783,6 @@ static int cma_resolve_iboe_route(struct
> rdma_id_private *id_priv)
>
>        route->num_paths =3D 1;
>
> -       iboe_mac_to_ll(&route->path_rec->sgid,
> addr->dev_addr.src_dev_addr);
> -       iboe_mac_to_ll(&route->path_rec->dgid,
> addr->dev_addr.dst_dev_addr);
> -
> -       route->path_rec->hop_limit =3D 1;
> -       route->path_rec->reversible =3D 1;
> -       route->path_rec->pkey =3D cpu_to_be16(0xffff);
> -       route->path_rec->mtu_selector =3D IB_SA_EQ;
> -
>        if (addr->dev_addr.bound_dev_if)
>                ndev =3D dev_get_by_index(&init_net,
> addr->dev_addr.bound_dev_if);
>        if (!ndev) {
> @@ -1797,6 +1790,17 @@ static int cma_resolve_iboe_route(struct
> rdma_id_private *id_priv)
>                goto err2;
>        }
>
> +       vid =3D rdma_vlan_dev_vlan_id(ndev);
> +
> +       iboe_mac_vlan_to_ll(&route->path_rec->sgid,
> addr->dev_addr.src_dev_addr, vid);
> +       iboe_mac_vlan_to_ll(&route->path_rec->dgid,
> addr->dev_addr.dst_dev_addr, vid);
> +
> +       route->path_rec->hop_limit =3D 1;
> +       route->path_rec->reversible =3D 1;
> +       route->path_rec->pkey =3D cpu_to_be16(0xffff);
> +       route->path_rec->mtu_selector =3D IB_SA_EQ;
> +       route->path_rec->sl =3D id_priv->tos >> 5;
> +
>        route->path_rec->mtu =3D iboe_get_mtu(ndev->mtu);
>        route->path_rec->rate_selector =3D IB_SA_EQ;
>        route->path_rec->rate =3D iboe_get_rate(ndev);
> diff --git a/drivers/infiniband/core/ucma.c
> b/drivers/infiniband/core/ucma.c
> index fcc27bc..ed670f5 100644
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
> @@ -586,13 +586,22 @@ static void ucma_copy_iboe_route(struct
> rdma_ucm_query_route_resp *resp,
>                                 struct rdma_route *route)
>  {
>        struct rdma_dev_addr *dev_addr;
> +       struct net_device *dev;
> +       u16 vid =3D 0;
>
>        resp->num_paths =3D route->num_paths;
>        switch (route->num_paths) {
>        case 0:
>                dev_addr =3D &route->addr.dev_addr;
> -               iboe_mac_to_ll((union ib_gid *) &resp->ib_route[0].dgid,
> -                              dev_addr->dst_dev_addr);
> +               dev =3D dev_get_by_index(&init_net, dev_addr->bound_dev_i=
f);
> +                       if (dev) {
> +                               vid =3D rdma_vlan_dev_vlan_id(dev);
> +                               dev_put(dev);
> +                       }
> +
> +
> +               iboe_mac_vlan_to_ll((union ib_gid *)
> &resp->ib_route[0].dgid,
> +                                   dev_addr->dst_dev_addr, vid);
>                iboe_addr_get_sgid(dev_addr,
>                                   (union ib_gid *)
> &resp->ib_route[0].sgid);
>                resp->ib_route[0].pkey =3D cpu_to_be16(0xffff);
> diff --git a/drivers/infiniband/core/ud_header.c
> b/drivers/infiniband/core/ud_header.c
> index 7650313..7d03cf1 100644
> --- a/drivers/infiniband/core/ud_header.c
> +++ b/drivers/infiniband/core/ud_header.c
> @@ -33,6 +33,7 @@
>
>  #include <linux/errno.h>
>  #include <linux/string.h>
> +#include <linux/if_ether.h>
>
>  #include <rdma/ib_pack.h>
>
> @@ -103,6 +104,17 @@ static const struct ib_field eth_table[]  =3D {
>          .size_bits    =3D 16 }
>  };
>
> +static const struct ib_field vlan_table[]  =3D {
> +       { STRUCT_FIELD(vlan, tag),
> +         .offset_words =3D 0,
> +         .offset_bits  =3D 0,
> +         .size_bits    =3D 16 },
> +       { STRUCT_FIELD(vlan, type),
> +         .offset_words =3D 0,
> +         .offset_bits  =3D 16,
> +         .size_bits    =3D 16 }
> +};
> +
>  static const struct ib_field grh_table[]  =3D {
>        { STRUCT_FIELD(grh, ip_version),
>          .offset_words =3D 0,
> @@ -205,6 +217,7 @@ static const struct ib_field deth_table[] =3D {
>  * @payload_bytes:Length of packet payload
>  * @lrh_present: specify if LRH is present
>  * @eth_present: specify if Eth header is present
> + * @vlan_present: packet is tagged vlan
>  * @grh_present:GRH flag (if non-zero, GRH will be included)
>  * @immediate_present: specify if immediate data is present
>  * @header:Structure to initialize
> @@ -212,6 +225,7 @@ static const struct ib_field deth_table[] =3D {
>  void ib_ud_header_init(int                         payload_bytes,
>                       int                  lrh_present,
>                       int                  eth_present,
> +                      int                  vlan_present,
>                       int                  grh_present,
>                       int                  immediate_present,
>                       struct ib_ud_header *header)
> @@ -227,8 +241,14 @@ void ib_ud_header_init(int
> payload_bytes,
>                packet_length =3D IB_LRH_BYTES;
>        }
>
> -       if (eth_present)
> -               packet_length =3D IB_ETH_BYTES;
> +       if (eth_present) {
> +               if (vlan_present) {
> +                       header->eth.type =3D cpu_to_be16(ETH_P_8021Q);
> +                       packet_length +=3D IB_VLAN_BYTES;
> +
> +               }
> +               packet_length +=3D IB_ETH_BYTES;
> +       }
>
>        packet_length +=3D IB_BTH_BYTES + IB_DETH_BYTES + payload_bytes +
>                4       + /* ICRC     */
> @@ -258,6 +278,7 @@ void ib_ud_header_init(int
>  payload_bytes,
>
>        header->lrh_present =3D lrh_present;
>        header->eth_present =3D eth_present;
> +       header->vlan_present =3D vlan_present;
>        header->grh_present =3D grh_present;
>        header->immediate_present =3D immediate_present;
>  }
> @@ -287,6 +308,12 @@ int ib_ud_header_pack(struct ib_ud_header *header,
>                len +=3D IB_ETH_BYTES;
>        }
>
> +       if (header->vlan_present) {
> +               ib_pack(vlan_table, ARRAY_SIZE(vlan_table),
> +                       &header->vlan, buf + len);
> +               len +=3D IB_VLAN_BYTES;
> +       }
> +
>        if (header->grh_present) {
>                ib_pack(grh_table, ARRAY_SIZE(grh_table),
>                        &header->grh, buf + len);
> diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
> index 23b184e..7e75bfa 100644
> --- a/include/rdma/ib_addr.h
> +++ b/include/rdma/ib_addr.h
> @@ -41,6 +41,7 @@
>  #include <linux/socket.h>
>  #include <rdma/ib_verbs.h>
>  #include <rdma/ib_pack.h>
> +#include <linux/if_vlan.h>
>
>  struct rdma_addr_client {
>        atomic_t refcount;
> @@ -129,12 +130,17 @@ static inline int rdma_addr_gid_offset(struct
> rdma_dev_addr *dev_addr)
>        return dev_addr->dev_type =3D=3D ARPHRD_INFINIBAND ? 4 : 0;
>  }
>
> -static inline void iboe_mac_to_ll(union ib_gid *gid, u8 *mac)
> +static inline void iboe_mac_vlan_to_ll(union ib_gid *gid, u8 *mac, u16
> vid)
>  {
>        memset(gid->raw, 0, 16);
>        *((u32 *)gid->raw) =3D cpu_to_be32(0xfe800000);
> -       gid->raw[12] =3D 0xfe;
> -       gid->raw[11] =3D 0xff;
> +       if (vid) {
> +               gid->raw[12] =3D vid & 0xff;
> +               gid->raw[11] =3D vid >> 8;
> +       } else {
> +               gid->raw[12] =3D 0xfe;
> +               gid->raw[11] =3D 0xff;
> +       }
>        memcpy(gid->raw + 13, mac + 3, 3);
>        memcpy(gid->raw + 8, mac, 3);
>        gid->raw[8] ^=3D 2;
> @@ -143,7 +149,16 @@ static inline void iboe_mac_to_ll(union ib_gid *gid,
> u8 *mac)
>  static inline void iboe_addr_get_sgid(struct rdma_dev_addr *dev_addr,
>                                      union ib_gid *gid)
>  {
> -       iboe_mac_to_ll(gid, dev_addr->src_dev_addr);
> +       struct net_device *dev;
> +       u16 vid =3D 0;
> +
> +       dev =3D dev_get_by_index(&init_net, dev_addr->bound_dev_if);
> +       if (dev) {
> +               vid =3D vlan_dev_vlan_id(dev);
> +               dev_put(dev);
> +       }
> +
> +       iboe_mac_vlan_to_ll(gid, dev_addr->src_dev_addr, vid);
>  }
>
>  static inline void rdma_addr_get_sgid(struct rdma_dev_addr *dev_addr,
> union ib_gid *gid)
> @@ -243,4 +258,30 @@ static inline void rdma_get_mcast_mac(struct in6_add=
r
> *addr, u8 *mac)
>        for (i =3D 2; i < 6; ++i)
>                mac[i] =3D addr->s6_addr[i + 10];
>  }
> +
> +static inline u16 rdma_get_vlan_id(union ib_gid *dgid)
> +{
> +       u16 vid;
> +
> +       vid =3D dgid->raw[11] << 8 | dgid->raw[12];
> +       return vid =3D=3D 0xfffe ? 0 : vid  & 0xfff;
> +}
> +
> +static inline u16 rdma_vlan_dev_vlan_id(const struct net_device *dev) {
> +#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
> +       return vlan_dev_vlan_id(dev);
> +#else
> +       return 0;
> +#endif
> +}
> +
> +static inline struct net_device *rdma_vlan_dev_real_dev(const struct
> net_device *dev)
> +{
> +#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
> +       return vlan_dev_real_dev(dev);
> +#else
> +       return 0;
> +#endif
> +}
> +
>  #endif /* IB_ADDR_H */
> diff --git a/include/rdma/ib_pack.h b/include/rdma/ib_pack.h
> index 67a85f3..1678be7 100644
> --- a/include/rdma/ib_pack.h
> +++ b/include/rdma/ib_pack.h
> @@ -38,6 +38,7 @@
>  enum {
>        IB_LRH_BYTES  =3D 8,
>        IB_ETH_BYTES  =3D 14,
> +       IB_VLAN_BYTES =3D 4,
>        IB_GRH_BYTES  =3D 40,
>        IB_BTH_BYTES  =3D 12,
>        IB_DETH_BYTES =3D 8
> @@ -219,21 +220,18 @@ struct ib_unpacked_eth {
>        __be16  type;
>  };
>
> +struct ib_unpacked_vlan {
> +       __be16  tag;
> +       __be16  type;
> +};
> +
>  struct ib_ud_header {
>        int                     lrh_present;
>        struct ib_unpacked_lrh  lrh;
>        int                     eth_present;
>        struct ib_unpacked_eth  eth;
> -       int                     grh_present;
> -       struct ib_unpacked_grh  grh;
> -       struct ib_unpacked_bth  bth;
> -       struct ib_unpacked_deth deth;
> -       int                     immediate_present;
> -       __be32                  immediate_data;
> -};
> -
> -struct eth_ud_header {
> -       struct ib_unpacked_eth  eth;
> +       int                     vlan_present;
> +       struct ib_unpacked_vlan vlan;
>        int                     grh_present;
>        struct ib_unpacked_grh  grh;
>        struct ib_unpacked_bth  bth;
> @@ -255,6 +253,7 @@ void ib_unpack(const struct ib_field        *desc,
>  void ib_ud_header_init(int                         payload_bytes,
>                       int                  lrh_present,
>                       int                  eth_present,
> +                      int                  vlan_present,
>                       int                  grh_present,
>                       int                  immediate_present,
>                       struct ib_ud_header *header);
> --
> 1.7.0
>
> _______________________________________________
> ewg mailing list
> ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
>

--0016e6476634c8979a048a1f342c
Content-Type: text/html; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Eli,<div><br></div><div>I&#39;m getting build failure of our kernel module =
with=A0OFED-1.5.2-rc1.</div><div><br></div><div><div>/usr/src/ofa_kernel/in=
clude/rdma/ib_addr.h: In function =91iboe_addr_get_sgid=92:</div><div>/usr/=
src/ofa_kernel/include/rdma/ib_addr.h:160: error: implicit declaration of f=
unction =91vlan_dev_vlan_id=92</div>
</div><div><br></div><div>I&#39;m using a standard Redhat EL 5.3 setup.</di=
v><div>kernel is=A0<span class=3D"Apple-style-span" style=3D"font-family: a=
rial, sans-serif; border-collapse: collapse; ">2.6.18-128.7.1.el5</span></d=
iv>
<div><span class=3D"Apple-style-span" style=3D"font-family: arial, sans-ser=
if; border-collapse: collapse; "><br></span></div><div>include/linux/autoco=
nf.h has the following defined but the function doesn&#39;t seem to be defi=
ned in the kernel.</div>
<div><br></div><div><font class=3D"Apple-style-span" face=3D"arial, sans-se=
rif"><span class=3D"Apple-style-span" style=3D"border-collapse: collapse; "=
>CONFIG_VLAN_8021Q_MODULE 1</span></font></div><div><font class=3D"Apple-st=
yle-span" face=3D"arial, sans-serif"><span class=3D"Apple-style-span" style=
=3D"border-collapse: collapse;"><br>
</span></font></div><div><font class=3D"Apple-style-span" face=3D"arial, sa=
ns-serif"><span class=3D"Apple-style-span" style=3D"border-collapse: collap=
se;">I can work around the problem by hacking=A0</span></font><span class=
=3D"Apple-style-span" style=3D"font-family: arial, sans-serif; border-colla=
pse: collapse; ">/usr/src/ofa_kernel/include/rdma/ib_addr.h with undefining=
 the VLAN stuff.</span></div>
<div><font class=3D"Apple-style-span" face=3D"arial, sans-serif"><span clas=
s=3D"Apple-style-span" style=3D"border-collapse: collapse;">

<br>
#undef CONFIG_VLAN_8021Q
<br>
#undef CONFIG_VLAN_8021Q_MODULE</span></font></div><div><font class=3D"Appl=
e-style-span" face=3D"arial, sans-serif"><span class=3D"Apple-style-span" s=
tyle=3D"border-collapse: collapse;"><br></span></font></div><div><font clas=
s=3D"Apple-style-span" face=3D"arial, sans-serif"><span class=3D"Apple-styl=
e-span" style=3D"border-collapse: collapse;">Any ideas to fix this in a gra=
ceful way?</span></font></div>
<div><font class=3D"Apple-style-span" face=3D"arial, sans-serif"><span clas=
s=3D"Apple-style-span" style=3D"border-collapse: collapse; "><br></span></f=
ont></div><div><div class=3D"gmail_quote">On Thu, Feb 18, 2010 at 10:24 AM,=
 Eli Cohen <span dir=3D"ltr">&lt;<a href=3D"mailto:eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org">eli@=
mellanox.co.il</a>&gt;</span> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex;">Add 802.1q vlan support to IBoE. The vlan t=
ag is encoded within the GID<br>
derived from a link local address in the following way:<br>
<br>
GID[11] GID[12] contain the vlan ID.<br>
The 3 bit user priority field is identical to the 3 bits of the SL.<br>
<br>
In case rdma_cm apps, the TOS field is used to generate the SL field by doi=
ng a<br>
shift right of 5 bits effectively taking to 3 MS bits of the TOS field. In<=
br>
order to support userspace verbs consumers, ib_uverbs_get_mac has changed i=
nto<br>
ib_uverbs_get_eth_l2_addr and now returns both MAC and VLAN information.<br=
>
<br>
Signed-off-by: Eli Cohen &lt;<a href=3D"mailto:eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org">eli@mell=
anox.co.il</a>&gt;<br>
---<br>
=A0drivers/infiniband/core/cma.c =A0 =A0 =A0 | =A0 20 ++++++++-----<br>
=A0drivers/infiniband/core/ucma.c =A0 =A0 =A0| =A0 13 ++++++++-<br>
=A0drivers/infiniband/core/ud_header.c | =A0 31 ++++++++++++++++++++-<br>
=A0include/rdma/ib_addr.h =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 49 +++++++++++++=
+++++++++++++++++++---<br>
=A0include/rdma/ib_pack.h =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 19 ++++++-------=
<br>
=A05 files changed, 106 insertions(+), 26 deletions(-)<br>
<br>
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c<=
br>
index df5f636..108d1bb 100644<br>
--- a/drivers/infiniband/core/cma.c<br>
+++ b/drivers/infiniband/core/cma.c<br>
@@ -1763,6 +1763,7 @@ static int cma_resolve_iboe_route(struct rdma_id_priv=
ate *id_priv)<br>
 =A0 =A0 =A0 =A0struct sockaddr_in *src_addr =3D (struct sockaddr_in *)&amp=
;route-&gt;addr.src_addr;<br>
 =A0 =A0 =A0 =A0struct sockaddr_in *dst_addr =3D (struct sockaddr_in *)&amp=
;route-&gt;addr.dst_addr;<br>
 =A0 =A0 =A0 =A0struct net_device *ndev =3D NULL;<br>
+ =A0 =A0 =A0 u16 vid;<br>
<br>
 =A0 =A0 =A0 =A0if (src_addr-&gt;sin_family !=3D dst_addr-&gt;sin_family)<b=
r>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;<br>
@@ -1782,14 +1783,6 @@ static int cma_resolve_iboe_route(struct rdma_id_pri=
vate *id_priv)<br>
<br>
 =A0 =A0 =A0 =A0route-&gt;num_paths =3D 1;<br>
<br>
- =A0 =A0 =A0 iboe_mac_to_ll(&amp;route-&gt;path_rec-&gt;sgid, addr-&gt;dev=
_addr.src_dev_addr);<br>
- =A0 =A0 =A0 iboe_mac_to_ll(&amp;route-&gt;path_rec-&gt;dgid, addr-&gt;dev=
_addr.dst_dev_addr);<br>
-<br>
- =A0 =A0 =A0 route-&gt;path_rec-&gt;hop_limit =3D 1;<br>
- =A0 =A0 =A0 route-&gt;path_rec-&gt;reversible =3D 1;<br>
- =A0 =A0 =A0 route-&gt;path_rec-&gt;pkey =3D cpu_to_be16(0xffff);<br>
- =A0 =A0 =A0 route-&gt;path_rec-&gt;mtu_selector =3D IB_SA_EQ;<br>
-<br>
 =A0 =A0 =A0 =A0if (addr-&gt;dev_addr.bound_dev_if)<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ndev =3D dev_get_by_index(&amp;init_net, ad=
dr-&gt;dev_addr.bound_dev_if);<br>
 =A0 =A0 =A0 =A0if (!ndev) {<br>
@@ -1797,6 +1790,17 @@ static int cma_resolve_iboe_route(struct rdma_id_pri=
vate *id_priv)<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto err2;<br>
 =A0 =A0 =A0 =A0}<br>
<br>
+ =A0 =A0 =A0 vid =3D rdma_vlan_dev_vlan_id(ndev);<br>
+<br>
+ =A0 =A0 =A0 iboe_mac_vlan_to_ll(&amp;route-&gt;path_rec-&gt;sgid, addr-&g=
t;dev_addr.src_dev_addr, vid);<br>
+ =A0 =A0 =A0 iboe_mac_vlan_to_ll(&amp;route-&gt;path_rec-&gt;dgid, addr-&g=
t;dev_addr.dst_dev_addr, vid);<br>
+<br>
+ =A0 =A0 =A0 route-&gt;path_rec-&gt;hop_limit =3D 1;<br>
+ =A0 =A0 =A0 route-&gt;path_rec-&gt;reversible =3D 1;<br>
+ =A0 =A0 =A0 route-&gt;path_rec-&gt;pkey =3D cpu_to_be16(0xffff);<br>
+ =A0 =A0 =A0 route-&gt;path_rec-&gt;mtu_selector =3D IB_SA_EQ;<br>
+ =A0 =A0 =A0 route-&gt;path_rec-&gt;sl =3D id_priv-&gt;tos &gt;&gt; 5;<br>
+<br>
 =A0 =A0 =A0 =A0route-&gt;path_rec-&gt;mtu =3D iboe_get_mtu(ndev-&gt;mtu);<=
br>
 =A0 =A0 =A0 =A0route-&gt;path_rec-&gt;rate_selector =3D IB_SA_EQ;<br>
 =A0 =A0 =A0 =A0route-&gt;path_rec-&gt;rate =3D iboe_get_rate(ndev);<br>
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.=
c<br>
index fcc27bc..ed670f5 100644<br>
--- a/drivers/infiniband/core/ucma.c<br>
+++ b/drivers/infiniband/core/ucma.c<br>
@@ -586,13 +586,22 @@ static void ucma_copy_iboe_route(struct rdma_ucm_quer=
y_route_resp *resp,<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct rdm=
a_route *route)<br>
=A0{<br>
 =A0 =A0 =A0 =A0struct rdma_dev_addr *dev_addr;<br>
+ =A0 =A0 =A0 struct net_device *dev;<br>
+ =A0 =A0 =A0 u16 vid =3D 0;<br>
<br>
 =A0 =A0 =A0 =A0resp-&gt;num_paths =3D route-&gt;num_paths;<br>
 =A0 =A0 =A0 =A0switch (route-&gt;num_paths) {<br>
 =A0 =A0 =A0 =A0case 0:<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev_addr =3D &amp;route-&gt;addr.dev_addr;<=
br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 iboe_mac_to_ll((union ib_gid *) &amp;resp-&gt=
;ib_route[0].dgid,<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev_addr-&gt;d=
st_dev_addr);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev =3D dev_get_by_index(&amp;init_net, dev_a=
ddr-&gt;bound_dev_if);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dev) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vid =3D rdma_=
vlan_dev_vlan_id(dev);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_put(dev);=
<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
+<br>
+<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 iboe_mac_vlan_to_ll((union ib_gid *) &amp;res=
p-&gt;ib_route[0].dgid,<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_a=
ddr-&gt;dst_dev_addr, vid);<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0iboe_addr_get_sgid(dev_addr,<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (union=
 ib_gid *) &amp;resp-&gt;ib_route[0].sgid);<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0resp-&gt;ib_route[0].pkey =3D cpu_to_be16(0=
xffff);<br>
diff --git a/drivers/infiniband/core/ud_header.c b/drivers/infiniband/core/=
ud_header.c<br>
index 7650313..7d03cf1 100644<br>
--- a/drivers/infiniband/core/ud_header.c<br>
+++ b/drivers/infiniband/core/ud_header.c<br>
@@ -33,6 +33,7 @@<br>
<br>
=A0#include &lt;linux/errno.h&gt;<br>
=A0#include &lt;linux/string.h&gt;<br>
+#include &lt;linux/if_ether.h&gt;<br>
<br>
=A0#include &lt;rdma/ib_pack.h&gt;<br>
<br>
@@ -103,6 +104,17 @@ static const struct ib_field eth_table[] =A0=3D {<br>
 =A0 =A0 =A0 =A0 =A0.size_bits =A0 =A0=3D 16 }<br>
=A0};<br>
<br>
+static const struct ib_field vlan_table[] =A0=3D {<br>
+ =A0 =A0 =A0 { STRUCT_FIELD(vlan, tag),<br>
+ =A0 =A0 =A0 =A0 .offset_words =3D 0,<br>
+ =A0 =A0 =A0 =A0 .offset_bits =A0=3D 0,<br>
+ =A0 =A0 =A0 =A0 .size_bits =A0 =A0=3D 16 },<br>
+ =A0 =A0 =A0 { STRUCT_FIELD(vlan, type),<br>
+ =A0 =A0 =A0 =A0 .offset_words =3D 0,<br>
+ =A0 =A0 =A0 =A0 .offset_bits =A0=3D 16,<br>
+ =A0 =A0 =A0 =A0 .size_bits =A0 =A0=3D 16 }<br>
+};<br>
+<br>
=A0static const struct ib_field grh_table[] =A0=3D {<br>
 =A0 =A0 =A0 =A0{ STRUCT_FIELD(grh, ip_version),<br>
 =A0 =A0 =A0 =A0 =A0.offset_words =3D 0,<br>
@@ -205,6 +217,7 @@ static const struct ib_field deth_table[] =3D {<br>
 =A0* @payload_bytes:Length of packet payload<br>
 =A0* @lrh_present: specify if LRH is present<br>
 =A0* @eth_present: specify if Eth header is present<br>
+ * @vlan_present: packet is tagged vlan<br>
 =A0* @grh_present:GRH flag (if non-zero, GRH will be included)<br>
 =A0* @immediate_present: specify if immediate data is present<br>
 =A0* @header:Structure to initialize<br>
@@ -212,6 +225,7 @@ static const struct ib_field deth_table[] =3D {<br>
=A0void ib_ud_header_init(int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 payload_bytes,<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0lrh_present,<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0eth_present,<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0vlan_present,<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0grh_present,<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0immediate_present,<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ib_ud_header *header)<b=
r>
@@ -227,8 +241,14 @@ void ib_ud_header_init(int =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 payload_bytes,<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0packet_length =3D IB_LRH_BYTES;<br>
 =A0 =A0 =A0 =A0}<br>
<br>
- =A0 =A0 =A0 if (eth_present)<br>
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 packet_length =3D IB_ETH_BYTES;<br>
+ =A0 =A0 =A0 if (eth_present) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (vlan_present) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 header-&gt;eth.type =3D cpu_t=
o_be16(ETH_P_8021Q);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 packet_length +=3D IB_VLAN_BY=
TES;<br>
+<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 packet_length +=3D IB_ETH_BYTES;<br>
+ =A0 =A0 =A0 }<br>
<br>
 =A0 =A0 =A0 =A0packet_length +=3D IB_BTH_BYTES + IB_DETH_BYTES + payload_b=
ytes +<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A04 =A0 =A0 =A0 + /* ICRC =A0 =A0 */<br>
@@ -258,6 +278,7 @@ void ib_ud_header_init(int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0payload_bytes,<br>
<br>
 =A0 =A0 =A0 =A0header-&gt;lrh_present =3D lrh_present;<br>
 =A0 =A0 =A0 =A0header-&gt;eth_present =3D eth_present;<br>
+ =A0 =A0 =A0 header-&gt;vlan_present =3D vlan_present;<br>
 =A0 =A0 =A0 =A0header-&gt;grh_present =3D grh_present;<br>
 =A0 =A0 =A0 =A0header-&gt;immediate_present =3D immediate_present;<br>
=A0}<br>
@@ -287,6 +308,12 @@ int ib_ud_header_pack(struct ib_ud_header *header,<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0len +=3D IB_ETH_BYTES;<br>
 =A0 =A0 =A0 =A0}<br>
<br>
+ =A0 =A0 =A0 if (header-&gt;vlan_present) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 ib_pack(vlan_table, ARRAY_SIZE(vlan_table),<b=
r>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &amp;header-&gt;vlan, buf + l=
en);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 len +=3D IB_VLAN_BYTES;<br>
+ =A0 =A0 =A0 }<br>
+<br>
 =A0 =A0 =A0 =A0if (header-&gt;grh_present) {<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ib_pack(grh_table, ARRAY_SIZE(grh_table),<b=
r>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&amp;header-&gt;grh, buf + =
len);<br>
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h<br>
index 23b184e..7e75bfa 100644<br>
--- a/include/rdma/ib_addr.h<br>
+++ b/include/rdma/ib_addr.h<br>
@@ -41,6 +41,7 @@<br>
=A0#include &lt;linux/socket.h&gt;<br>
=A0#include &lt;rdma/ib_verbs.h&gt;<br>
=A0#include &lt;rdma/ib_pack.h&gt;<br>
+#include &lt;linux/if_vlan.h&gt;<br>
<br>
=A0struct rdma_addr_client {<br>
 =A0 =A0 =A0 =A0atomic_t refcount;<br>
@@ -129,12 +130,17 @@ static inline int rdma_addr_gid_offset(struct rdma_de=
v_addr *dev_addr)<br>
 =A0 =A0 =A0 =A0return dev_addr-&gt;dev_type =3D=3D ARPHRD_INFINIBAND ? 4 :=
 0;<br>
=A0}<br>
<br>
-static inline void iboe_mac_to_ll(union ib_gid *gid, u8 *mac)<br>
+static inline void iboe_mac_vlan_to_ll(union ib_gid *gid, u8 *mac, u16 vid=
)<br>
=A0{<br>
 =A0 =A0 =A0 =A0memset(gid-&gt;raw, 0, 16);<br>
 =A0 =A0 =A0 =A0*((u32 *)gid-&gt;raw) =3D cpu_to_be32(0xfe800000);<br>
- =A0 =A0 =A0 gid-&gt;raw[12] =3D 0xfe;<br>
- =A0 =A0 =A0 gid-&gt;raw[11] =3D 0xff;<br>
+ =A0 =A0 =A0 if (vid) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 gid-&gt;raw[12] =3D vid &amp; 0xff;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 gid-&gt;raw[11] =3D vid &gt;&gt; 8;<br>
+ =A0 =A0 =A0 } else {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 gid-&gt;raw[12] =3D 0xfe;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 gid-&gt;raw[11] =3D 0xff;<br>
+ =A0 =A0 =A0 }<br>
 =A0 =A0 =A0 =A0memcpy(gid-&gt;raw + 13, mac + 3, 3);<br>
 =A0 =A0 =A0 =A0memcpy(gid-&gt;raw + 8, mac, 3);<br>
 =A0 =A0 =A0 =A0gid-&gt;raw[8] ^=3D 2;<br>
@@ -143,7 +149,16 @@ static inline void iboe_mac_to_ll(union ib_gid *gid, u=
8 *mac)<br>
=A0static inline void iboe_addr_get_sgid(struct rdma_dev_addr *dev_addr,<br=
>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0union ib_gid *gid)<br>
=A0{<br>
- =A0 =A0 =A0 iboe_mac_to_ll(gid, dev_addr-&gt;src_dev_addr);<br>
+ =A0 =A0 =A0 struct net_device *dev;<br>
+ =A0 =A0 =A0 u16 vid =3D 0;<br>
+<br>
+ =A0 =A0 =A0 dev =3D dev_get_by_index(&amp;init_net, dev_addr-&gt;bound_de=
v_if);<br>
+ =A0 =A0 =A0 if (dev) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 vid =3D vlan_dev_vlan_id(dev);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_put(dev);<br>
+ =A0 =A0 =A0 }<br>
+<br>
+ =A0 =A0 =A0 iboe_mac_vlan_to_ll(gid, dev_addr-&gt;src_dev_addr, vid);<br>
=A0}<br>
<br>
=A0static inline void rdma_addr_get_sgid(struct rdma_dev_addr *dev_addr, un=
ion ib_gid *gid)<br>
@@ -243,4 +258,30 @@ static inline void rdma_get_mcast_mac(struct in6_addr =
*addr, u8 *mac)<br>
 =A0 =A0 =A0 =A0for (i =3D 2; i &lt; 6; ++i)<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mac[i] =3D addr-&gt;s6_addr[i + 10];<br>
=A0}<br>
+<br>
+static inline u16 rdma_get_vlan_id(union ib_gid *dgid)<br>
+{<br>
+ =A0 =A0 =A0 u16 vid;<br>
+<br>
+ =A0 =A0 =A0 vid =3D dgid-&gt;raw[11] &lt;&lt; 8 | dgid-&gt;raw[12];<br>
+ =A0 =A0 =A0 return vid =3D=3D 0xfffe ? 0 : vid =A0&amp; 0xfff;<br>
+}<br>
+<br>
+static inline u16 rdma_vlan_dev_vlan_id(const struct net_device *dev) {<br=
>
+#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)<br>
+ =A0 =A0 =A0 return vlan_dev_vlan_id(dev);<br>
+#else<br>
+ =A0 =A0 =A0 return 0;<br>
+#endif<br>
+}<br>
+<br>
+static inline struct net_device *rdma_vlan_dev_real_dev(const struct net_d=
evice *dev)<br>
+{<br>
+#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)<br>
+ =A0 =A0 =A0 return vlan_dev_real_dev(dev);<br>
+#else<br>
+ =A0 =A0 =A0 return 0;<br>
+#endif<br>
+}<br>
+<br>
=A0#endif /* IB_ADDR_H */<br>
diff --git a/include/rdma/ib_pack.h b/include/rdma/ib_pack.h<br>
index 67a85f3..1678be7 100644<br>
--- a/include/rdma/ib_pack.h<br>
+++ b/include/rdma/ib_pack.h<br>
@@ -38,6 +38,7 @@<br>
=A0enum {<br>
 =A0 =A0 =A0 =A0IB_LRH_BYTES =A0=3D 8,<br>
 =A0 =A0 =A0 =A0IB_ETH_BYTES =A0=3D 14,<br>
+ =A0 =A0 =A0 IB_VLAN_BYTES =3D 4,<br>
 =A0 =A0 =A0 =A0IB_GRH_BYTES =A0=3D 40,<br>
 =A0 =A0 =A0 =A0IB_BTH_BYTES =A0=3D 12,<br>
 =A0 =A0 =A0 =A0IB_DETH_BYTES =3D 8<br>
@@ -219,21 +220,18 @@ struct ib_unpacked_eth {<br>
 =A0 =A0 =A0 =A0__be16 =A0type;<br>
=A0};<br>
<br>
+struct ib_unpacked_vlan {<br>
+ =A0 =A0 =A0 __be16 =A0tag;<br>
+ =A0 =A0 =A0 __be16 =A0type;<br>
+};<br>
+<br>
=A0struct ib_ud_header {<br>
 =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lrh_present;<br=
>
 =A0 =A0 =A0 =A0struct ib_unpacked_lrh =A0lrh;<br>
 =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 eth_present;<br=
>
 =A0 =A0 =A0 =A0struct ib_unpacked_eth =A0eth;<br>
- =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 grh_present;<br>
- =A0 =A0 =A0 struct ib_unpacked_grh =A0grh;<br>
- =A0 =A0 =A0 struct ib_unpacked_bth =A0bth;<br>
- =A0 =A0 =A0 struct ib_unpacked_deth deth;<br>
- =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 immediate_present=
;<br>
- =A0 =A0 =A0 __be32 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0immediate_data;<br>
-};<br>
-<br>
-struct eth_ud_header {<br>
- =A0 =A0 =A0 struct ib_unpacked_eth =A0eth;<br>
+ =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vlan_present;<br>
+ =A0 =A0 =A0 struct ib_unpacked_vlan vlan;<br>
 =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 grh_present;<br=
>
 =A0 =A0 =A0 =A0struct ib_unpacked_grh =A0grh;<br>
 =A0 =A0 =A0 =A0struct ib_unpacked_bth =A0bth;<br>
@@ -255,6 +253,7 @@ void ib_unpack(const struct ib_field =A0 =A0 =A0 =A0*de=
sc,<br>
=A0void ib_ud_header_init(int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 payload_bytes,<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0lrh_present,<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0eth_present,<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0vlan_present,<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0grh_present,<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0immediate_present,<br>
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ib_ud_header *header);<=
br>
<font color=3D"#888888">--<br>
1.7.0<br>
<br>
_______________________________________________<br>
ewg mailing list<br>
<a href=3D"mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org">ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org</a><=
br>
<a href=3D"http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg" targe=
t=3D"_blank">http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg</a><=
br>
</font></blockquote></div><br></div>

--0016e6476634c8979a048a1f342c--

--===============1921585912==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
ewg mailing list
ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
--===============1921585912==--
