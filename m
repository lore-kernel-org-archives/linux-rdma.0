From: Suri Shelvapille <suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org>
Subject: RE: [rdma-next v2 07/23] RDMA/core: Remove unimplemented node_types
 and node transport
Date: Tue, 15 Aug 2017 18:25:54 +0000
Message-ID: <SN1PR0301MB2127376FC9B3D170C878A47BDE8D0@SN1PR0301MB2127.namprd03.prod.outlook.com>
References: <20170815085452.3546-1-leon@kernel.org>
 <20170815085452.3546-8-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170815085452.3546-8-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Leon:

We do have IB_SWITCH and IB_ROUTER functionality and we do use the SWITCH c=
apability provided by the "core" in our product. The "core" has a wrapper f=
unction which Identifies the device as a switch to direct smp packets. I am=
 glad that has not been removed. And I hope it won't be removed as it would=
 be a burden to us. Although we prefer to have the IB_SWITCH/IB_ROUTER defi=
nitions in the core as well, it is not a big deal to move these definitions=
 inside our driver.

Thanks,
Suri

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TZUIDd8j+nm9g@public.gmane.org=
.org] On Behalf Of Leon Romanovsky
Sent: Tuesday, August 15, 2017 4:55 AM
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; Leon Rom=
anovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [rdma-next v2 07/23] RDMA/core: Remove unimplemented node_types an=
d node transport

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

There is no need to carry code, which is not implemented in any underlying =
hardware. This patch removes unimplemented node_types and their respective =
node transport layers.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/sysfs.c |  3 ---  drivers/infiniband/core/verbs.c =
|  5 -----
 include/rdma/ib_verbs.h         | 16 ++++++----------
 3 files changed, 6 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysf=
s.c index abc5ab581f82..c43280f8d5b3 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -1146,10 +1146,7 @@ static ssize_t show_node_type(struct device *device,
 switch (dev->node_type) {
 case RDMA_NODE_IB_CA:  return sprintf(buf, "%d: CA\n", dev->node_type);
 case RDMA_NODE_RNIC:  return sprintf(buf, "%d: RNIC\n", dev->node_type);
-case RDMA_NODE_USNIC:  return sprintf(buf, "%d: usNIC\n", dev->node_type);
 case RDMA_NODE_USNIC_UDP: return sprintf(buf, "%d: usNIC UDP\n", dev->node=
_type);
-case RDMA_NODE_IB_SWITCH: return sprintf(buf, "%d: switch\n", dev->node_ty=
pe);
-case RDMA_NODE_IB_ROUTER: return sprintf(buf, "%d: router\n", dev->node_ty=
pe);
 default:  return sprintf(buf, "%d: <unknown>\n", dev->node_type);
 }
 }
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verb=
s.c index 3d1de62de839..21fef6b6d4f3 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -182,13 +182,9 @@ rdma_node_get_transport(enum rdma_node_type node_type)=
  {
 switch (node_type) {
 case RDMA_NODE_IB_CA:
-case RDMA_NODE_IB_SWITCH:
-case RDMA_NODE_IB_ROUTER:
 return RDMA_TRANSPORT_IB;
 case RDMA_NODE_RNIC:
 return RDMA_TRANSPORT_IWARP;
-case RDMA_NODE_USNIC:
-return RDMA_TRANSPORT_USNIC;
 case RDMA_NODE_USNIC_UDP:
 return RDMA_TRANSPORT_USNIC_UDP;
 default:
@@ -207,7 +203,6 @@ enum rdma_link_layer rdma_port_get_link_layer(struct ib=
_device *device, u8 port_
 case RDMA_TRANSPORT_IB:
 return IB_LINK_LAYER_INFINIBAND;
 case RDMA_TRANSPORT_IWARP:
-case RDMA_TRANSPORT_USNIC:
 case RDMA_TRANSPORT_USNIC_UDP:
 return IB_LINK_LAYER_ETHERNET;
 default:
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h index 4ce188=
128aa9..6aec3971628b 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -95,12 +95,9 @@ struct ib_gid_attr {

 enum rdma_node_type {
 /* IB values map to NodeInfo:NodeType. */
-RDMA_NODE_IB_CA =3D 1,
-RDMA_NODE_IB_SWITCH,
-RDMA_NODE_IB_ROUTER,
-RDMA_NODE_RNIC,
-RDMA_NODE_USNIC,
-RDMA_NODE_USNIC_UDP,
+RDMA_NODE_IB_CA=3D 1,
+RDMA_NODE_RNIC=3D 4,
+RDMA_NODE_USNIC_UDP=3D 6,
 };

 enum {
@@ -109,10 +106,9 @@ enum {
 };

 enum rdma_transport_type {
-RDMA_TRANSPORT_IB,
-RDMA_TRANSPORT_IWARP,
-RDMA_TRANSPORT_USNIC,
-RDMA_TRANSPORT_USNIC_UDP
+RDMA_TRANSPORT_IB=3D 0,
+RDMA_TRANSPORT_IWARP=3D 1,
+RDMA_TRANSPORT_USNIC_UDP=3D 3,
 };

 enum rdma_protocol_type {
--
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in th=
e body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  ht=
tp://vger.kernel.org/majordomo-info.html

This correspondence, and any attachments or files transmitted with this cor=
respondence, contains information which may be confidential and privileged =
and is intended solely for the use of the addressee. Unless you are the add=
ressee or are authorized to receive messages for the addressee, you may not=
 use, copy, disseminate, or disclose this correspondence or any information=
 contained in this correspondence to any third party. If you have received =
this correspondence in error, please notify the sender immediately and dele=
te this correspondence and any attachments or files transmitted with this c=
orrespondence from your system, and destroy any and all copies thereof, ele=
ctronic or otherwise. Your cooperation and understanding are greatly apprec=
iated.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
