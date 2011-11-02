From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: [PATCH-v3] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Wed,  2 Nov 2011 16:57:50 +0000
Message-ID: <1320253070-679-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

(Resending w/o the full body as it's exceeding the patch size limit.. ;)

This v3 patch adds the kernel module ib_srpt SCSI RDMA Protocol (SRP) target
implementation conforming to the SRP r16a specification for the mainline
drivers/target infrastructure.  This patch has been updated to build against
the latest target patches in the queue for v3.2-rc1, and includes the last
review feedback as listed in the changelog below.  This has been getting some
linux-next build testing over the last days, so please have a final look and
if there are no objections for an initial merge this version will be sent out
in PULL request form for mainline by the end of the week.

This driver was originally developed by Vu Pham and has been optimized by
Bart Van Assche and merged into upstream LIO based on his srpt-lio-4.1 branch.
This patch is made against the current pending target-core changes for
v3.2-rc1, the full tree is available here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next-merge

This updated patch also contains the following two changes from
lio-core-2.6.git/master.  One is to fix a bug with 1 >= task->task_sg[]
chained mappings in ib_srpt, and the other to convert the configfs control
plane to reference IB Port GUID and struct srpt_port directly following
mainline v4.x target_core_fabric_configfs.c convertion for ib_srpt
to work with rtslib/rtsadmin v2 code.

These seperate patches can be found here:

ib_srpt: Fix bug with chainged SGLs in srpt_map_sg_to_ib_sge
http://www.risingtidesystems.com/git/?p=lio-core-2.6.git;a=commitdiff;h=ea485147563b6555a97dbf811825fbb586519252

ib_srpt: Convert se_wwn endpoint reference to struct srpt_port->port_wwn
http://www.risingtidesystems.com/git/?p=lio-core-2.6.git;a=commitdiff;h=4e544a210acb227df1bb4ca5086e65bdf4e648ea

This also includes the following recent v1 -> v2 review changes:

ib_srpt: Fix potential out-of-bounds array access
ib_srpt: Avoid failed multipart RDMA transfers
ib_srpt: Fix srpt_alloc_fabric_acl failure case return value
ib_srpt: Update comments to reference $driver/$port layout
ib_srpt: Fix sport->port_guid formatting code
ib_srpt: Remove legacy use_port_guid_in_session_name module parameter
ib_srpt: Convert srp_max_rdma_size into per port configfs attribute
ib_srpt: Convert srp_max_rsp_size into per port configfs attribute
ib_srpt: Convert srpt_sq_size into per port configfs attribute

v2 -> v3 review changes:

ib_srpt: Fix possible race with srp_sq_size in srpt_create_ch_ib
ib_srpt: Fix possible race with srp_max_rsp_size in srpt_release_channel_work
ib_srpt: Fix up MAX_SRPT_RDMA_SIZE define
ib_srpt: Make srpt_map_sg_to_ib_sge() failure case return -EAGAIN
ib_srpt: Convert port_guid to use subnet_prefix + interface_id formatting
ib_srpt: Make srpt_check_stop_free return kref_put status

Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Signed-off-by: Nicholas A. Bellinger <nab-4mckEHfoRW3KI0RCH6AXYZqQE7yCjDx5@public.gmane.org>
---
 drivers/infiniband/Kconfig              |    1 +
 drivers/infiniband/Makefile             |    1 +
 drivers/infiniband/ulp/srpt/Kconfig     |   12 +
 drivers/infiniband/ulp/srpt/Makefile    |    2 +
 drivers/infiniband/ulp/srpt/ib_dm_mad.h |  139 ++
 drivers/infiniband/ulp/srpt/ib_srpt.c   | 4081 +++++++++++++++++++++++++++++++
 drivers/infiniband/ulp/srpt/ib_srpt.h   |  444 ++++
 7 files changed, 4680 insertions(+), 0 deletions(-)
 create mode 100644 drivers/infiniband/ulp/srpt/Kconfig
 create mode 100644 drivers/infiniband/ulp/srpt/Makefile
 create mode 100644 drivers/infiniband/ulp/srpt/ib_dm_mad.h
 create mode 100644 drivers/infiniband/ulp/srpt/ib_srpt.c
 create mode 100644 drivers/infiniband/ulp/srpt/ib_srpt.h

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
