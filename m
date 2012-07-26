From: =?iso-8859-1?Q?=22Xavier_R=2E_Gu=E9rin=22?= <guerinx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: EINVAL when INIT -> RTR on RoCE
Date: Thu, 26 Jul 2012 00:53:04 -0400
Message-ID: <B2CAB3C7-6049-4B8B-90C1-9DD2180857EE@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1485\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi list,

I am confronted to a strange behavior with ibv_modify_qp. I moved my application from ConnectX3 (IB) to ConnectX2-EN (RoCE), and my queue pairs refuse to reset on the RoCE board (no problem on the IB board).

The queue pairs successfully switch from RESET to INIT, but miserably fail to switch from INIT to RTR with an EINVAL error code.

Is there any way to get more info on what causes the EINVAL?

Thanks,
Xavier--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
