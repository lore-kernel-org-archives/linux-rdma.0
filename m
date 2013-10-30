From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC v1 00/10] Introduce Signature feature
Date: Wed, 30 Oct 2013 12:29:36 +0200
Message-ID: <5270DF90.8000802@mellanox.com>
References: <1382970376-13776-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382970376-13776-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 28/10/2013 16:26, Sagi Grimberg wrote:
> This patchset Introduces Verbs level support for signature handover
> feature. Siganture is intended to implement end-to-end data integrity
> on a transactional basis in a completely offloaded manner.

Hi Roland, Sean

These patches are around for few weeks, they set the grounds for 
implementing accelerated/support for T10 DIF in the upstream SCSI target 
LIO iser driver and the upstream iser initiator. For that end, we expect 
some changes to take place in each of the domains/sub-systems and don't 
want to makeit a three/four way (e.g 
LIO/iSCSI/iser_i/iser_t/verbs/driver) merge.

The team here enhanced krping to fully cover (and test...) the proposed 
API and driver implementation, its (free) under
git://beany.openfabrics.org/~sgrimberg/krping.git

We'd like to see this landing in 3.13 such that the development of the 
upper layers can run for 3.14 and and later kernels. Sagi will postV2 
with the two minor changes that came up in Sean's review of V1, thoughts?

Or.
>
> There are several end-to-end data integrity methods used today in various
> applications and/or upper layer protocols such as T10-DIF defined by SCSI
> specifications (SBC), CRC32, XOR8 and more. This patchset adds verbs
> support only for T10-DIF. The proposed framework allows adding more
> signature methods in the future.
>
> In T10-DIF, when a series of 512-byte data blocks are transferred, each
> block is followed by an 8-byte guard. The guard consists of CRC that
> protects the integrity of the data in the block, and some other tags
> that protects against mis-directed IOs.
>
> Data can be protected when transferred over the wire, but can also be
> protected in the memory of the sender/receiver. This allows true end-
> to-end protection against bits flipping either over the wire, through
> gateways, in memory, over PCI, etc.
>
> While T10-DIF clearly defines that over the wire protection guards are
> interleaved into the data stream (each 512-Byte block followed by 8-byte
> guard), when in memory, the protection guards may reside in a buffer
> separated from the data. Depending on the application, it is usually
> easier to handle the data when it is contiguous. In this case the data
> buffer will be of size 512xN and the protection buffer will be of size
> 8xN (where N is the number of blocks in the transaction).
>
> There are 3 kinds of signature handover operation:
> 1. Take unprotected data (from wire or memory) and ADD protection
>     guards.
> 2. Take protetected data (from wire or memory), validate the data
>     integrity against the protection guards and STRIP the protection
>     guards.
> 3. Take protected data (from wire or memory), validate the data
>     integrity against the protection guards and PASS the data with
>     the guards as-is.
>
> This translates to defining to the HCA how/if data protection exists
> in memory domain, and how/if data protection exists is wire domain.
>
> The way that data integrity is performed is by using a new kind of
> memory region: signature-enabled MR, and a new kind of work request:
> REG_SIG_MR. The REG_SIG_MR WR operates on the signature-enabled MR,
> and defines all the needed information for the signature handover
> (data buffer, protection buffer if needed and signature attributes).
> The result is an MR that can be used for data transfer as usual,
> that will also add/validate/strip/pass protection guards.
>
> When the data transfer is successfully completed, it does not mean
> that there are no integrity errors. The user must afterwards check
> the signature status of the handover operation using a new light-weight
> verb.
>
> This feature shall be used in storage upper layer protocols iSER/SRP
> implementing end-to-end data integrity T10-DIF. Following this patchset,
> we will soon submit krping patches which will demonstrate the usage of
> these signature verbs.
>
> Patchset summary:
> - Intoduce verbs for create/destroy memory regions supporting signature.
> - Introduce IB core signature verbs API.
> - Implement mr create/destroy verbs in mlx5 driver.
> - Preperation patches for signature support in mlx5 driver.
> - Implement signature handover work request in mlx5 driver.
> - Implement signature error collection and handling in mlx5 driver.
>
> Changes from v0:
> - Commit messages: Added more detailed explanation for signature work request.
> - IB/core: Remove indirect memory registration enablement from create_mr.
>             Keep only signature enablement.
> - IB/mlx5: Changed signature error processing via MR radix lookup.
>
> Sagi Grimberg (10):
>    IB/core: Introduce protected memory regions
>    IB/core: Introduce Signature Verbs API
>    IB/mlx5, mlx5_core: Support for create_mr and destroy_mr
>    IB/mlx5: Initialize mlx5_ib_qp signature related
>    IB/mlx5: Break wqe handling to begin & finish routines
>    IB/mlx5: remove MTT access mode from umr flags helper function
>    IB/mlx5: Keep mlx5 MRs in a radix tree under device
>    IB/mlx5: Support IB_WR_REG_SIG_MR
>    IB/mlx5: Collect signature error completion
>    IB/mlx5: Publish support in signature feature
>
>   drivers/infiniband/core/verbs.c                |   47 +++
>   drivers/infiniband/hw/mlx5/cq.c                |   53 +++
>   drivers/infiniband/hw/mlx5/main.c              |   12 +
>   drivers/infiniband/hw/mlx5/mlx5_ib.h           |   14 +
>   drivers/infiniband/hw/mlx5/mr.c                |  138 +++++++
>   drivers/infiniband/hw/mlx5/qp.c                |  525 ++++++++++++++++++++++--
>   drivers/net/ethernet/mellanox/mlx5/core/main.c |    1 +
>   drivers/net/ethernet/mellanox/mlx5/core/mr.c   |   84 ++++
>   include/linux/mlx5/cq.h                        |    1 +
>   include/linux/mlx5/device.h                    |   43 ++
>   include/linux/mlx5/driver.h                    |   35 ++
>   include/linux/mlx5/qp.h                        |   62 +++
>   include/rdma/ib_verbs.h                        |  172 ++++++++-
>   13 files changed, 1148 insertions(+), 39 deletions(-)
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
