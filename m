From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v5 00/10] Introduce Signature feature
Date: Sun, 23 Feb 2014 14:19:03 +0200
Message-ID: <1393157953-24834-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patchset Introduces Verbs level support for signature handover feature.
Siganture is intended to implement end-to-end data integrity on a transactional
basis in a completely offloaded manner.

There are several end-to-end data integrity methods used today in various
applications and/or upper layer protocols such as T10-DIF defined by SCSI
specifications (SBC), CRC32, XOR8 and more. This patchset adds verbs support
only for T10-DIF. The proposed framework allows adding more signature methods
in the future.

In T10-DIF, when a series of 512-byte data blocks are transferred, each block
is followed by an 8-byte guard (note that other protection intervals may be used
other then 512-bytes). The guard consists of CRC that protects the integrity of
the data in the block, and tag that protects against mis-directed IOs and a free
tag for application use.

Data can be protected when transferred over the wire, but can also be protected
in the memory of the sender/receiver. This allows true end- to-end protection
against bits flipping either over the wire, through gateways, in memory, over PCI, etc.

While T10-DIF clearly defines that over the wire protection guards are interleaved
into the data stream (each 512-Byte block followed by 8-byte guard), when in memory,
the protection guards may reside in a buffer separated from the data. Depending on the
application, it is usually easier to handle the data when it is contiguous.
In this case the data buffer will be of size 512xN and the protection buffer will
be of size 8xN (where N is the number of blocks in the transaction).

There are 3 kinds of signature handover operation:
1. Take unprotected data (from wire or memory) and ADD protection
   guards.
2. Take protetected data (from wire or memory), validate the data
   integrity against the protection guards and STRIP the protection
   guards.
3. Take protected data (from wire or memory), validate the data
   integrity against the protection guards and PASS the data with
   the guards as-is.

This translates to defining to the HCA how/if data protection exists in memory domain,
and how/if data protection exists is wire domain.

The way that data integrity is performed is by using a new kind of memory
region: signature-enabled MR, and a new kind of work request: REG_SIG_MR.
The REG_SIG_MR WR operates on the signature-enabled MR, and defines all the
needed information for the signature handover (data buffer, protection buffer
if needed and signature attributes). The result is an MR that can be used for
data transfer as usual, that will also add/validate/strip/pass protection guards.

When the data transfer is successfully completed, it does not mean that there are
no integrity errors. The user must afterwards check the signature status of the
handover operation using a new light-weight verb.

This feature shall be used in storage upper layer protocols iSER/SRP implementing
end-to-end data integrity T10-DIF. Following this patchset, ib_iser/ib_isert
will use these verbs for T10-PI offload support.

Patchset summary:
- Intoduce verbs for create/destroy memory regions supporting signature.
- Introduce IB core signature verbs API.
- Implement mr create/destroy verbs in mlx5 driver.
- Preperation patches for signature support in mlx5 driver.
- Implement signature handover work request in mlx5 driver.
- Implement signature error collection and handling in mlx5 driver.

Changes from v4:
- Update to for-next 3.14-rc2
- IB/mlx5: Fix smatch warning.
- IB/mlx5: Fix signature rules constants.
- IB/mlx5: Allow create_qp to receive sig_enable create flag.
- IB/mlx5: Remove redundant asignment.

Changes from v3 (mostly bug fixes):
- IB/core: Generalized ib_check_sig_status to a general ib_check_mr_status
           for other light-weight status checks that may be used on ib_mr.
- IB/core: Changed ib_sig_err to inform only expected and actual values
           of the corrupted field (block guard, reference tag or application tag).
- IB/mlx5: Fail un-supported protection intervals.
- IB/mlx5: Fxied possible SQ corruption in REG_SIG_MR.
- IB/mlx5: Fixed wr iterator wrong incrementation in mlx5_ib_post_send.
- IB/mlx5: Avoid expanding the SQ depth for signature when wqe_size is
           sufficient.

Changes from v2 (mostly CR comments):
- IB/core: Added comment on IB_T10DIF_CRC/CSUM declarations.
- IB/core: Renamed block_size as pi_interval in ib_sig_attrs.
- IB/core: Took t10_dif domain out of sig union (ib_sig_domain).
- IB/mlx5: Fixed memory leak in create_mr
- IB/mlx5: Remove redundant assignment in WQE initialization.
- IB/mlx5: Fixed possible NULL dereference in check_sig_status
           and set_sig_wr.
- IB/mlx5: Added helper function to convert mkey to base key.
- IB/mlx5: Reduced Fencing in compund REG_SIG_MR WR.
- Resolved checkpatch warnings.

Changes from v1:
- IB/core: Reduced sizeof ib_send_wr by using wr->sg_list for data
           and dedicated ib_sge for protection guards buffer.
           Currently sig_handover extension does not increase sizeof ib_send_wr
- IB/core: Change enum to int for container variables.
- IB/mlx5: Validate wr->num_sge=1 for REG_SIG_MR work request.

Changes from v0:
- Commit messages: Added more detailed explanation for signature work request.
- IB/core: Remove indirect memory registration enablement from create_mr.
           Keep only signature enablement.
- IB/mlx5: Changed signature error processing via MR radix lookup.

Sagi Grimberg (10):
  IB/core: Introduce protected memory regions
  IB/core: Introduce Signature Verbs API
  IB/mlx5, mlx5_core: Support for create_mr and destroy_mr
  IB/mlx5: Initialize mlx5_ib_qp signature related
  IB/mlx5: Break wqe handling to begin & finish routines
  IB/mlx5: remove MTT access mode from umr flags helper function
  IB/mlx5: Keep mlx5 MRs in a radix tree under device
  IB/mlx5: Support IB_WR_REG_SIG_MR
  IB/mlx5: Collect signature error completion
  IB/mlx5: Publish support in signature feature

 drivers/infiniband/core/verbs.c                |   47 ++
 drivers/infiniband/hw/mlx5/cq.c                |   63 +++
 drivers/infiniband/hw/mlx5/main.c              |   12 +
 drivers/infiniband/hw/mlx5/mlx5_ib.h           |   14 +
 drivers/infiniband/hw/mlx5/mr.c                |  158 +++++++
 drivers/infiniband/hw/mlx5/qp.c                |  540 ++++++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx5/core/main.c |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/mr.c   |   85 ++++
 include/linux/mlx5/cq.h                        |    1 +
 include/linux/mlx5/device.h                    |   43 ++
 include/linux/mlx5/driver.h                    |   41 ++
 include/linux/mlx5/qp.h                        |   67 +++
 include/rdma/ib_verbs.h                        |  187 ++++++++-
 13 files changed, 1217 insertions(+), 42 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
