From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 0/6] Add support for Vxlan protocol for the steering rules
Date: Mon, 14 Nov 2016 19:04:46 +0200
Message-ID: <1479143092-11723-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Virtual Extensible LAN - Vxlan is a proposed encapsulation protocol for
running an overlay network on existing Layer 3 infrastructure. An
overlay network is a virtual network that is built on top of existing
network Layer 2 and Layer 3 technologies to support elastic COMPUTE
architectures. Vxlan will make it easier for network engineers to scale
out a cloud computing environment while logically isolating cloud apps
and tenants.

This patchset introduces support Vxlan steering rules to IB/core and
mlx5 devices implementation. The application will be able to send
packet with Vxlan tunneling, and configure a steering rule to receive
the stream from the rule to the QP.

The rule will contain inner and outer parts for the inner and outer
protocol header respectively. The matching is based on the rule
specification and it includes the Vxlan header itself, so application
will be able to send several Vxlan streams with a new vni for each stream.

In order to steer traffic according to a Vxlan tunnel ID, there is a need to
use the ibv_cmd_create_flow call. At the end of the struct, the application
should append several specs for each feature.

The number of specifications to add is 4. Use the first as the Vxlan
spec (tunnel), which is described below. The following specifications to
add are the L2, L3, and L4 specs.

There is an option to mask a range of tunnel IDs to be steered by using
the filler mask, This following example provides the ibv_flow_tunnel_filter
struct definition:

struct ibv_flow_tunnel_filter {
        uint32_t tunnel_id;
};

This following example specifies the Vxlan tunnel definition:

struct ibv_flow_spec_tunnel {
        enum ibv_flow_spec_type  type;
        uint16_t  size;
        struct ibv_flow_tunnel_filter val;
        struct ibv_flow_tunnel_filter mask;
};

Where:

 * type - Specifies that there is a need to use IBV_FLOW_SPEC_VXLAN_TUNNEL
	to define the spec as an Vxlan spec.
 * size - Identifies the size of the ibv_kern_spec_tunnel.
 * tunnel_id: Indicates that the tunnel ID as in the Vxlan header.


Thanks,
	Mosses and Leon.

Available in the "topic/vxlan" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/vxlan

CC: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Moses Reuben (6):
  IB/core: Add flow spec tunneling support
  IB/core: Align structure ib_flow_spec_type
  IB/uverbs: Add support for Vxlan protocol
  IB/mlx5: Support Vxlan tunneling specification
  IB/core: Introduce inner flow steering
  IB/mlx5: Add support to match inner packet fields

 drivers/infiniband/core/uverbs_cmd.c |  19 ++++-
 drivers/infiniband/hw/mlx5/main.c    | 142 ++++++++++++++++++++++-------------
 include/rdma/ib_verbs.h              |  44 +++++++----
 include/uapi/rdma/ib_user_verbs.h    |  17 +++++
 4 files changed, 155 insertions(+), 67 deletions(-)

--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
