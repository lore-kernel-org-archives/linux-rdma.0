From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 0/5] Flow steering improvements
Date: Wed,  5 Apr 2017 18:19:19 +0300
Message-ID: <1491405564-19735-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set from Artemy introduces to user applications some extra flow
steering specifications, the matching kernel part was already accepted in
kernel 4.10.

Specifically, below specifications are added:
IBV_FLOW_SPEC_VXLAN_TUNNEL, IBV_FLOW_SPEC_INNER, IBV_FLOW_SPEC_ACTION_TAG.

Virtual eXtensible LAN (VXLAN) is a proposed encapsulation protocol for running
an overlay network on existing Layer 3 infrastructure. An overlay network is a
virtual network that is built on top of existing network Layer 2 and Layer 3
technologies to support elastic COMPUTE architectures. VXLAN will make it
easier for network engineers to scale out a cloud computing environment while
logically isolating cloud apps and tenants.

This patch set introduces support of VXLAN protocol for ibv_create_flow API.
The application will be able to send a packet with VXLAN tunneling, and
configure a steering rule to receive this stream based on its tunnel_id using
the IBV_FLOW_SPEC_VXLAN_TUNNEL specification.

In addition, an inner flow specification (i.e. IBV_FLOW_SPEC_VXLAN_TUNNEL)
was added letting the application to set a rule on the inner protocol.
 
When one of the L2/L3/L4 flow specification types is or-combined with
IBV_FLOW_SPEC_INNER, then the filter is applied on the inner packet header.
The flow specifications can contain inner and outer parts for the inner and
outer protocol headers respectively.  The match is done based on the inner and
outer flow specifications and can include the VXLAN_TUNNEL specification as
well.

Flow tag specification (i.e. IBV_FLOW_SPEC_ACTION_TAG) allows an application
to request an action to tag the matching packets with a given tag id.

The matching is done based on the L2/L3/L4 flow specifications, where the
application builds several spec's, each spec defined field on the header it
applied for. The number of specifications to add is one for each layer and one
more for the flow tag action which contains the tag_id number.

Application can read the flow tag by using the extended ibv_cq_ex
with the new read method:
uint32_t ibv_wc_read_flow_tag(struct ibv_cq_ex *cq)

Pull request was sent:
https://github.com/linux-rdma/rdma-core/pull/114

Artemy Kovalyov (5):
  ibverbs: Add tunnel VXLAN flow specification
  ibverbs: Add inner flow specification support
  ibverbs: Add flow tag specification
  ibverbs: Add support for reading flow tag from a CQ
  mlx5: Add read_flow_tag implementation

 libibverbs/cmd.c                  | 38 +++++++++++++++++++++++++++++++--
 libibverbs/kern-abi.h             | 21 +++++++++++++++++++
 libibverbs/man/ibv_create_cq_ex.3 |  4 ++++
 libibverbs/man/ibv_create_flow.3  |  3 +++
 libibverbs/verbs.h                | 44 ++++++++++++++++++++++++++++++++-------
 providers/mlx5/cq.c               |  9 ++++++++
 providers/mlx5/mlx5.h             |  4 ++++
 providers/mlx5/verbs.c            |  3 ++-
 8 files changed, 116 insertions(+), 10 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
