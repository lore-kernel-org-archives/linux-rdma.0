From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [RFC][PATCH 0/4] Add driver for Cisco's VIC series adapters
Date: Wed, 4 Sep 2013 03:47:02 +0000
Message-ID: <47A33601BBFF7E4B8F0D5D0C96F3022C013BC77A@xmb-rcd-x09.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Content-ID: <E2816C645A023B4FBB57EBCD263FCA2F-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Christian Benvenuti (benve)" <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

usNIC is the kernel driver for userspace bypass networking on Cisco's
VIC series adapters.  usNIC devices are advertised as SRIOV VFs by the
VIC adapters and these VFs are owned by usNIC.  The driver works in
conjuction with Cisco's ethernet driver, which owns the PFs, and does
priviledged firmware operations via the PF driver.

This patch won't build on infiniband tree because the corresponding
patches for Cisco's ethernet devices are being worked out in net-next
tree. We will re-submit for formal inclusion in the tree after all the
corresponding patches are in net-next tree.

This patch is being partitioned to avoid 100KB vger.kernel.org
limitation.

IB/core: Cisco VIC - usNIC rdma node and transport
IB/usnic: Cisco VIC - driver part 1/3
IB/usnic: Cisco VIC - driver part 2/3
IB/usnic: Cisco VIC - driver part 3/3

drivers/infiniband/core/sysfs.c                    |    1
drivers/infiniband/core/verbs.c                    |    3
include/rdma/ib_verbs.h                            |    6
drivers/infiniband/hw/usnic/usnic_abi.h            |   55 +
drivers/infiniband/hw/usnic/usnic_ib.h             |  115 +++
drivers/infiniband/hw/usnic/usnic_ib_main.c        |  600 ++++++++++++++++
drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c      |  542 +++++++++++++++
drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h      |   97 +++
drivers/infiniband/hw/usnic/usnic_ib_sysfs.c       |  349 ++++++++++
drivers/infiniband/hw/usnic/usnic_ib_sysfs.h       |   29 +
drivers/infiniband/hw/usnic/usnic_ib_verbs.c       |  734 ++++++++++++++++++++
drivers/infiniband/hw/usnic/usnic_ib_verbs.h       |   72 ++
drivers/infiniband/hw/usnic/usnic.h                |   29 +
drivers/infiniband/hw/usnic/usnic_common_pkt_hdr.h |   27 +
drivers/infiniband/hw/usnic/usnic_common_util.h    |   51 +
drivers/infiniband/hw/usnic/usnic_debugfs.c        |   70 ++
drivers/infiniband/hw/usnic/usnic_debugfs.h        |   25 +
drivers/infiniband/hw/usnic/usnic_fwd.c            |  244 +++++++
drivers/infiniband/hw/usnic/usnic_fwd.h            |   58 ++
drivers/infiniband/hw/usnic/usnic_log.h            |   58 ++
drivers/infiniband/hw/usnic/usnic_transport.c      |  125 +++
drivers/infiniband/hw/usnic/usnic_transport.h      |   27 +
drivers/infiniband/hw/usnic/usnic_uiom.c           |  602 ++++++++++++++++
drivers/infiniband/hw/usnic/usnic_uiom.h           |   80 ++
.../infiniband/hw/usnic/usnic_uiom_interval_tree.c |  234 ++++++
.../infiniband/hw/usnic/usnic_uiom_interval_tree.h |   74 ++
drivers/infiniband/hw/usnic/usnic_vnic.c           |  473 +++++++++++++
drivers/infiniband/hw/usnic/usnic_vnic.h           |  105 +++
MAINTAINERS                                        |    5
drivers/infiniband/Kconfig                         |    1
drivers/infiniband/Makefile                        |    1
drivers/infiniband/hw/usnic/Kconfig                |   11
drivers/infiniband/hw/usnic/Makefile               |   15
33 files changed, 4916 insertions(+), 2 deletions(-)
----
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
