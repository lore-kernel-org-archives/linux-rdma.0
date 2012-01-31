From: Swapna Thete <swapna.thete-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] Setup response for MADs as appropriate
Date: Tue, 31 Jan 2012 03:11:38 -0500
Message-ID: <20120131081138.9009.33668.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Changes suggested by Sean to include a function
generate_unmatched_resp() to construct a response
if method is get/set is incorporated. Also hdr
status has been changed to 
IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD_ATTRIB as
suggested by Hal and Jack.

======================================================
The issue is observed when a query command is issued
for any agent that is not implemented (CCA, BMA etc).

The devices in the OFED will not respond to queries,
thus tools making query to these devices will un-necessarily
take long time waiting for these commands to time out. 
So it would be better for OFED to respond to such a query
for all these devices by setting up a response message. 
For a large fabric consisting of these devices the 
issue would be further aggravated.

Setting up a response with appropriate error message
would be the efficient way to handle such messages
so that devices do not appear un-responsive to such
query commands and respond faster. 

Problem reported-by: Jenny Reick <jenny.reick-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Swapna Thete <swapna.thete-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

---

Swapna Thete (2):
      IB/mad: Add MAD error codes per IBTA spec
      IB/mad: Return unsupported for MADs as appropriate


 drivers/infiniband/core/mad.c |   10 ++++++++++
 include/rdma/ib_mad.h         |    9 +++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
