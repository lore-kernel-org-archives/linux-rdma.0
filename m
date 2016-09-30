From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: EACCES errors using preload libs
Date: Fri, 30 Sep 2016 12:43:02 -0500
Message-ID: <09db01d21b42$17aad9b0$47008d10$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Jason,  I'm looking into a problem that appears to have been introduced
by:

commit e6bd18f57aad1a2d1ef40e646d03ed0f2515c9e3
Author: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date:   Sun Apr 10 19:13:13 2016 -0600

    IB/security: Restrict use of the write() interface

I'm using a preload library (similar to rsockets) that enables a user-mode
UDP stack over chelsio hardware.  The preload lib uses user rdma verbs
calls.  In some cases, verbs calls are getting EACCES.  Can you explain what
"suspicious" write API calls this is disallowing:

static inline bool ib_safe_file_access(struct file *filp)
{
        return filp->f_cred == current_cred() && segment_eq(get_fs(),
USER_DS);
}

The single case I see failing so far is trying to preload my library with
netserver.  If I run netserver with '-D -f' which avoids fork() calls, it
works fine.  If I omit the -f, then the forked process gets an EACCES error
trying to do ibv_query_device().  Thoughts?

Thanks,

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
