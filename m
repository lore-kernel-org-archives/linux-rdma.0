From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: stuck iscsi/iser target with linux-4.15.0-rc1
Date: Sun, 3 Dec 2017 15:29:12 +0200
Message-ID: <0ba7e891-f020-26fb-9945-9e824332593c@grimberg.me>
References: <000801d36ac6$9e9f5f70$dbde1e50$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <000801d36ac6$9e9f5f70$dbde1e50$@opengridcomputing.com>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Steve,

> Hey, while working on some changes in the cxgb4 qp_drain functionality, I
> encountered this stall.  To reproduce it, I attach 2 ram disks via iser over
> cxgb4 and run an fio test.  While the test is running, I tear down the target
> stack with 'targetcli clearconfig true'
> 
> While this could be something with my qp_drain logic, I don't see that in these
> stuck threads.  Has anybody seen this?

Not for a while, can you turn the debug prints in
target_wait_for_sess_cmds so we can understand which commands are
hanging?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
