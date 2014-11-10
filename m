From: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: mlx4: RoCE support in SRIOV environment
Date: Mon, 10 Nov 2014 20:05:54 +0530
Message-ID: <CANwwZzW1Oe9ff30Wk6xANak9T2Pjoo0fYhWAOzv1GWq7DP+Ung@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I was going through the mlx4 code and previous mailing lists when I
came across the following thread:


http://marc.info/?l=linux-rdma&m=134398354428293&w=2


In that thread, it is mentioned as follows:

Some Limitations
----------------
1. FMRs are not currently supported on slaves. This will be corrected in a
   future submission.
2. RoCE is not currently supported on slaves. This will be corrected in a
   future submission.


As the thread dats back to 2012, I wanted to confirm if FMR & RoCE are
still not supported in SRIOV environment(master & slave)?


Thanks so much in advance!!

Best Regards,
Bob
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
