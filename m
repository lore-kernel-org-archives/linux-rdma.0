From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 00/10] Introduce Signature feature
Date: Fri, 7 Mar 2014 11:43:33 -0800
Message-ID: <CAL1RGDXG2yU5mVi=e4A2NFyFo33Um=y03u7yyXL7GZ-J-y3KRQ@mail.gmail.com>
References: <1393157953-24834-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393157953-24834-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

So I went ahead and applied this for 3.15, although I suspect the
verbs API is probably the wrong one.  I understand that the mlx5
microarchitecture requires some of this signature binding stuff to go
through a work queue, but conceptually I don't think the
IB_WR_REG_SIG_MR work request makes sense as the right interface.  Why
do I need to do both a synchronous create_mr and an asynchronous work
request for what's conceptually a single operation?

Similarly the ib_check_mr_status() operation doesn't really make sense
to me as an additional synchronous operation -- why do I not just get
signature information as part of the completion entry for the
transaction that generated it?

Anyway, you guys are the ones that will have to clean this up in the
future when it becomes a problem, so I'm not going to push on this.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
