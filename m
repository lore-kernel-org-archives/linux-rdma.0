From: Wenda Ni <wonda.ni-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Query max_inline_data
Date: Thu, 7 Apr 2016 11:26:54 -0400
Message-ID: <CAEnvTt0=WGs1Ha0+n-1f-sGzEhdVQZ+Kqk9dB90NSX32G5F_hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi experts,

Is there a way to query the size of a max_inline_data?
Dotan's blog says
How can I know what is the maximum message size that can be sent inline in a QP?
You can't know this information. This information is unavailable. You
find this information by trial and error.
http://www.rdmamojo.com/2012/12/21/ibv_create_qp/#How_can_I_know_what_is_the_maximum_message_size_that_can_be_sent_inline_in_a_QP

I am curious whether this statement is still valid nowadays with the
latest development and proprietary OFED.

When doing ibv_devinfo -vvv on ConnectX-4 with
MLNX_OFED_LINUX-3.2-2.0.0.0, we observe

max_send_wqe_inline_klms:    20

That seems relevant to inline_data, but does not seem to be exactly we
are looking for. Also, what does klms mean? It seems to be a instance
of struct mlx5_klm, when searched online.


Thank you for sharing your knowledge.


Cheers,

Wenda Ni, Ph.D.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
