From: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-4.2 0/1] RDMA/core: Fixes for port mapper client
 registration
Date: Thu, 2 Jul 2015 12:46:09 -0500
Message-ID: <20150702174609.GA11108@TENIKOLO-MOBL2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch has been reworked, but is very similar to the previously
submitted (10/16/2014) patch, which was forgotten:

[PATCH 1/1] RDMA/core: Fixes for port mapper client registration
https://www.mail-archive.com/linux-rdma%40vger.kernel.org/msg21512.html

This patch is addressing the same issue as the previous one -
the clients which have provided their mapping info
to the user space service after it is restarted, are treated as
unregistered and are not allowed to make remove mapping requests.

If the user space port mapper service is restarted, it notifies
the port mapper clients and they provide the mapping information they
have in use. At this time with the fix the registration type of the client
is set to IWPM_REG_INCOMPL and the client is allowed to make remove
mapping requests to the user space service.

There are some improvements in the current patch:
1) Adding functions to set/check registration type
2) New clients (calling iwpm_init()) have their registration set to IWPM_REG_UNDEF
3) If the port mapper user space service is not available, then the client
   registration stays IWPM_REG_UNDEF and the registration type won't be
   checked until the service becomes available (obviously no mappings are 
   possible, if the user space service isn't running).

For these changes to take effect no provider changes are necessary.
The patch contains fixes for the current registration logic.

Tatyana Nikolova (1):
  RDMA/core: Fixes for port mapper client registration

 drivers/infiniband/core/iwpm_msg.c  |   33 ++++++++++++++++-----------------
 drivers/infiniband/core/iwpm_util.c |   12 ++++++++++--
 drivers/infiniband/core/iwpm_util.h |   28 ++++++++++++++++++++++------
 3 files changed, 48 insertions(+), 25 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
