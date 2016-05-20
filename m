From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PULL REQUEST] Please pull rdma.git
Date: Fri, 20 May 2016 16:03:36 -0400
Message-ID: <b3bc5acb-6b18-5d7b-fe8d-e7c876259b9f@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="17J5PmlxvdHH0WsUTR32q66kg7HHae99R"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--17J5PmlxvdHH0WsUTR32q66kg7HHae99R
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is the primary 4.7 pull.  There are a few more patches in the wings
but I'm not sending them yet.  There are a few known merge issues:

1) An mlx5 merge issue.  Two different patches both add new #include
directives in the same file.  This would have possibly been caught and
fixed up by our new working arrangement with Mellanox, but the patch I
took that induced the issue was an older one from the list that predated
the new working setup.  The fixup is a no-brainer, so I left it as is.

2) An NFSoRDMS merge issue.  The NFS tree has a cleanup patch that
touches the same for statement that one of our cleanup patches touches.
I've only got 2 lines of diff for the NFSoRDMA tree this time around and
we managed to get a conflict.  It's another simple fixup.

3) As per your comments a cycle or two ago, I used topic branches for my
work.  So if there's something you don't like in this pull request,
topic branches can be used to separate things out.  However, there are a
few patches that went directly onto the branch I'm having you pull from,
so if you see anything you don't like, please don't try to use the topic
branches to recreate things yourself.  That will only frustrate you and
get me yelled at.  Let me know what you want removed and I'll fix up a
new branch for you.

Otherwise, it's all typical stuff.  Here's the git boilerplate:

The following changes since commit e29bff46b9b8663e1789fbcd65d0ba05a52f08=
af:

  Merge branch 'k.o/for-4.6-rc' into testing/4.6 (2016-04-28 15:16:32 -04=
00)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
tags/for-linus

for you to fetch changes up to c16d2750a08c8ccaf98d65f287a8aec91bb9610d:

  IB/mlx5: Fire the CQ completion handler from tasklet (2016-05-18
10:45:49 -0400)

----------------------------------------------------------------
Primary 4.7 merge window changes

- Updates to the new Intel X722 iWARP driver
- Updates to the hfi1 driver
- Fixes for the iw_cxgb4 driver
- Misc core fixes
- Generic RDMA READ/WRITE API addition
- SRP updates
- Misc ipoib updates
- Minor mlx5 updates

----------------------------------------------------------------
Andy Shevchenko (1):
      RDMA/nes: replace custom print_hex_dump()

Bart Van Assche (18):
      IB/srp: Fix a spelling error in a source code comment
      IB/srp: Fix a comment
      IB/srp: Document srp_map_data() return value
      IB/srp: Fix srp_map_data() error paths
      IB/srp: Introduce target->mr_pool_size
      IB/srp: Avoid that mapping failure triggers an infinite loop
      IB/srp: Move code out of a loop
      IB/srp: Move common code into the caller
      IB/srp: Print "ib_srp: " prefix once
      IB/srp: Fix a memory descriptor leak in an error path
      IB/srp: Fix srp_create_target() error handling
      IB/core: Enhance ib_map_mr_sg()
      IB/srp: Swap two code blocks in srp_add_one()
      IB/srp: Prevent mapping failures
      IB/srp: Do not register memory if never_register has been set
      iw_cxgb4: Convert a __force cast
      IB/srp: Fix a debug kernel crash
      iwcm: Fix a sparse warning

Chien Tin Tung (1):
      RDMA/i40iw: Correct STag mask to min of 14 bits

Christoph Hellwig (11):
      IB/iser: Fix max_sectors calculation
      IB/cma: pass the port number to ib_create_qp
      IB/core: Add passing an offset into the SG to ib_map_mr_sg
      IB/core: add a helper to check for READ WITH INVALIDATE support
      IB/core: refactor ib_create_qp
      IB/core: add a simple MR pool
      IB/core: generic RDMA READ/WRITE API
      target: enhance and export target_alloc_sgl/target_free_sgl
      IB/srpt: convert to the generic RDMA READ/WRITE API
      IB/core: add RW API support for signature MRs
      IB/isert: convert to the generic RDMA READ/WRITE API

Christoph Lameter (1):
      IB/core: Do not require CAP_NET_ADMIN for packet sniffing

Colin Ian King (4):
      i40iw: pass hw_stats by reference rather than by value
      i40iw: pass hw_stats by reference rather than by value
      IB/mlx4: trivial fix of spelling mistake on "argument"
      i40iw: pass hw_stats by reference rather than by value

Dean Luick (17):
      IB/hfi1: Fix sysfs file offset usage
      IB/hfi1: Fix i2c resource reservation checks
      IB/hfi1: Fix QOS num_vl bit width
      IB/hfi1: Remove invalid QOS check
      IB/hfi1: Fix QOS rule mappings
      IB/hfi1: Correctly obtain the full service class
      IB/hfi1: Simplify init_qpmap_table()
      IB/hfi1: Guard against concurrent I2C access across all chains
      IB/hfi1: Fix double QSFP resource acquire on cache refresh
      IB/hfi1: Extract RSM map table init from QOS
      IB/hfi1: Move QOS decision logic into its own function
      IB/hfi1: Create a routine to set a receive side mapping rule
      IB/hfi1: Add RSM rule for user FECN handling
      IB/hfi1: Ignore link downgrade with 0 lanes
      IB/hfi1: Use the neighbor link down reason only when valid
      IB/hfi1: Correctly report neighbor link down reason
      IB/hfi1: Fix MAD port poll for active cables

Denys Vlasenko (1):
      IB/nes: Deinline nes_free_qp_mem, save 1072 bytes

Doug Ledford (3):
      Merge branches 'hfi1' and 'iw_cxgb4' into k.o/for-4.7
      Merge branches 'mlx5-1' and 'srp-1' into k.o/for-4.7
      Merge branches 'cxgb4-2', 'i40iw-2', 'ipoib', 'misc-4.7' and
'mlx5-fcs' into k.o/for-4.7

Easwar Hariharan (2):
      IB/hfi1: Always turn on CDRs for low power QSFP modules
      IB/hfi1: Remove module presence check outside pre-LNI checks

Florian Westphal (1):
      RDMA/nes: don't leak skb if carrier down

Geliang Tang (1):
      IB/mlx4: Use list_for_each_entry_safe

Guy Levi (1):
      IB/mlx5: Add UARs write-combining and non-cached mapping

Hans Westgaard Ry (1):
      IB/ipoib: Add readout of statistics using ethtool

Hariprasad S (26):
      RDMA/iw_cxgb4: release ep resources on accept arp failure
      RDMA/iw_cxgb4: stop ep timer on close failure
      RDMA/iw_cxgb4: ensure eps don't get freed while the mutex is held
      RDMA/iw_cxgb4: remove connection abort from process_mpa_reply
      RDMA/iw_cxgb4: free resources when send_flowc() fails
      RDMA/iw_cxgb4: remove abort_connection() usage from accept/reject
      RDMA/iw_cxgb4: don't use abort_connection in process_mpa_request()
      RDMA/iw_cxgb4: move QP -> ERROR on fatal disconnect errors
      RDMA/iw_cxgb4: remove abort_connection() usage from ep_timeout()
      RDMA/iw_cxgb4: Add few history bits for ep
      RDMA/iw_cxgb4: Correct RFC number of MPA
      RDMA/iw_cxgb4: set the correct FID value in DSGL commands
      RDMA/iw_cxgb4: parent_ep has to be dereferenced in case of passive
accept failure
      RDMA/iw_cxgb4: Do not stop timer in case of incomplete messages
      RDMA/iw_cxgb4: stop_ep_timer() after MPA negotiation
      RDMA/iw_cxgb4: handle return value of c4iw_l2t_send() and
send_mpa_req()
      RDMA/iw_cxgb4: in process_timeout() don't move ep state to ABORTING=

      RDMA/iw_cxgb4: Handle return value of c4iw_ofld_send() in
abort_arp_failure()
      RDMA/iw_cxgb4: atomically lookup ep and get a reference
      RDMA/iw_cxgb4: Free skb in case of arp failure in _c4iw_free_ep()
      RDMA/iw_cxgb4: Release ep for for FPDU_MODE and MPA_REQ_RCVD in
process_timeout
      RDMA/iw_cxgb4: Handle ULP accept/reject during ABORTING
      RDMA/iw_cxgb4: atomic find and reference for listening endpoints
      RDMA/iw_cxgb4: Handle ret value of process_mpa_reply() in rx_data
      RDMA/iw_cxgb4: Always wake up waiter in c4iw_peer_abort_intr()
      RDMA/iw_cxgb4: Add arp failure handlers to send_mpa_reply/reject()

Ismail, Mustafa (16):
      RDMA/i40iw: Fix overflow of region length
      RDMA/i40iw: Correct QP size calculation
      RDMA/i40iw: Fix refused connections
      RDMA/i40iw: Correct max message size in query port
      RDMA/i40iw: Do not set self-referencing pointer to NULL after free
      RDMA/i40iw: Add qp table lock around AE processing
      RDMA/i40iw: Set vendor_err only if there is an actual error
      RDMA/i40iw: Populate vendor_id and vendor_part_id fields
      RDMA/i40iw: Remove unused code and fix warning
      RDMA/i40iw: Add virtual channel message queue
      RDMA/i40iw: Correct return code check in add_pble_pool
      RDMA/i40iw: Initialize max enabled vfs variable
      RDMA/i40iw: Add base memory management extensions
      RDMA/i40iw: Fix endian issues and warnings
      RDMA/i40iw: Fix SD calculation for initial HMC creation
      RDMA/i40iw: Adding queue drain functions

Jianxin Xiong (1):
      IB/hfi1: Reduce kernel context pio buffer allocation

Jubin John (3):
      IB/rdmavt,hfi1,qib: Fix memory leak
      IB/hfi1: Change default number of user contexts
      IB/hfi1: Serialize hrtimer function calls

Julia Lawall (4):
      i40e: constify i40e_client_ops structure
      i40iw: constify i40iw_vf_cqp_ops structure
      i40iw: constify i40iw_vf_cqp_ops structure
      i40iw: constify i40iw_vf_cqp_ops structure

Lars-Peter Clausen (3):
      i40iw: Remove unnecessary synchronize_irq() before free_irq()
      i40iw: Remove unnecessary synchronize_irq() before free_irq()
      i40iw: Remove unnecessary synchronize_irq() before free_irq()

Majd Dibbiny (5):
      IB/core: Add extended device capability flags
      IB/core: Add Raw Scatter FCS device capability
      IB/core: Add Scatter FCS create flag
      IB/mlx5: Add Scatter FCS support for Raw Packet QP
      IB/mlx5: Report Scatter FCS device capability when supported

Mark Bloch (4):
      IB/IWPM: Fix a potential skb leak
      IB/core: Remove unnecessary check in ibnl_rcv_msg
      IB/core: Fix a potential array overrun in CMA and SA agent
      IB/SA: Use correct free function

Matan Barak (3):
      IB/mlx5: Allow mapping the free running counter on PROT_EXEC
      net/mlx5_core: Use tasklet for user-space CQ completion events
      IB/mlx5: Fire the CQ completion handler from tasklet

Mike Marciniszyn (4):
      IB/rdmavt: Fix adaptive pio hang
      IB/qib, IB/hfi1: Fix up UD loopback use of irq flags
      IB/hfi1: Remove unreachable code
      IB/hfi1: Use global defines for upper bits in opcode

Mitko Haralanov (6):
      IB/hfi1: Don't remove list entries if they are not in a list
      IB/hfi1: Fix memory leak in user ExpRcv and SDMA
      IB/hfi1: Protect the interval RB tree when cleaning up
      IB/hfi1: Correctly compute node interval
      IB/hfi1: Extract and reinsert MMU RB node on lookup
      IB/hfi1: Fix buffer cache races which may cause corruption

Mohammad Khan (1):
      RDMA/i40iw: Fix for a NOP WQE size

Saeed Mahameed (1):
      net/mlx5: Update mlx5_ifc hardware features

Sebastian Andrzej Siewior (1):
      infiniband/ulp/ipoib: remove pkey_mutex

Sebastian Sanchez (2):
      IB/hfi1: Adjust default MTU to be 10KB
      IB/hfi1: Check P_KEY for all sent packets from user mode

Shiraz Saleem (3):
      RDMA/i40iw: Fixes for WQE alignment
      RDMA/i40iw: Fix for the size of kernel mode SQ
      RDMA/i40iw: Fix for using one sge for RDMA READ

Steve Wise (1):
      IB/core: add a need_inval flag to struct ib_mr

Tariq Toukan (1):
      net/mlx5: Fix mlx5 ifc cmd_hca_cap bad offsets

Tatyana Nikolova (3):
      RDMA/i40iw: Fix for checking if the QP is destroyed
      RDMA/i40iw: Fix for removing quad hash entries
      RDMA/nes: Adding queue drain functions

shamir rabinovitch (1):
      IB/mlx4: Fix unaligned access in send_reply_to_slave

 drivers/infiniband/core/Makefile                   |   4 +-
 drivers/infiniband/core/cma.c                      |   4 +-
 drivers/infiniband/core/iwcm.c                     |   4 +-
 drivers/infiniband/core/iwpm_util.c                |   1 +
 drivers/infiniband/core/mr_pool.c                  |  86 +++
 drivers/infiniband/core/netlink.c                  |   5 +-
 drivers/infiniband/core/rw.c                       | 727 +++++++++++++++=
+++
 drivers/infiniband/core/sa_query.c                 |   4 +-
 drivers/infiniband/core/uverbs_cmd.c               |  11 +-
 drivers/infiniband/core/verbs.c                    | 172 +++--
 drivers/infiniband/hw/cxgb3/iwch_provider.c        |   7 +-
 drivers/infiniband/hw/cxgb4/cm.c                   | 611 ++++++++++-----=

 drivers/infiniband/hw/cxgb4/iw_cxgb4.h             |  14 +-
 drivers/infiniband/hw/cxgb4/mem.c                  |  12 +-
 drivers/infiniband/hw/i40iw/i40iw.h                |   7 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.c             | 148 ++--
 drivers/infiniband/hw/i40iw/i40iw_cm.h             |  10 +-
 drivers/infiniband/hw/i40iw/i40iw_ctrl.c           | 185 +++--
 drivers/infiniband/hw/i40iw/i40iw_d.h              |   4 +-
 drivers/infiniband/hw/i40iw/i40iw_hw.c             |  14 +-
 drivers/infiniband/hw/i40iw/i40iw_main.c           |  58 +-
 drivers/infiniband/hw/i40iw/i40iw_osdep.h          |   1 +
 drivers/infiniband/hw/i40iw/i40iw_pble.c           |   9 +-
 drivers/infiniband/hw/i40iw/i40iw_puda.c           |   2 +-
 drivers/infiniband/hw/i40iw/i40iw_status.h         |   1 +
 drivers/infiniband/hw/i40iw/i40iw_type.h           |  14 +-
 drivers/infiniband/hw/i40iw/i40iw_uk.c             | 106 +--
 drivers/infiniband/hw/i40iw/i40iw_user.h           |  36 +-
 drivers/infiniband/hw/i40iw/i40iw_utils.c          |  47 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.c          | 294 ++++++-
 drivers/infiniband/hw/i40iw/i40iw_verbs.h          |   3 +
 drivers/infiniband/hw/i40iw/i40iw_vf.c             |   2 +-
 drivers/infiniband/hw/i40iw/i40iw_vf.h             |   2 +-
 drivers/infiniband/hw/i40iw/i40iw_virtchnl.c       | 102 +--
 drivers/infiniband/hw/mlx4/main.c                  |   2 +-
 drivers/infiniband/hw/mlx4/mcg.c                   |   9 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |   5 +-
 drivers/infiniband/hw/mlx4/mr.c                    |   7 +-
 drivers/infiniband/hw/mlx5/cq.c                    |   5 +-
 drivers/infiniband/hw/mlx5/main.c                  | 102 ++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |   8 +-
 drivers/infiniband/hw/mlx5/mr.c                    |  25 +-
 drivers/infiniband/hw/mlx5/qp.c                    |  20 +-
 drivers/infiniband/hw/nes/nes_nic.c                |   3 -
 drivers/infiniband/hw/nes/nes_utils.c              |  60 +-
 drivers/infiniband/hw/nes/nes_verbs.c              |  43 +-
 drivers/infiniband/hw/nes/nes_verbs.h              |   2 +
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c        |   7 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h        |   5 +-
 drivers/infiniband/hw/qib/qib_init.c               |   4 +-
 drivers/infiniband/hw/qib/qib_rc.c                 |   2 +-
 drivers/infiniband/hw/qib/qib_ruc.c                |   4 +-
 drivers/infiniband/hw/qib/qib_uc.c                 |   2 +-
 drivers/infiniband/hw/qib/qib_ud.c                 |  10 +-
 drivers/infiniband/hw/qib/qib_verbs.h              |   6 +-
 drivers/infiniband/sw/rdmavt/qp.c                  |   6 +-
 drivers/infiniband/sw/rdmavt/vt.c                  |  13 +
 drivers/infiniband/ulp/ipoib/ipoib_ethtool.c       |  67 ++
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |   2 -
 drivers/infiniband/ulp/iser/iscsi_iser.c           |  14 +-
 drivers/infiniband/ulp/iser/iser_memory.c          |   4 +-
 drivers/infiniband/ulp/isert/ib_isert.c            | 841
++-------------------
 drivers/infiniband/ulp/isert/ib_isert.h            |  69 +-
 drivers/infiniband/ulp/srp/ib_srp.c                | 229 ++++--
 drivers/infiniband/ulp/srp/ib_srp.h                |   2 +
 drivers/infiniband/ulp/srpt/ib_srpt.c              | 729 +++++++--------=
---
 drivers/infiniband/ulp/srpt/ib_srpt.h              |  31 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h        |   4 +
 drivers/net/ethernet/intel/i40e/i40e_client.h      |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |  59 ++
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |  12 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  17 +
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   2 +
 drivers/staging/rdma/hfi1/affinity.c               |  93 +--
 drivers/staging/rdma/hfi1/affinity.h               |  19 +-
 drivers/staging/rdma/hfi1/chip.c                   | 647 +++++++++++----=
-
 drivers/staging/rdma/hfi1/chip.h                   |   7 +-
 drivers/staging/rdma/hfi1/chip_registers.h         |   1 +
 drivers/staging/rdma/hfi1/diag.c                   |   3 +-
 drivers/staging/rdma/hfi1/driver.c                 |   3 +-
 drivers/staging/rdma/hfi1/firmware.c               |   9 +-
 drivers/staging/rdma/hfi1/hfi.h                    |  11 +-
 drivers/staging/rdma/hfi1/init.c                   |  25 +-
 drivers/staging/rdma/hfi1/mad.c                    |  16 +-
 drivers/staging/rdma/hfi1/mmu_rb.c                 |  35 +-
 drivers/staging/rdma/hfi1/mmu_rb.h                 |   2 +
 drivers/staging/rdma/hfi1/pio.c                    |  52 +-
 drivers/staging/rdma/hfi1/pio.h                    |   4 +-
 drivers/staging/rdma/hfi1/platform.c               |  99 +--
 drivers/staging/rdma/hfi1/qp.c                     |   6 +-
 drivers/staging/rdma/hfi1/qsfp.c                   |  58 +-
 drivers/staging/rdma/hfi1/qsfp.h                   |  15 +-
 drivers/staging/rdma/hfi1/rc.c                     |   9 +-
 drivers/staging/rdma/hfi1/ruc.c                    |  20 +-
 drivers/staging/rdma/hfi1/sysfs.c                  |   4 +-
 drivers/staging/rdma/hfi1/ud.c                     |   8 +-
 drivers/staging/rdma/hfi1/user_exp_rcv.c           |   7 +-
 drivers/staging/rdma/hfi1/user_sdma.c              |  97 ++-
 drivers/staging/rdma/hfi1/verbs.c                  | 108 ++-
 drivers/staging/rdma/hfi1/verbs.h                  |   4 +-
 drivers/target/target_core_transport.c             |  32 +-
 drivers/target/target_core_xcopy.c                 |   2 +-
 include/linux/mlx5/cq.h                            |   5 +
 include/linux/mlx5/driver.h                        |  10 +
 include/linux/mlx5/mlx5_ifc.h                      | 253 +++++--
 include/rdma/ib_verbs.h                            |  61 +-
 include/rdma/mr_pool.h                             |  25 +
 include/rdma/rdma_vt.h                             |   1 +
 include/rdma/rdmavt_qp.h                           |   5 +-
 include/rdma/rw.h                                  |  88 +++
 include/target/target_core_backend.h               |   1 -
 include/target/target_core_fabric.h                |   4 +
 include/uapi/rdma/ib_user_verbs.h                  |   1 +
 net/rds/ib_frmr.c                                  |   2 +-
 net/sunrpc/xprtrdma/frwr_ops.c                     |   2 +-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c            |   2 +-
 116 files changed, 4308 insertions(+), 2689 deletions(-)
 create mode 100644 drivers/infiniband/core/mr_pool.c
 create mode 100644 drivers/infiniband/core/rw.c
 create mode 100644 include/rdma/mr_pool.h
 create mode 100644 include/rdma/rw.h


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--17J5PmlxvdHH0WsUTR32q66kg7HHae99R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXP22YAAoJELgmozMOVy/daU8QAMEmYxijIeJv9gUKbRJzFq3q
yjyfLbxgQRoHiKGkSbfD/QvRw8ybODND03EpKSt4TJuzXDmzQ+7TYl4E1QvDCK3z
psAs4iSVb8OCaa4W6cicwDAILHacn4S2D1GlwIXYZFP5S7TXeFuDQDpGvZ8HvPw3
LG2vnHhxnwoUrkDg7bcZrkybTlskNNEdZ7x06Pz0GF9jNy3Ys4mhc/WWOMJY5/2u
1VXeu8GoZGFDKr1206fEiSNxKJaaKAddLtmUFGFMkrnvCU/x171Tdp3aFMTSE2fj
CiQGLI9Ed7+s7DUmoatIQM/mEzIFrKnJRvWbgs/WrujbL1nrZMPwCCQ2LbEEL1iz
UtWTg6WHe2me2Ws2UlPYdACCYUpGw6o3S1JJFhk/4ht7deklWnOWmarlA6nqnZYa
hU1LoxH3ir4WWDXnrp76Skk6DuCsesakd+nrcbBiCAbSWh08PGZcu1giFwhYeoAP
oT4WLPWBrHbK00UBi1ZL+oZ+D3OLfmjn1SCDVhk63PeNR9wsLRq2lX4KFARafuE3
TpHmNlLp0S9HxhR7jjGPAodUDBn7DICQn/tKbhDqdp9ZOvZAyVXkWTv4z49AN+Ku
O9uqcU1dZU0W1sBauEi3LxKnAQzpGZi4A/3wCICc1ePChiaTSChdV1Yy6GX7vbTD
L+X8PRje8R6ieS5FpeW3
=FyoJ
-----END PGP SIGNATURE-----

--17J5PmlxvdHH0WsUTR32q66kg7HHae99R--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
