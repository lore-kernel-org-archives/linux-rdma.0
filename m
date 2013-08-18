From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/22] infiniband: improve userspace input check
Date: Sun, 18 Aug 2013 20:28:36 +0200
Message-ID: <cover.1376847403.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Please find a few patches against branch for-next of
git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git,
current head 3e7645800a89f2adccb8d635d36f2fb648048141.

This is a collection of patches to add more checks on userspace provided
input parameters to cm, cma and verbs subsystem:
The InfiniBand/RDMA subsystems are not currently making enough checks on
user input data. In particular:
- they should not read past the input buffer,
- they should not write past the output buffer. 
Each of these userspace APIs should use the user provided lengths
for buffers and don't read/write out of those boundaries.

I hope the proposed fixes being straightforward and not disruptive.

I've made some tests, but I cannot test every code path without a proper
test suite and the matching infrastructure. 

I've tested on a small InfiniBand fabric, with a 8 ports switch,
one node with 2 HCAs (1 port, 2 ports), a second node with 1 HCA (1 port),
each port connected to the switch. I've also tested with two node connected
back to back.

I've searched for regression using the following programs:

    ibaddr
    ibstat
    ibstatus
    ibportstate <lid> query
    ibroute <lid>
    ibswitches
    sminfo
    smpquery portinfo <lid>
    smpquery nodeinfo <lid>
    saquery
    ibv_devices
    ibv_devinfo
    rdma_client/rdma_server
    rdma_xclient/rdma_xserver
    ibv_rc_pingpong
    ib_{read,write}_{bw,lat}

I've tested only with Fedora 19 using:

     libipathverbs 1.2,
     libmlx4 1.0.5,
     libibverbs 1.1.17,
     librdmacm 1.0.17,
     libibmad 1.3.9,
     libibumad 1.3.8,
     opensm 3.3.15,
     infiniband-diags 1.6.1.

Testing with older/other libraries/tools could be interesting.

Please have a good review. I'm ready to anwser questions and update the patchset.

Regards.

Yann Droneaud (22):
  infiniband: ib_copy_{from,to}_udata(): const'ify arguments
  infiniband: ib_udata: const'ify inbuf
  infiniband: ib_copy_from_udata(): check input length
  infiniband: ib_copy_to_udata(): check output length
  ucm: ib_ucm_event(): returns ENOSPC instead of ENOMEM
  ucm: changes ib_ucm_alloc_data() src arg to be a pointer
  ucm: changes ib_ucm_path_get() src arg to be a pointer
  ucm: check userspace input length
  ucm: use size_t for userspace buffer input and output length
  ucm: ib_ucm_write(): check userspace buffer length first
  ucm: ib_ucm_write(): strict userspace buffer length check
  ucma: check userspace input length
  ucma: ucma_migrate_id(): check output length
  ucma: ucma_query_path(): check output length
  ucma: use size_t for userspace buffer input and output length
  ucma: ucma_write(): check userspace buffer length first
  ucma: ucma_write(): strict userspace buffer length check
  uverbs: check input length
  uverbs: check output length
  uverbs: ib_uverbs_poll_cq(): check output length against number of wc
  uverbs: fix call to INIT_UDATA with no output buffer
  uverbs: use size_t for userspace buffer input and output length

 drivers/infiniband/core/ucm.c         | 156 ++++++++++++++------
 drivers/infiniband/core/ucma.c        | 131 +++++++++++++----
 drivers/infiniband/core/uverbs.h      |   4 +-
 drivers/infiniband/core/uverbs_cmd.c  | 258 +++++++++++++++++++++++++---------
 drivers/infiniband/core/uverbs_main.c |   4 +-
 include/rdma/ib_verbs.h               |  12 +-
 6 files changed, 422 insertions(+), 143 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
