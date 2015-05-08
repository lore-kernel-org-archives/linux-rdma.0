From: Tatyana Nikolova <Tatyana.E.Nikolova@intel.com>
Subject: [PATCH] RDMA/core: Fix for parsing netlink string attribute
Date: Fri, 8 May 2015 16:36:33 -0500
Message-ID: <20150508213633.GA13012@TENIKOLO-MOBL2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: swise@opengridcomputing.com, john.s.lacombe@intel.com, linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The string iwpm_ulib_name is recorded in a nlmsg as a netlink attribute.
Without this fix parsing of the nlmsg by the userspace port mapper service fails
because of unknown attribute length, causing the port mapper service not to
register the client, which has sent the nlmsg.

Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Cc: <stable@vger.kernel.org> #v3.16
---
 drivers/infiniband/core/iwpm_msg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/iwpm_msg.c b/drivers/infiniband/core/iwpm_msg.c
index b85ddbc..e5558b2 100644
--- a/drivers/infiniband/core/iwpm_msg.c
+++ b/drivers/infiniband/core/iwpm_msg.c
@@ -33,7 +33,7 @@
 
 #include "iwpm_util.h"
 
-static const char iwpm_ulib_name[] = "iWarpPortMapperUser";
+static const char iwpm_ulib_name[IWPM_ULIBNAME_SIZE] = "iWarpPortMapperUser";
 static int iwpm_ulib_version = 3;
 static int iwpm_user_pid = IWPM_PID_UNDEFINED;
 static atomic_t echo_nlmsg_seq;
-- 
1.7.1
