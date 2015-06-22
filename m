From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Mon, 22 Jun 2015 11:43:20 -0400
Message-ID: <F192C7B5-04C8-466C-AADE-8BF879FC0446@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: multipart/signed; boundary="Apple-Mail=_AEE9800A-6C0C-43E7-9D77-CAB5DDCF7F2F"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_AEE9800A-6C0C-43E7-9D77-CAB5DDCF7F2F
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi Linus,

The following changes since commit =
e26081808edadfd257c6c9d81014e3b25e9a6118:

  Linux 4.1-rc4 (2015-05-18 10:13:47 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git =
tags/for-linus

for you to fetch changes up to 8e4349d13f3365273d2ff17667b36f7e846df912:

  IB/mad: Add final OPA MAD processing (2015-06-12 14:49:18 -0400)

----------------------------------------------------------------
Changes for 4.2

- A large cleanup of how device capabilities are checked for various
  features
- Additional cleanups in the MAD processing
- Update to the srp driver
- Creation and use of centralized log message helpers
- Add const to a number of args to calls and clean up call chain
- Add support for extended cq create verb
- Add support for timestamps on cq completion
- Add support for processing OPA MAD packets

----------------------------------------------------------------
Bart Van Assche (13):
      scsi_transport_srp: Introduce srp_wait_for_queuecommand()
      scsi_transport_srp: Fix a race condition
      IB/srp: Remove an extraneous scsi_host_put() from an error path
      IB/srp: Fix a connection setup race
      IB/srp: Fix connection state tracking
      IB/srp: Fix reconnection failure handling
      scsi_transport_srp: Reduce failover time
      IB/srp: Remove superfluous casts
      IB/srp: Rearrange module description
      IB/srp: Remove a superfluous check from srp_free_req_data()
      IB/srp: Remove !ch->target tests from the reconnect code
      IB/srp: Add 64-bit LUN support
      IB/ipoib: Fix RCU annotations in ipoib_neigh_hash_init()

Colin Ian King (1):
      RDMA/ocrdma: fix double free on pd

Dan Carpenter (1):
      IB/usnic: clean up some error handling code

Doug Ledford (3):
      Merge branches 'bart-srp', 'generic-errors', 'ira-cleanups' and =
'mwang-v8' into k.o/for-4.2
      Merge branch 'for-4.2-misc' into k.o/for-4.2
      Merge branch 'for-4.2-misc' into k.o/for-4.2

Fabian Frederick (1):
      IB/mthca: use swap() in mthca_make_profile()

Faisal Latif (1):
      RDMA/nes: Enable the use of the tos field in the nes driver

Hariprasad S (2):
      cxgb4: Support for user mode bar2 mappings with T4
      iw_cxgb4: support for bar2 qid densities exceeding the page size

Ira Weiny (29):
      IB/core: Create common start/end port functions
      IB/mad: Rename is_data_mad to is_rmpp_data_mad
      IB/mad: Clean up comments in smi.c
      IB/mad: Change validate_mad signature arguments
      IB/mad: Change ib_response_mad signature arguments
      IB/mad: Clean up rcv_has_same_class
      IB/mad: Add const qualifiers to query only functions
      IB/user_mad: Use new start/end port functions
      IB/user_mad: Fix buggy usage of port index
      IB/core: Add per port immutable struct to ib_device
      IB/core: Convert core to use bitfield for caps
      IB/core: Change rdma_protocol_iboe to roce
      IB/core cleanup: Add const to RDMA helpers
      IB/core cleanup: Add const on args - device->process_mad
      IB/core cleanup: Add const to args - agent_send_response
      IB/mad cleanup: Clean up function params -- find_mad_agent
      IB/mad cleanup: Generalize processing of MAD data
      IB/mad: Split IB SMI handling from MAD Recv handler
      IB/mad: Create a generic helper for DR SMP Send processing
      IB/mad: Create a generic helper for DR SMP Recv processing
      IB/mad: Create a generic helper for DR forwarding checks
      IB/mad: Support alternate Base Versions when creating MADs
      IB/core: Add ability for drivers to report an alternate MAD size.
      IB/mad: Convert allocations from kmem_cache to kzalloc
      IB/mad: Add support for additional MAD info to/from drivers
      IB/core: Add OPA MAD core capability flag
      IB/mad: Add partial Intel OPA MAD support
      IB/mad: Add partial Intel OPA MAD support
      IB/mad: Add final OPA MAD processing

Matan Barak (8):
      IB/core: Change provider's API of create_cq to be extendible
      IB/core: Change ib_create_cq to use struct ib_cq_init_attr
      IB/core: Add CQ creation time-stamping flag
      IB/core: Extend ib_uverbs_create_cq
      IB/core: Add timestamp_mask and hca_core_clock to query_device
      IB/core: Pass hardware specific data in query_device
      IB/mlx4: Add mmap call to map the hardware clock
      IB/mlx4: Add support for CQ time-stamping

Michael Wang (24):
      IB/Verbs: Implement new callback query_protocol()
      IB/Verbs: Implement raw management helpers
      IB/Verbs: Reform IB-core mad/agent/user_mad
      IB/Verbs: Reform IB-core cm
      IB/Verbs: Reform IB-core sa_query
      IB/Verbs: Reform IB-core multicast
      IB/Verbs: Reform IB-ulp ipoib
      IB/Verbs: Reform IB-ulp xprtrdma
      IB/Verbs: Reform IB-core verbs
      IB/Verbs: Reform cm related part in IB-core cma/ucm
      IB/Verbs: Reform route related part in IB-core cma
      IB/Verbs: Reform mcast related part in IB-core cma
      IB/Verbs: Reform cma_acquire_dev()
      IB/Verbs: Reform rest part in IB-core cma
      IB/Verbs: Use management helper rdma_cap_ib_mad()
      IB/Verbs: Use management helper rdma_cap_ib_smi()
      IB/Verbs: Use management helper rdma_cap_ib_cm()
      IB/Verbs: Use management helper rdma_cap_iw_cm()
      IB/Verbs: Use management helper rdma_cap_ib_sa()
      IB/Verbs: Use management helper rdma_cap_ib_mcast()
      IB/Verbs: Use management helper rdma_cap_read_multi_sge()
      IB/Verbs: Use management helper rdma_cap_af_ib()
      IB/Verbs: Use management helper rdma_cap_eth_ah()
      IB/Verbs: Improve docs for rdma-helpers

Moni Shoua (2):
      IB/core: Don't advertise SA in RoCE port capabilities
      IB/core: Don't warn on no SA support in event handler

Roland Dreier (2):
      RDMA/ocrdma: Fix memory leak in _ocrdma_alloc_pd()
      IB/mlx4: Fix error paths in mlx4_ib_create_flow()

Sagi Grimberg (6):
      IB/core, cma: Nice log-friendly string helpers
      IB/srp: Align to generic logging helpers
      IB/iser: Align to generic logging helpers
      iser-target: Align to generic logging helpers
      xprtrdma, svcrdma: Switch to generic logging helpers
      RDS: Switch to generic logging helpers

Steve Wise (1):
      RDMA/iw_cm: Export tos field to iwarp providers

Wengang Wang (1):
      rds: re-entry of rds_ib_xmit/rds_iw_xmit

 drivers/infiniband/core/addr.c                     |   4 +-
 drivers/infiniband/core/agent.c                    |  23 +-
 drivers/infiniband/core/agent.h                    |   6 +-
 drivers/infiniband/core/cache.c                    |  69 +--
 drivers/infiniband/core/cm.c                       |  26 +-
 drivers/infiniband/core/cma.c                      | 287 +++++----
 drivers/infiniband/core/device.c                   |  96 ++--
 drivers/infiniband/core/mad.c                      | 639 =
++++++++++++++-------
 drivers/infiniband/core/mad_priv.h                 |  15 +-
 drivers/infiniband/core/mad_rmpp.c                 |  33 +-
 drivers/infiniband/core/multicast.c                |  12 +-
 drivers/infiniband/core/opa_smi.h                  |  78 +++
 drivers/infiniband/core/sa_query.c                 |  33 +-
 drivers/infiniband/core/smi.c                      | 228 +++++---
 drivers/infiniband/core/sysfs.c                    |   8 +-
 drivers/infiniband/core/ucm.c                      |   3 +-
 drivers/infiniband/core/ucma.c                     |  25 +-
 drivers/infiniband/core/user_mad.c                 |  64 ++-
 drivers/infiniband/core/uverbs.h                   |   1 +
 drivers/infiniband/core/uverbs_cmd.c               | 188 ++++--
 drivers/infiniband/core/uverbs_main.c              |   1 +
 drivers/infiniband/core/verbs.c                    |  85 ++-
 drivers/infiniband/hw/amso1100/c2_provider.c       |  42 +-
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |  47 +-
 drivers/infiniband/hw/cxgb4/cq.c                   |  31 +-
 drivers/infiniband/hw/cxgb4/device.c               |  16 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |  13 +-
 drivers/infiniband/hw/cxgb4/provider.c             |  36 +-
 drivers/infiniband/hw/cxgb4/qp.c                   |  64 ++-
 drivers/infiniband/hw/cxgb4/t4.h                   |  60 +-
 drivers/infiniband/hw/ehca/ehca_cq.c               |   7 +-
 drivers/infiniband/hw/ehca/ehca_hca.c              |   6 +-
 drivers/infiniband/hw/ehca/ehca_iverbs.h           |  16 +-
 drivers/infiniband/hw/ehca/ehca_main.c             |  25 +-
 drivers/infiniband/hw/ehca/ehca_sqp.c              |  21 +-
 drivers/infiniband/hw/ipath/ipath_cq.c             |   9 +-
 drivers/infiniband/hw/ipath/ipath_mad.c            |  15 +-
 drivers/infiniband/hw/ipath/ipath_verbs.c          |  26 +-
 drivers/infiniband/hw/ipath/ipath_verbs.h          |  11 +-
 drivers/infiniband/hw/mlx4/cq.c                    |  13 +-
 drivers/infiniband/hw/mlx4/mad.c                   |  36 +-
 drivers/infiniband/hw/mlx4/main.c                  |  95 ++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |  29 +-
 drivers/infiniband/hw/mlx5/cq.c                    |  10 +-
 drivers/infiniband/hw/mlx5/mad.c                   |  15 +-
 drivers/infiniband/hw/mlx5/main.c                  |  37 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |  15 +-
 drivers/infiniband/hw/mthca/mthca_cmd.c            |   4 +-
 drivers/infiniband/hw/mthca/mthca_cmd.h            |   4 +-
 drivers/infiniband/hw/mthca/mthca_dev.h            |   9 +-
 drivers/infiniband/hw/mthca/mthca_mad.c            |  21 +-
 drivers/infiniband/hw/mthca/mthca_profile.c        |   8 +-
 drivers/infiniband/hw/mthca/mthca_provider.c       |  34 +-
 drivers/infiniband/hw/nes/nes_cm.c                 |   7 +
 drivers/infiniband/hw/nes/nes_cm.h                 |   2 +
 drivers/infiniband/hw/nes/nes_verbs.c              |  41 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.c           |  13 +-
 drivers/infiniband/hw/ocrdma/ocrdma_ah.h           |   8 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c         |  20 +
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |  21 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h        |  12 +-
 drivers/infiniband/hw/qib/qib_cq.c                 |  11 +-
 drivers/infiniband/hw/qib/qib_iba7322.c            |   3 +-
 drivers/infiniband/hw/qib/qib_mad.c                |  20 +-
 drivers/infiniband/hw/qib/qib_verbs.c              |  25 +-
 drivers/infiniband/hw/qib/qib_verbs.h              |  11 +-
 drivers/infiniband/hw/usnic/usnic_ib_main.c        |  17 +
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |  16 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h       |  12 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c           |   7 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c          |  19 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |   8 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           |  33 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |  24 +-
 drivers/infiniband/ulp/srp/ib_srp.c                | 146 +++--
 drivers/infiniband/ulp/srp/ib_srp.h                |   3 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   7 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         |   1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h     |   1 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |   4 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |   7 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |  19 +
 drivers/net/ethernet/mellanox/mlx5/core/mad.c      |   2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c                   |   6 +-
 drivers/scsi/scsi_transport_srp.c                  |  67 ++-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |   6 +-
 include/linux/mlx4/device.h                        |   9 +
 include/linux/mlx5/driver.h                        |   2 +-
 include/rdma/ib_addr.h                             |   6 +-
 include/rdma/ib_cache.h                            |   8 +-
 include/rdma/ib_mad.h                              |  41 +-
 include/rdma/ib_verbs.h                            | 394 ++++++++++++-
 include/rdma/iw_cm.h                               |   1 +
 include/rdma/opa_smi.h                             | 106 ++++
 include/rdma/rdma_cm.h                             |   2 +
 include/scsi/srp.h                                 |   7 +-
 include/uapi/rdma/ib_user_verbs.h                  |  19 +
 net/9p/trans_rdma.c                                |   4 +-
 net/rds/af_rds.c                                   |   9 -
 net/rds/ib.h                                       |   1 -
 net/rds/ib_cm.c                                    |  43 +-
 net/rds/ib_recv.c                                  |   4 +-
 net/rds/ib_send.c                                  |  55 +-
 net/rds/iw_cm.c                                    |   7 +-
 net/rds/iw_send.c                                  |  18 +-
 net/rds/rdma_transport.c                           |  34 +-
 net/rds/rds.h                                      |   3 +-
 net/sunrpc/xprtrdma/frwr_ops.c                     |   4 +-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c            |   4 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |  83 ++-
 net/sunrpc/xprtrdma/verbs.c                        |  99 +---
 112 files changed, 2901 insertions(+), 1364 deletions(-)
 create mode 100644 drivers/infiniband/core/opa_smi.h
 create mode 100644 include/rdma/opa_smi.h


=E2=80=94
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	GPG Key ID: 0E572FDD






--Apple-Mail=_AEE9800A-6C0C-43E7-9D77-CAB5DDCF7F2F
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJViC0YAAoJELgmozMOVy/dgm8P/3R0cBIwvfyVYRt4lLpHTP85
LWiU11P+yhjtcPPzeYigoncKoRlHFoHMK+5NW3HlaFK7z7/0CtXGO700SoL2dzRo
BJoG5/TPgbV+2KUAGX4Gf1c7GxRM0pDYSk0069aQc85EJxyiZXQ5xsRb/ZNFIHgA
N9DkBJQ1Gn/FKyNPPZPXibe+4u8QViOatfGD0I1UxBhuN9O9BZF46DZVOhcQb6li
BYMZaooG2GPLPBDQq6fGJwB5XlUEGQE944DKTI8H3GPrlzBTZi3zdcNzHz5hOVnC
CST9fXYKmP/beHuCJSBDhIgXEel0DFkRYwDJ6NzfJcNXk1ArEQUj3fh+mqhUC+5I
Dyvz/j2oHkhj/p7J/b1qmuD8y0JPJpKYHPPqzHK6yFBkppgEcYSA0wqWzSg0GBsC
yleza1ygTx/Ufbm0zQUVWkE+DHbMR0eG3OqI58tbuAWTXpIKl2HOeXy0cmHkB4B8
jnkZtlR90rKhcL/f32LnSrJ08VB7wpq15+Z//wmDRKv+MUIC9A9rZXiZ60/TBC60
b1zHqL9PWu1t9LxINVsqMP2bP6ww8SyRSNym0oxiRnfbomfGuC4ZOsoxEMHDnTV3
9dZeqa7L09JDBrOSFKP+bK3Z5fqndT0YO9YHSd3xV3ehU5j/DSGpOs1tlgZuN+4Z
S+K+Fk3OVduyObRNdVZq
=L+q2
-----END PGP SIGNATURE-----

--Apple-Mail=_AEE9800A-6C0C-43E7-9D77-CAB5DDCF7F2F--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
