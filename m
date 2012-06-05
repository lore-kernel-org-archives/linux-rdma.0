From: Hector Abrach <habrach-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: MLX4 driver problem with mlx4_ib_arm_cq
Date: Tue, 5 Jun 2012 10:57:15 -0500
Message-ID: <CAHsgog=X-Yy1a25kX8Q4MzOiku=mZyRkQP4E3kfdNVzacOqhiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello,

I continue to have a problem with an MLX4 driver where it fails to go
to the ARMED -> ACTIVE state. However, this failure is a consequence
of a previous failure in mlx4_ib_arm_cq.

Within functions, I get:
mlx4_ib_poll_one -> next_cqe_sw failing with -EAGAIN. Basically next_cqe_sw = 0

That is because function get_cqe is returning NULL. Would you happen
to know why this is happening? Any pointers or any help at all would
be greatly appreciated.
What could be failing to initialize for get_cqe to return NULL?
What is get_cqe trying to do?

Anyway, I really appreciate your help and thank you for your time!

Hector Abrach
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
