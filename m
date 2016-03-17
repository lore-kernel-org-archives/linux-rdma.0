From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Thu, 17 Mar 2016 13:31:02 -0400
Message-ID: <56EAE9D6.2030908@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MPArqUWTtPtQsOvss7MV0g5aCHGQJ9bWR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MPArqUWTtPtQsOvss7MV0g5aCHGQJ9bWR
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is the first of two pull requests.  It is the smaller request, but
touches for more different things (this is everything but what is in or
going into staging).  The pull request for the code in staging/rdma is
on hold until after we decide what to do on the write/writev API issue
and may be partially deferred until 4.7 as a result.

There is the one merge issue between the net tree and this tree that was
simple and obvious to fix up.  I've had a phone call with Mellanox about
how to avoid this in the future (the result of that conversation was
that when they have a pre-req patch that is going through Dave's tree,
but the dependent patches are going through my tree, then they should
submit the pre-req patch to me as well, we can carry identical patches
in both trees, and when you merge the duplicate patches will just drop
one and then there will be no merge issue).

Here's the boilerplate of the request:

The following changes since commit fc77dbd34c5c99bce46d40a2491937c3bcbd10=
af:

  Linux 4.5-rc6 (2016-02-28 08:41:20 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to 082eaa50838c6b70a8244f8b01d7ed7d686f84db:

  Merge branches 'nes', 'cxgb4' and 'iwpm' into k.o/for-4.6 (2016-03-16
13:57:43 -0400)

----------------------------------------------------------------
Initial roundup of 4.6 merge window patches

- cxgb4 updates
- nes updates
- unification of iwarp portmapper code to core
- add drain_cq API
- various ib_core updates
- minor ipoib updates
- minor mlx4 updates
- more significant mlx5 updates (including a minor merge conflict with
  net-next tree...merge is simple to resolve and Stephen's resolution was=

  confirmed by Mellanox)
- trivial net/9p rdma conversion
- ocrdma RoCEv2 update
- srpt updates

----------------------------------------------------------------
Abhilash Jindal (1):
      IB/mlx4: Use boottime

Amitoj Kaur Chawla (1):
      IB/core: Replace memset with eth_zero_addr

Arnd Bergmann (1):
      infiniband: cxgb4: use %pR format string for printing resources

Bart Van Assche (21):
      IB/srpt: Simplify srpt_handle_tsk_mgmt()
      IB/srpt: Add parentheses around sizeof argument
      IB/srpt: Remove struct srpt_node_acl
      IB/srpt: Inline srpt_sdev_name()
      IB/srpt: Inline srpt_get_ch_state()
      IB/srpt: Introduce target_reverse_dma_direction()
      IB/srpt: Use scsilun_to_int()
      IB/srpt: Simplify channel state management
      IB/srpt: Simplify srpt_shutdown_session()
      IB/srpt: Fix srpt_close_session()
      IB/srpt: Fix srpt_handle_cmd() error paths
      IB/srpt: Fix how aborted commands are processed
      IB/srpt: Inline trivial CM callback functions
      IB/srpt: Eliminate srpt_find_channel()
      IB/srpt: Log private data associated with REJ
      IB/srpt: Use a mutex to protect the channel list
      IB/srpt: Detect session shutdown reliably
      IB/srpt: Fix srpt_write_pending()
      IB/srpt: Log out all initiators if a port is disabled
      IB/srpt: Introduce srpt_process_wait_list()
      IB/srpt: Fix wait list processing

Ben Hutchings (1):
      RDMA/nes: Replace LRO with GRO

Christoph Hellwig (2):
      IB/mlx5: Convert UMR CQ to new CQ API
      net/9p: convert to new CQ API

Devesh Sharma (3):
      RDMA/ocrdma: Support RoCE-v2 in the UD path
      RDMA/ocrdma: Support RoCE-v2 in the RC path
      RDMA/ocrdma: Support user AH creation for RoCE-v2

Doug Ledford (5):
      Merge branch 'k.o/for-4.5-rc' into HEAD
      IB/mlx5: Make coding style more consistent
      Merge branches 'ib_core', 'ib_ipoib', 'srpt', 'drain-cq-v4' and
'net/9p' into k.o/for-4.6
      Merge branches 'mlx4', 'mlx5' and 'ocrdma' into k.o/for-4.6
      Merge branches 'nes', 'cxgb4' and 'iwpm' into k.o/for-4.6

Eli Cohen (3):
      IB/core: Avoid duplicate code
      IB/core: IB/core: Allow legacy verbs through extended interfaces
      IB/core: Modify conditional on ucontext existence

Erez Shitrit (3):
      IB/mlx5: Define interface bits for IPoIB offloads
      IB/mlx5: Implement UD QP offloads for IPoIB in the TX flow
      IB/mlx5: Add support for CSUM in RX flow

Faisal Latif (3):
      iwcm: common code for port mapper
      iw_nes: remove port mapper related code
      iwpm: crash fix for large connections test

Haggai Eran (10):
      IB/mlx5: Add support for setting source QP number
      IB/mlx5: Modify QP debugging prints
      IB/mlx5: Add GSI QP wrapper
      IB/mlx5: Create multiple transmission GSI QPs
      IB/mlx5: Create GSI transmission QPs when P_Key table is changed
      IB/mlx5: Generate completions in software
      IB/mlx5: Reorder GSI completions
      IB/mlx5: Pick the right GSI transmission QP for sending
      IB/mlx5: Eliminate GSI RX QP's send buffers
      IB/cma: Print warning on different inner and header P_Keys

Hal Rosenstock (1):
      IB/core: Documentation fix in the MAD header file

Hans Westgaard Ry (1):
      IB/ipoib: Add handling for sending of skb with many frags

Hariprasad S (4):
      iw_cxgb4: make queue allocation code more readable
      iw_cxgb4: remove false error log entry
      cxgb4/iw_cxgb4: TOS support
      iw_cxgb4: Max fastreg depth depends on DSGL support

Insu Yun (1):
      nes: handling failed allocation when creating workqueue

Leon Romanovsky (1):
      IB/core: Fix missed clean call in registration path

Majd Dibbiny (2):
      IB/mlx5: Avoid using user-index for SRQs
      IB/{core, mlx5}: Fix input len in vendor part of create_qp/srq

Maor Gottlieb (3):
      net/mlx5_core: Create anchor of last flow table
      net/mlx5_core: Introduce forward to next priority action
      IB/mlx5: Add support for don't trap rules

Marina Varshaver (2):
      IB/core: Add don't trap flag to flow creation
      IB/mlx4: Add support for the don't trap rule

Markus Elfring (3):
      IB/ocrdma: Delete unnecessary variable initialisations in 11 functi=
ons
      IB/ocrdma: Skip using unneeded intermediate variable
      IB/ocrdma: Skip using unneeded intermediate variable

Matan Barak (3):
      net/mlx5: Refactor mlx5_core_mr to mkey
      IB/core: Add vendor's specific data to alloc mw
      IB/mlx5: Add memory windows allocation support

Meny Yossefi (3):
      net/mlx5_core: Add helper function to read virtual port counters
      net/mlx5_core: Add helper function to read IB error counters
      IB/mlx5: Modify MAD reading counters method to use counter register=
s

Noa Osherovich (2):
      IB/mlx5: Refactoring register MR code
      IB/mlx5: Added support for re-registration of MRs

Parav Pandit (1):
      IB/core: trivial prink cleanup.

Sagi Grimberg (4):
      IB/mlx5: Expose correct max_fast_reg_page_list_len
      IB/core: Add arbitrary sg_list support
      mlx5: Add arbitrary sg list support
      iser: Accept arbitrary sg lists mapping if the device supports it

Somnath Kotur (1):
      RDMA/ocrdma: Export udp encapsulation capability

Steve Wise (6):
      IB: new common API for draining queues
      iw_cxgb4: add queue drain functions
      IB/srp: Use ib_drain_rq()
      IB/iser: Use ib_drain_sq()
      iw_cxgb4: remove port mapper related code
      iw_cxgb3: support for iWARP port mapping

 drivers/infiniband/core/cache.c                   |  15 +-
 drivers/infiniband/core/cma.c                     |  22 +-
 drivers/infiniband/core/device.c                  |  29 +-
 drivers/infiniband/core/fmr_pool.c                |  37 +-
 drivers/infiniband/core/iwcm.c                    | 190 ++++-
 drivers/infiniband/core/iwpm_msg.c                |  12 +-
 drivers/infiniband/core/iwpm_util.c               |  14 +-
 drivers/infiniband/core/iwpm_util.h               |   2 +-
 drivers/infiniband/core/packer.c                  |  14 +-
 drivers/infiniband/core/sa_query.c                |  13 +-
 drivers/infiniband/core/ucm.c                     |   8 +-
 drivers/infiniband/core/ucma.c                    |   6 +-
 drivers/infiniband/core/ud_header.c               |  23 +-
 drivers/infiniband/core/uverbs_cmd.c              |  25 +-
 drivers/infiniband/core/uverbs_main.c             |  80 +-
 drivers/infiniband/core/verbs.c                   | 166 ++++
 drivers/infiniband/hw/cxgb3/iwch_cm.c             |  16 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c       |   3 +-
 drivers/infiniband/hw/cxgb4/cm.c                  | 274 ++-----
 drivers/infiniband/hw/cxgb4/cq.c                  |   9 +-
 drivers/infiniband/hw/cxgb4/device.c              |  72 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h            |  49 +-
 drivers/infiniband/hw/cxgb4/mem.c                 |  12 +-
 drivers/infiniband/hw/cxgb4/provider.c            |   5 +-
 drivers/infiniband/hw/cxgb4/qp.c                  | 107 +--
 drivers/infiniband/hw/mlx4/alias_GUID.c           |   6 +-
 drivers/infiniband/hw/mlx4/main.c                 |  72 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h              |   3 +-
 drivers/infiniband/hw/mlx4/mr.c                   |   4 +-
 drivers/infiniband/hw/mlx5/Makefile               |   2 +-
 drivers/infiniband/hw/mlx5/cq.c                   | 104 ++-
 drivers/infiniband/hw/mlx5/gsi.c                  | 548 +++++++++++++
 drivers/infiniband/hw/mlx5/mad.c                  | 166 +++-
 drivers/infiniband/hw/mlx5/main.c                 | 119 ++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h              | 108 ++-
 drivers/infiniband/hw/mlx5/mr.c                   | 601 +++++++++++---
 drivers/infiniband/hw/mlx5/odp.c                  |  10 +-
 drivers/infiniband/hw/mlx5/qp.c                   | 271 ++++++-
 drivers/infiniband/hw/mlx5/srq.c                  |  41 +-
 drivers/infiniband/hw/mlx5/user.h                 |   7 +
 drivers/infiniband/hw/nes/Kconfig                 |   1 -
 drivers/infiniband/hw/nes/nes.c                   |  25 -
 drivers/infiniband/hw/nes/nes_cm.c                | 361 ++-------
 drivers/infiniband/hw/nes/nes_cm.h                |  11 +-
 drivers/infiniband/hw/nes/nes_hw.c                |  44 +-
 drivers/infiniband/hw/nes/nes_hw.h                |   7 -
 drivers/infiniband/hw/nes/nes_nic.c               |   7 -
 drivers/infiniband/hw/nes/nes_verbs.c             |   5 +-
 drivers/infiniband/hw/ocrdma/ocrdma.h             |   8 +
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c          |  77 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h          |   5 +-
 drivers/infiniband/hw/ocrdma/ocrdma_hw.c          |  33 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c        |   4 +
 drivers/infiniband/hw/ocrdma/ocrdma_sli.h         |  16 +-
 drivers/infiniband/hw/ocrdma/ocrdma_stats.c       |   4 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c       |  38 +-
 drivers/infiniband/ulp/ipoib/ipoib.h              |   2 +
 drivers/infiniband/ulp/ipoib/ipoib_cm.c           |  23 +-
 drivers/infiniband/ulp/ipoib/ipoib_ib.c           |  18 +
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c        |   5 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c          |  11 +-
 drivers/infiniband/ulp/iser/iscsi_iser.h          |   7 -
 drivers/infiniband/ulp/iser/iser_initiator.c      |   7 -
 drivers/infiniband/ulp/iser/iser_verbs.c          |  38 +-
 drivers/infiniband/ulp/srp/ib_srp.c               |  40 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c             | 912
++++++++--------------
 drivers/infiniband/ulp/srpt/ib_srpt.h             |  31 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h       |   2 +
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h     |   1 +
 drivers/net/ethernet/mellanox/mlx4/fw.c           |   5 +-
 drivers/net/ethernet/mellanox/mlx4/mcg.c          |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 225 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h |  15 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c    |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/mr.c      |  54 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c    |  23 +
 drivers/net/ethernet/mellanox/mlx5/core/vport.c   |  40 +
 include/linux/mlx4/device.h                       |   3 +
 include/linux/mlx5/device.h                       |  33 +-
 include/linux/mlx5/driver.h                       |  26 +-
 include/linux/mlx5/fs.h                           |   5 +
 include/linux/mlx5/mlx5_ifc.h                     |  51 +-
 include/linux/mlx5/qp.h                           |   7 +-
 include/linux/mlx5/vport.h                        |   2 +
 include/rdma/ib_mad.h                             |   4 +-
 include/rdma/ib_verbs.h                           |  19 +-
 include/rdma/iw_cm.h                              |   6 +-
 include/uapi/rdma/rdma_netlink.h                  |   4 +-
 net/9p/trans_rdma.c                               |  86 +-
 91 files changed, 3647 insertions(+), 1995 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx5/gsi.c

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--MPArqUWTtPtQsOvss7MV0g5aCHGQJ9bWR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW6unWAAoJELgmozMOVy/dgBEP/3zA/UhSDasEMyiH+w27jm0z
FqAp4iZKKoDB6BGhCTJHXXgB/VRtSLueSzM4ORbxiftiBeqki0PzBLQe6LoigBG1
LebFQYHkF+EKUMJfjftGRtZQr06ZLg9tfeUNtaK851iuZYhxKG1ZwYlLEwxTsn84
AqoOO75XDV8I0Hk9rAiIK/4V6hwArPH+52VsulS31kMCGwO6J/nLgMt4kSeg9fsY
uoKLlZUPpP1CcNwKCQwrLq4itHSRmOtwVHWk6MQbR27KkVuuBMLzoQ3jqkLWDwmQ
BHGgc0CG6fecxMwHxRL8IfOkGjGXBYxnFtbuxpZrdkNcFl8v5iesRXT5zDNWaurj
yzDJRTaHNeA3hnY02AtvfFmtFaUSTQrCztW7wVUPhg+Buc4jKb7BJBBi44Nvn6kv
/TNXzafEBvkGEyDqQpyg8gcBWqZwvI7GcP4zPwAIksOD0FxoMv7DtLuefuoWeHgZ
fEj4BkrWFaDkXGzFz9+klAxnfhKi4EVLOLzVIhBXHbowqB2v+6elHyudYQN3KBc0
V8lUEwkF3PukopFgWDwfTWsT7qwmvj7VLbCbciXIw/+WQnvkHfaoK+1/tE2uzc//
F7gITWMFBj2Kj6OI+5/kmQtX61U6a7HBTvR2VheMm5jVo611x2rmK3RUo5d33xkA
B7LaoiHtHnfNhMamxLlo
=pBy6
-----END PGP SIGNATURE-----

--MPArqUWTtPtQsOvss7MV0g5aCHGQJ9bWR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
