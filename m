From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 0/3] Add support for TCP segmentation offload (TSO)
Date: Sun, 21 Aug 2016 19:47:58 +0300
Message-ID: <1471798081-19088-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This V1 series addresses a note coming from the list to replace a macro
by a static inline function, details below.

The relevant kernel patches regarding capabilities were already taken into your
tree for coming kernel of 4.8.

The series was tested successfully with mlx5 driver (lib, kernel) and can be
accessed also from my openfabrics GIT at:
git://openfabrics.org/~yishaih/libibverbs.git branch: tso_v1

Yishai

In general,
TSO enables an application to pass a packet with large chunk of data than the
MTU to the NIC and let it breaks into small packets as part of its send flow.
The TSO engine will split the packet into separate packets and insert the
relevant user specified L2/L3/L4 headers automatically.
This is a technique for increasing outbound throughput of high-bandwidth
network connections by reducing CPU overhead.

For some extra information about TSO, below link can be helpful:
https://en.wikipedia.org/wiki/Large_segment_offload

Verbs usage,
TSO traffic is performed by ibv_post_send with opcode IBV_WR_TSO.
The following information should be supplied within the associated send WR:
- A pointer to the packet header.
- Header size.
- The maximum segment size (mss) that hardware should generate in
  its TSO engine.

The above information required to send a TSO packet is similar to the IB kernel
API.  http://lxr.free-electrons.com/source/include/rdma/ib_verbs.h#L1237

The TSO capabilities as of the supported QP types, max TSO payload can be
achieved upon query device.
 
When creating a TSO eligible QP, user should supply the maximum TSO header size
in order to let providers preparing their SQ buffer accordingly. This need is
similar to other capabilities that are given as part of QP creation for that
purpose.

Changes from V0:
patch #2: Change 'ibv_is_qpt_supported' to be a static inline function instead
          of a macro.

Bodong Wang (3):
  Fix ibv_cmd_query_device_ex to return valid output
  Add support for TCP segmentation offload (TSO)
  Update man pages for TSO support

 examples/devinfo.c         | 20 ++++++++++++++++++++
 include/infiniband/verbs.h | 37 +++++++++++++++++++++++++++++--------
 man/ibv_create_qp_ex.3     |  1 +
 man/ibv_post_send.3        | 36 ++++++++++++++++++++++++------------
 man/ibv_query_device_ex.3  | 22 ++++++++++++++--------
 src/cmd.c                  |  9 +--------
 6 files changed, 89 insertions(+), 36 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
