From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V4 for-next 00/10] Verbs RSS
Date: Mon, 23 May 2016 15:20:46 +0300
Message-ID: <1464006056-19653-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This V4 series addressed the note to move RSS hash capabilities
from the common udata to be part of vendor specific data.
As was agreed in the OFAWG meeting, WQ and indirection table
are common objects. The last 3 patches were changed
accordingly.

As the RSS series already missed few kernel merging, would appreciate
if it can be taken into 4.7.

Thanks,
Yishai
 

RSS (Receive Side Scaling) technology allows to spread incoming traffic
between different receive descriptor queues.
Assigning each queue to different CPU cores allows to better load
balance the incoming traffic and improve performance.

This patch-set introduces some new objects and verbs in order to allow
verbs based solutions to utilize the RSS offload capability which is
widely supported today by many modern NICs. It extends the IB and uverbs
layers to support the above functionality and supplies a specific
implementation for the mlx5_ib driver.

The implementation is based on an RFC that was sent to the list some
months ago and describes the expected verbs and objects.
RFC: http://www.spinics.net/lists/linux-rdma/msg25012.html

In addition, below URL can be used as a reference to the motivation and
the justification to add the new objects that are described below.
http://lxr.free-electrons.com/source/Documentation/networking/scaling.txt

Overview of the changes:
- Add new objects: Work Queue and Receive Work Queues Indirection Table.
- Add new verbs that are required to handle the new objects:
  ib_create_wq(), ib_modify_wq(), ib_destory_wq(),
  ib_create_rwq_ind_table(), ib_destroy_rwq_ind_table().
- Extend ib_create_qp() to get Receive Work Queues Indirection Table.

Work Queue: (ib_wq)
- Work Queue is associated (many to one) with  Completion Queue.
- It owns Work Queue properties (PD, WQ size etc.).
- Currently Work Queue type can be IB_WQT_RQ (receive queue), other ones
  may be added in the future. (e.g. IB_WQT_SQ, send queue)
- Work Queue from type IB_WQT_RQ contains receive work requests.
- Work Queue context is subject to a well-defined state transitions done
  by the modify_wq verb.
- Work Queue is a necessary component for RSS technology since RSS
  mechanism is supposed to distribute the traffic between multiple
  Receive Work Queues.

Receive Work Queue Indirection Table: (ib_rwq_ind_tbl)
- Serves to spread traffic between Work Queues from type RQ.
- Can be modified dynamically to give different queues different relative
  weights.
- The receive queue for a packet is determined by computed hash for the
  incoming packet.
- Receive Work Queue Indirection Table is associated (one to many) with QPs.

RSS hashing configuration:
- Should be used to compute the required RQ entry for the incoming packet.
- It includes:
    * The hashing function used to choose the WQ from this table.
    * The packet's properties that the hashing function should use.
    * Was changed to be vendor specific based on OFAWG verbs discussion.

Future extensions to this patch-set:
- Add ib_modify_rwq_ind_table() verb to enable a dynamic RQ mapping change.
- Reflect RSS capabilities by the query device verb.
- User space support (i.e. libibverbs/vendor drivers) to expose the new verbs
  and objects.

Patches:
#1:  Exposes the required APIs from mlx5_core to be used in coming patches
     by mlx5_ib driver.
#2:  Introduces the Work Queue object and its verbs in the IB layer.
#3:  Adds uverbs support for the Work Queue verbs.
#4:  Implements the Work Queue verbs in mlx5_ib driver.
#5:  Introduces Receive Work Queue indirection table and its verbs in
     the IB layer.
#6:  Adds uverbs support for the Receive Work Queue indirection table verbs.
#7:  Implements the Receive Work Queue indirection table verbs in mlx5_ib driver.
#8:  Extends create QP to get indirection table in the IB layer.
#9:  Extends create QP to get indirection table in the uverbs layer.
#10: Adds RSS QP support in mlx5_ib driver.

Changes from V3:
Move hash properties from the common udata to be vendor specific data.

Changes from V2:
- Improve the new verbs to enable clean future extensions in both uverbs
  and mlx5_ib layers.
- Add the last three patches to enable RSS QP creation.

Changes from V1:
#patch #2: Change ib_modify_wq to use u32 instead of enum for bit wise values.
#patch #3: Improve usage of attr_mask/comp_mask.
#patch #4: Fix driver issue in mlx5_ib in PPC.
#patch #6: Limit un-expected memory allocation.

Changes from V0:
patch #2: Move the new verbs documentation to be in the C file,
          improve the commit message.
patch #5: Move the new verbs documentation to be in the C file.

Yishai Hadas (10):
  net/mlx5: Export required core functions to support RSS
  IB/core: Introduce Work Queue object and its verbs
  IB/uverbs: Add WQ support
  IB/mlx5: Add receive Work Queue verbs
  IB/core: Introduce Receive Work Queue indirection table
  IB/uverbs: Introduce RWQ Indirection table
  IB/mlx5: Add Receive Work Queue Indirection table operations
  IB/core: Extend create QP to get indirection table
  IB/uverbs: Extend create QP to get RWQ indirection table
  IB/mlx5: Add RSS QP support

 drivers/infiniband/core/uverbs.h                   |  12 +
 drivers/infiniband/core/uverbs_cmd.c               | 528 ++++++++++++++++++-
 drivers/infiniband/core/uverbs_main.c              |  38 ++
 drivers/infiniband/core/verbs.c                    | 163 +++++-
 drivers/infiniband/hw/mlx5/main.c                  |  12 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  54 ++
 drivers/infiniband/hw/mlx5/qp.c                    | 584 +++++++++++++++++++++
 drivers/infiniband/hw/mlx5/user.h                  |  64 +++
 drivers/net/ethernet/mellanox/mlx5/core/transobj.c |   4 +
 include/rdma/ib_verbs.h                            |  85 ++-
 include/uapi/rdma/ib_user_verbs.h                  |  77 +++
 11 files changed, 1605 insertions(+), 16 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
