From: =?UTF-8?Q?Xavier_Gu=C3=A9rin?= <guerinx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: IBV_WR_SEND_WITH_IMM failure
Date: Tue, 16 Oct 2012 14:13:38 -0400
Message-ID: <CAHBb3isJ1CKSUSJPqCTckunGyBjWJZO6rxHeHHjK1ZE9rtXL6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello list,

I am having a puzzling error with IBV_WR_SEND_WITH_IMM. Polling fails
with IBV_WC_RETRY_EXC_ERR when I use buffer bigger that 1KB.
Send/Receive buffers are of a larger size and properly registered.

Incidentally, it fails when exceeding the MTU size of my device, a
Connect-X 3 VPI configured as 10Gb/s RoCE. I have been poking around
the web, and found out that it should not be an issue. Any clue of
what could be happening?

Thanks,
Xavier
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
