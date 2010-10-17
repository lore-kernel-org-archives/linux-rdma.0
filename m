From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [PATCH 0/5] IB/srp: Add SRP_CRED_REQ support
Date: Sat, 16 Oct 2010 23:25:20 -0400
Message-ID: <1287285925-11710-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland,

Please pull from

	git://git.kernel.org/pub/scm/linux/kernel/git/dad/srp-initiator.git srp-credit-req

to add SRP_CRED_REQ support to the initiator. This is almost entirely
the result of Bart Van Assche's hard work. I reworked part of the
implementation, so that shows up in my name, as Bart has not taken
me up on the offer to list him as author.

Bart Van Assche (3):
  IB/srp: Preparation for transmit ring response allocation
  IB/srp: Reduce number of BUSY conditions
  IB/srp: Introduce list_first_entry()

David Dillow (2):
  IB/srp: implement SRP_CRED_REQ and SRP_AER_REQ
  IB/srp: eliminate two forward declarations

 drivers/infiniband/ulp/srp/ib_srp.c |  231 ++++++++++++++++++++++++----------
 drivers/infiniband/ulp/srp/ib_srp.h |   21 +++-
 include/scsi/srp.h                  |   38 ++++++
 3 files changed, 216 insertions(+), 74 deletions(-)

-- 
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
