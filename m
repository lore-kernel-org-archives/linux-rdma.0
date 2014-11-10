From: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: FMR Support in multi-function environment
Date: Mon, 10 Nov 2014 19:58:46 +0530
Message-ID: <CANwwZzU+QzHqjo2wc-_E36E7PQMJhuuBsVW_Ux+JVfM_a+Ydqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Is FMR (Fast Memory Regions) supported in a multi-function mode?

If yes, I couldn't find the source code for the same in the mlx4
codebase. Can anyone please point me to the right location...

What I was trying to understand is this:

Suppose a VF driver wants to register large amount of memory using
FMR, will it be able to do so using the mlx4 code.

Or FMR is supported only in dedicated mode?


Thanks

Best Regards,
Bob
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
