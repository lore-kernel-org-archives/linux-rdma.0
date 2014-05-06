From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH RESEND 0/5] ib/mad: Add ability for user space applications to control RMPP directly
Date: Mon,  5 May 2014 21:44:45 -0400
Message-ID: <1399340690-27677-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

My apologies if anyone receives duplicates of these emails.  Apparently the
series did not make it to linux-rdma the first time.

The first 3 patches update the umad and mad modules to use pr_* style print
messages in preparation for adding pr_notice messages to the existing and new
registration functions.

The final 2 patches add a new registration mechanism which allows for flags to
be specified at ib_mad registration time.  The first such flag is to allow user
control of RMPP transactions.

Existing registration and RMPP transactions are unaffected by this change.

[PATCH 1/5] ib/umad: update module to pr_* style print messages
[PATCH 2/5] ib/mad: update module to pr_* style print messages
[PATCH 3/5] ib/mad: Add pr_notice messages for various umad/mad
[PATCH 4/5] ib/mad: add new ioctl to user space to support new
[PATCH 5/5] ib/mad: Add user space RMPP support

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
