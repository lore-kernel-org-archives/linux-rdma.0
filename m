From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 0/5] Add flow tag support to flow specification
Date: Wed, 18 Jan 2017 14:59:46 +0200
Message-ID: <20170118125951.3469-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rony Efraim <ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

The flow tag feature allows an application to request to add an action
to tag all the packets that matches this rule.

The tag is a number that will came as a metadata with every packet in
the CQE.

The tag rule == 0 is chosen as the default tag and application can use
it in order to avoid the need to classify the packets that came with a
tag while continuing to benefit from this tag mechanism.

struct definition:

struct ib_uverbs_flow_spec_action_tag {
     union {
          struct ib_uverbs_flow_spec_hdr hdr;
          struct {
              __u32 type;
              __u16 size;
              __u16 reserved;
          };
     };
     __be32                   tag_id;
     __u32                    reserved1;
};

struct ib_uverbs_flow_spec {
     union {
          union {
              struct ib_uverbs_flow_spec_hdr hdr;
              struct {
                   __u32 type;
                   __u16 size;
                   __u16 reserved;
              };
          };
          struct ib_uverbs_flow_spec_eth     eth;
          struct ib_uverbs_flow_spec_ipv4    ipv4;
          struct ib_uverbs_flow_spec_tcp_udp tcp_udp;
          struct ib_uverbs_flow_spec_ipv6    ipv6;
          struct ib_uverbs_flow_spec_action_tag flow_tag;
     };
};

Where:

* type, size, reserved fields are identical to the rest of the
* protocols,
   and are used to identify the spec.
* flow_tag is a spec of type 'action'
* the ib_uverbs_flow_spec_hdr is identical to the rest of the specs.
* tag_id - is the value of the stream defined by the specs.

Thanks,
	Moses

CC: Rony Efraim <ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
----

Doug,
I used this opportunity and fixed parse_flow_attr(..) return values.
Adjusting this fix to this series minimizes chances of possible merge
conflicts between different series.

This patchset was generated against commit
f502d834950a ("net/mlx5: Activate support for 4K UARs") and it applies
cleanly on k.o/for-4.11 branch.

Available in the "topic/flow-tag" topic branch of this git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git

Or for browsing:
https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=topic/flow-tag

Leon Romanovsky (1):
  IB/mlx5: Replace ENOTSUPP usage with EOPNOTSUPP

Maor Gottlieb (1):
  net/mlx5: Consolidate flow rules regardless their flow tag

Moses Reuben (3):
  IB/core: Introduce flow tag specification
  IB/uverbs: Add support for flow tag
  IB/mlx5: Add flow tag support

 drivers/infiniband/core/uverbs.h                  |  1 +
 drivers/infiniband/core/uverbs_cmd.c              | 35 +++++++++++++++++++--
 drivers/infiniband/hw/mlx5/main.c                 | 38 +++++++++++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 12 +++++--
 include/rdma/ib_verbs.h                           |  9 ++++++
 include/uapi/rdma/ib_user_verbs.h                 | 13 ++++++++
 6 files changed, 95 insertions(+), 13 deletions(-)

--
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
