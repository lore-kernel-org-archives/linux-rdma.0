From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] ib_srpt: Convert port_guid to use subnet_prefix + interface_id formatting
Date: Wed,  2 Nov 2011 15:17:36 +0000
Message-ID: <1320247056-26809-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>
List-Id: linux-rdma@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts ib_srpt to use srpt_port->port_guid subnet_prefix +
interface_id formatting in srpt_add_one() to identify individual HW
target ports in /sys/kernel/config/target/srpt/$SRPT_WWPN

This layout for SRP Target WWPNs and explict SRP Initiator Node WWPNs
will now appear as:

/ib_srpt> ls
o- ib_srpt ......................................................... [2 Targets]
  o- 0xfe800000000000000002c903000e8acd .............................. [enabled]
  | o- acls ............................................................ [1 ACL]
  | | o- 0x00000000000000000002c903000e8be9 .................... [1 Mapped LUNs]
  | |   o- mapped_lun0 ............................................. [lun0 (rw)]
  | o- luns ........................................................... [1 LUNs]
  |   o- lun0 ................................... [iblock/scsi_debug (/dev/sdb)]
  o- 0xfe800000000000000002c903000e8ace .............................. [enabled]
    o- acls ............................................................ [1 ACL]
    | o- 0x00000000000000000002c903000e8bea .................... [1 Mapped LUNs]
    |   o- mapped_lun0 ............................................. [lun0 (rw)]
    o- luns ........................................................... [1 LUNs]
      o- lun0 .................................. [iblock/scsi_debug2 (/dev/sdc)]

Reported-by: Bart Van Assche <bvanassche@acm.org>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 283bc65..4734e44 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -3295,8 +3295,9 @@ static void srpt_add_one(struct ib_device *device)
 			goto err_ring;
 		}
 		snprintf(sport->port_guid, sizeof(sport->port_guid),
-				"0x0000000000000000%016llx",
-				be64_to_cpu(sport->gid.global.interface_id));
+			"0x%016llx%016llx",
+			be64_to_cpu(sport->gid.global.subnet_prefix),
+			be64_to_cpu(sport->gid.global.interface_id));
 	}
 
 	spin_lock(&srpt_dev_lock);
-- 
1.7.2.5
