From: Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IBV_WR_SEND_WITH_IMM failure
Date: Tue, 23 Oct 2012 21:54:19 +0200
Message-ID: <CAMQe6KtvvMdkpwALySbwS0dr6bGOhLtuLeV4f-QUNbmZ+afwUw@mail.gmail.com>
References: <CAHBb3isJ1CKSUSJPqCTckunGyBjWJZO6rxHeHHjK1ZE9rtXL6w@mail.gmail.com>
	<CAMQe6Ks1o9gAvK5d8X7jF=XOb9ZfstmC8UCPQ6PaRCiEHt-VyA@mail.gmail.com>
	<CAHBb3isXXT1pnzdHnb+H3B7uSwMfROVCtcCFLtL-msq8o=ewHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHBb3isXXT1pnzdHnb+H3B7uSwMfROVCtcCFLtL-msq8o=ewHg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?Q?Xavier_Gu=E9rin?= <xrguerin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Xavier.

I'm trying to understand exactly what you did...

I'm guessing here the scenario, please correct me if I'm wrong:
You've tried to work with RoCE over ConnectX-3 using RC QP.
You were able to send messages up to 1024 (including this value) and it failed.

You've to execute the same test over ConnectX-2 SDR and everything passed.

I suspect that the problem is with the MTU, since in IB the MTU values
are different than in Ethernet (the "typical" value in IB is 2/4KB and
in Ethernet it is 1500 bytes).

Can you try to set the path MTU of the QPs (when calling
ibv_modify_qp) to 1K MTU?
Maybe this will solve your problem ...

Please keep me posted
Dotan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
