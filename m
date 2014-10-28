From: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: mlx4 roce PF driver responsibilities
Date: Tue, 28 Oct 2014 18:01:54 +0530
Message-ID: <CANwwZzViCZGMWX+71qj=xHtuwB_V2GZWVN6qrf2gaLU+7hj7mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi All,

I was going through the mlx4 RoCE driver. I wanted to understand the
functionality that is implemented only by the Physical Function Driver
(PF Driver).

Assuming there is no RDMA stack, can anyone please tell me what all a
PF driver needs to take care of?

Is it sufficient if it only implements the HCR commands that are
related to RDMA?

Any CM or SA related things to take care of ?


Any help is really appreciated!!


Thanks so much


Best Regards,
Bob
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
