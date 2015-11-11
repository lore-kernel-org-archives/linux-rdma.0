From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 0/8] Fix hfi1_ioctl locking
Date: Wed, 11 Nov 2015 00:43:01 -0500
Message-ID: <1447220589-9067-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

It was identified that hfi1_ioctl may sleep with a spin lock held.

This was identified publicly here:

http://www.spinics.net/lists/linux-rdma/msg29926.html

As well as by our internal development.

This series cleans up the code and parameter checks, as well as fixing the
locking.


Dennis Dalessandro (2):
  staging/rdma/hfi1: Reduce snoop locking scope in IOCTL handler.
  staging/rdma/hfi1: Return immediately on error

Ira Weiny (5):
  staging/rdma/hfi1: Fix camel case variables
  staging/rdma/hfi1: Return early from hfi1_ioctl parameter errors
  staging/rdma/hfi1: remove unneeded goto done
  staging/rdma/hfi1: return early if setlink state was specified
  staging/rdma/hfi1: Further clean up hfi1_ioctl parameter checks

Jubin John (1):
  staging/rdma/hfi1: diag.c Correct code style issues

 drivers/staging/rdma/hfi1/diag.c | 465 +++++++++++++++++++--------------------
 1 file changed, 223 insertions(+), 242 deletions(-)

-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
