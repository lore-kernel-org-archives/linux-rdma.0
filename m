From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v4 14/19] IB/core: Add IB_DEVICE_OPA_MAD_SUPPORT device
 cap flag
Date: Fri, 20 Mar 2015 14:38:44 +0100
Message-ID: <550C22E4.9040604@profitbricks.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com>  <1423092585-26692-15-git-send-email-ira.weiny@intel.com>  <54D52589.8020305@dev.mellanox.co.il>  <2807E5FD2F6FDA4886F6618EAC48510E0CC244A8@CRSMSX101.amr.corp.intel.com>  <54DCB1E9.7010309@dev.mellanox.co.il>  <2807E5FD2F6FDA4886F6618EAC48510E0CC29020@CRSMSX101.amr.corp.intel.com>  <54EB7756.7070407@dev.mellanox.co.il>  <2807E5FD2F6FDA4886F6618EAC48510E0CC3D330@CRSMSX101.amr.corp.intel.com> <1424884438.4847.91.camel@redhat.com> <2807E5FD2F6FDA4886F6618EAC48510E0CC4F18C@CRSMSX101.amr.corp.intel.com> <1828884A29C6694DAF28B7E6B8A8237399E6F06F@ORSMSX110.amr.corp.intel.com> <2807E5FD2F6FDA4886F6618EAC48510E0CC4F50B@CRSMSX101.amr.corp.intel.com> <54FE0F16.5090905@dev.mellanox.co.il> <2807E5FD2F6FDA4886F6618EAC48510E0CC5C11A@CRSM
 SX101.amr.corp.intel.com> <1828884A29C6694DAF28B7E6B8A8237399E8106A@ORSMSX109.amr.corp.intel.com> <1828884A29C6694DAF28B7E6B8A8237399E818C6@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399E818C6-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi, folks

I've done a draft (very rough draft...) according to my understanding o=
n
Sean's proposal.

The implementation is to allow device setup the management flags during
ib_query_port() (amso1100 as eg), and later we could use the flags to c=
heck
the capability.

=46or new capability/proto, like OPA, device could setup new flag
IB_MGMT_PROTO_OPA during query_port() callback, and some helper like
rdma_mgmt_cap_opa() can be used for management branch.

How do you think about this?

Regards,
Michael Wang



diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cm=
a.c
index d570030..ad1685e 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -375,8 +375,7 @@ static int cma_acquire_dev(struct rdma_id_private=20
*id_priv,
                       listen_id_priv->id.port_num) =3D=3D dev_ll) {
          cma_dev =3D listen_id_priv->cma_dev;
          port =3D listen_id_priv->id.port_num;
-        if (rdma_node_get_transport(cma_dev->device->node_type) =3D=3D=
=20
RDMA_TRANSPORT_IB &&
-            rdma_port_get_link_layer(cma_dev->device, port) =3D=3D=20
IB_LINK_LAYER_ETHERNET)
+        if (rdma_mgmt_cap_iboe(cma_dev->device, port))
              ret =3D ib_find_cached_gid(cma_dev->device, &iboe_gid,
                           &found_port, NULL);
          else
@@ -395,8 +394,7 @@ static int cma_acquire_dev(struct rdma_id_private=20
*id_priv,
                  listen_id_priv->id.port_num =3D=3D port)
                  continue;
              if (rdma_port_get_link_layer(cma_dev->device, port) =3D=3D=
=20
dev_ll) {
-                if (rdma_node_get_transport(cma_dev->device->node_type=
)=20
=3D=3D RDMA_TRANSPORT_IB &&
-                    rdma_port_get_link_layer(cma_dev->device, port) =3D=
=3D=20
IB_LINK_LAYER_ETHERNET)
+                if (rdma_mgmt_cap_iboe(cma_dev->device, port))
                      ret =3D ib_find_cached_gid(cma_dev->device,=20
&iboe_gid, &found_port, NULL);
                  else
                      ret =3D ib_find_cached_gid(cma_dev->device, &gid,=
=20
&found_port, NULL);
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/ma=
d.c
index 74c30f4..0ae6b04 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2938,7 +2938,7 @@ static int ib_mad_port_open(struct ib_device *dev=
ice,
      init_mad_qp(port_priv, &port_priv->qp_info[1]);

      cq_size =3D mad_sendq_size + mad_recvq_size;
-    has_smi =3D rdma_port_get_link_layer(device, port_num) =3D=3D=20
IB_LINK_LAYER_INFINIBAND;
+    has_smi =3D rdma_mgmt_cap_smi(device, port_num);
      if (has_smi)
          cq_size *=3D 2;

@@ -3057,7 +3057,7 @@ static void ib_mad_init_device(struct ib_device=20
*device)
  {
      int start, end, i;

-    if (rdma_node_get_transport(device->node_type) !=3D RDMA_TRANSPORT=
_IB)
+    if (!rdma_mgmt_cap_ib(device))
          return;

      if (device->node_type =3D=3D RDMA_NODE_IB_SWITCH) {
diff --git a/drivers/infiniband/core/verbs.c=20
b/drivers/infiniband/core/verbs.c
index f93eb8d..5ecf9c8 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -146,6 +146,26 @@ enum rdma_link_layer=20
rdma_port_get_link_layer(struct ib_device *device, u8 port_
  }
  EXPORT_SYMBOL(rdma_port_get_link_layer);

+int rdma_port_default_mgmt_flags(struct ib_device *device, u8 port_num=
)
+{
+    int mgmt_flags =3D 0;
+    enum rdma_transport_type tp =3D
+            rdma_node_get_transport(device->node_type);
+    enum rdma_link_layer ll =3D
+            rdma_port_get_link_layer(device, port_num);
+
+    if (tp =3D=3D RDMA_TRANSPORT_IB) {
+        mgmt_flags |=3D IB_MGMT_PROTO_IB;
+        if (ll =3D=3D IB_LINK_LAYER_INFINIBAND) {
+            mgmt_flags |=3D IB_MGMT_PROTO_SMI;
+            mgmt_flags |=3D IB_MGMT_PROTO_IBOE;
+        }
+    }
+
+    return mgmt_flags;
+}
+EXPORT_SYMBOL(rdma_port_default_mgmt_flags);
+
  /* Protection domains */

  struct ib_pd *ib_alloc_pd(struct ib_device *device)
diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c=20
b/drivers/infiniband/hw/amso1100/c2_provider.c
index bdf3507..04d005e 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -96,6 +96,9 @@ static int c2_query_port(struct ib_device *ibdev,
      props->active_width =3D 1;
      props->active_speed =3D IB_SPEED_SDR;

+    /* Makeup flags here, by default or on your own */
+    props->mgmt_flags =3D rdma_port_default_mgmt_flags(ibdev, port);
+
      return 0;
  }

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 65994a1..d19c7c9 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -90,6 +90,13 @@ enum rdma_link_layer {
      IB_LINK_LAYER_ETHERNET,
  };

+enum rdma_mgmt_flag {
+    IB_MGMT_PROTO_IB,
+    IB_MGMT_PROTO_SMI,
+    IB_MGMT_PROTO_IBOE,
+    /* More Here*/
+};
+
  enum ib_device_cap_flags {
      IB_DEVICE_RESIZE_MAX_WR        =3D 1,
      IB_DEVICE_BAD_PKEY_CNTR        =3D (1<<1),
@@ -352,6 +359,7 @@ struct ib_port_attr {
      enum ib_mtu        active_mtu;
      int            gid_tbl_len;
      u32            port_cap_flags;
+    u32            mgmt_flags;
      u32            max_msg_sz;
      u32            bad_pkey_cntr;
      u32            qkey_viol_cntr;
@@ -1743,6 +1751,32 @@ int ib_query_port(struct ib_device *device,
  enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *devic=
e,
                             u8 port_num);

+int rdma_port_default_mgmt_flags(struct ib_device *device, u8 port_num=
);
+
+static inline int rdma_mgmt_cap(struct ib_device *device, u8 port_num)
+{
+    struct ib_port_attr port_attr;
+    memset(&port_attr, 0, sizeof port_attr);
+    ib_query_port(device, port_num, &port_attr);
+    return port_attr.mgmt_flags;
+}
+
+static inline int rdma_mgmt_cap_ib(struct ib_device *device)
+{
+    u8 port_num =3D device->node_type =3D=3D RDMA_NODE_IB_SWITCH ? 0 :=
 1;
+    return rdma_mgmt_cap(device, port_num) & IB_MGMT_PROTO_IB;
+}
+
+static inline int rdma_mgmt_cap_smi(struct ib_device *device, u8 port_=
num)
+{
+    return rdma_mgmt_cap(device, port_num) & IB_MGMT_PROTO_SMI;
+}
+
+static inline int rdma_mgmt_cap_iboe(struct ib_device *device, u8 port=
_num)
+{
+    return rdma_mgmt_cap(device, port_num) & IB_MGMT_PROTO_IBOE;
+}
+
  int ib_query_gid(struct ib_device *device,
           u8 port_num, int index, union ib_gid *gid);



On 03/18/2015 12:36 AM, Hefty, Sean wrote:
>> But it makes sense to me to use management specific
>> fields/attributes/flags for the *management* pieces, rather than usi=
ng the
>> link and/or transport layer protocols as a proxy.  Management relate=
d code
>> should really branch based on that.
> As a proposal, we could add a new field to the kernel port attribute =
structure.  The field would be a bitmask of management capabilities/pro=
tocols:
>
> IB_MGMT_PROTO_SM - supports IB SMPs
> IB_MGMT_PROTO_SA - supports IB SA MADs
> IB_MGMT_PROTO_GS - supports IB GSI MADs (e.g. CM, PM, ...)
> IB_MGMT_PROTO_OPA_SM - supports OPA SMPs (or whatever they are called=
)
> IB_MGMT_PROTO_OPA_GS - supports OPA GS MADs (or whatever is supported=
)
>
> If the *GS flags are not sufficient to distinguish between MADs suppo=
rted over IB and RoCE, it can be further divided (i.e. CM, PM, BM, DM, =
etc.).
>
> This would provide a direct mapping of which management protocols are=
 supported for a given port, rather than it being inferred by the link/=
transport fields, which should really be independent.  It would also al=
low for simple checks by the core layer.
>
> If we want the code to be more generic, additional field(s) could be =
added, such as mad_size, so that any size of management datagram is sup=
ported.  This would be used instead of inferring the size based on the =
supported protocol.
>
> - Sean
> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=
=EF=BF=BD=D9=9A=EF=BF=BD{ay=EF=BF=BD=1D=CA=87=DA=99=EF=BF=BD,j=07=EF=BF=
=BD=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BDz=EF=
=BF=BD=1E=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=0C=EF=BF=BD=EF=BF=BD=EF=BF=
=BDj:+v=EF=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=EF=BF=BDm=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=07=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDzZ+=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=DD=A2j"=EF=BF=BD=EF=BF=BD!tml=3D

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
