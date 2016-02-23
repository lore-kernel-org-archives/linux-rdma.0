From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: [PATCH rdma-next V1 0/8] Introduce vector CALC support
Date: Tue, 23 Feb 2016 10:25:20 +0200
Message-ID: <1456215928-9305-1-git-send-email-leon@leon.nu>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This patch set introduces vector CALC support.

This feature takes as input several vectors of equal length,
combines them with a single operation type, producing result vectors
which are sent to the destination.

The proposed operations are "add, and, or, xor, max, min" and "swap
endianness".

The hardware processes the data an MTU of at a time, processing the elements
of each segment in parallel.

This patch set depends on commit b4ff3a36d3e4 ("net/mlx5: Use offset based
reserved field names in the IFC header file") which is part of net tree.

The series consists from two parts: IB and net.

NET part (patches #1-3)
* Patch #1 fixes ATOMIC capability mode. This change has  no impact on
* the system, since MAX property is not in use for ATOMIC.
* Patch #2 merges two device capability calls in one.
* Patch #3 adds infrastructure to support vector CALC querying.

IB part (patches #4-8)
* Patch #4 refactors device query code by eliminating the unnecessary zeroing
  of variables
* Patch #5 converts device capability mask from u32 to be u64 and support more
  than 32 device capabilities.
* Patch #6 adds vector CALC device capability flag.
* Patch #7 exports all possible supported operations.
* Patch #8 advertises the mlx5 driver support of vector CALC.

Changes since v0:
- Fixed author part of patch #3
- Updated hca_cap field in ipoib to be u64 and not u32.
- Enrich commit message of patch #7

Leon Romanovsky (7):
  net/mlx5_core: Fix caching ATOMIC endian mode capability
  net/mlx5_core: Refactor device capability function
  IB/core: Replace setting the zero values in ib_uverbs_ex_query_device
  IB/{core,ulp} Support above 32 possible device capability flags
  IB/core: Add offload arithmetic operations support
  IB/core: Advertise supported vector CALC capabilities
  IB/mlx5: Exposure offload arithmetic operations

Sagi Grimberg (1):
  net/mlx5_core: Introduce offload arithmetic hardware capabilities

 drivers/infiniband/core/uverbs_cmd.c           | 29 +++++++------
 drivers/infiniband/hw/mlx5/main.c              |  3 ++
 drivers/infiniband/ulp/ipoib/ipoib.h           |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c   | 57 ++++++--------------------
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 24 +++++++----
 include/linux/mlx5/device.h                    |  6 +++
 include/linux/mlx5/driver.h                    |  3 +-
 include/linux/mlx5/mlx5_ifc.h                  | 31 +++++++++++++-
 include/rdma/ib_verbs.h                        | 29 ++++++++++++-
 include/uapi/rdma/ib_user_verbs.h              | 13 ++++++
 10 files changed, 124 insertions(+), 73 deletions(-)

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
