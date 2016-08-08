From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: New krping location
Date: Mon, 8 Aug 2016 14:40:52 -0500
Message-ID: <01b301d1f1ac$c603c5e0$520b51a0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

For those who care, I've moved the krping git repo to gitlab:

https://github.com/larrystevenwise/krping

I also just committed changes in this new repo to support the linux-4.7 and
beyond RDMA APIs:

- remove phys MRs
- remove MWs
- support new REG_MR API
- support latest procfs API

I will no longer be using the old krping repo on the openfabrics.org site...

Cheers,

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
