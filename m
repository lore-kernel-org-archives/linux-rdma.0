From: Susan Gleeson <Susan.Gleeson-UdXhSnd/wVw@public.gmane.org>
Subject: srp_daemon stops finding a target
Date: Wed, 06 Jan 2010 16:15:19 -0500
Message-ID: <4B44FD67.108@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm at a loss to figure out what's going wrong and hoping you can help.

OFED 1.5.rc6, RHEL5.4 initiator, Solaris target

Initially, srp_daemon could discover the target and establish a session
(we're using run_srp_daemon).  Pulled the cable from one of the 2 target
ports and all remained well.  Rebooted the target system and now the
initiator cannot discover that target at all.

ibchecknet and ibdiagnet look fine and can see that port 2 on the target
system HCA is alive and well.  This suggests the fabric side of things
is happy.

I manually echo-ed the appropriate entry to add_target, and the session
was correctly established, which tells me that the target side of things
is happy.

Which leaves srp_daemon as suspect.  Or something else I'm overlooking.

What could cause this?  Any help appreciated,

Sue

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
