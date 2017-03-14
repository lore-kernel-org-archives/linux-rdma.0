From: Alexey Lyashkov <alexey.lyashkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: SRQ flow control and IB_EVENT_SRQ_LIMIT_REACHED
Date: Tue, 14 Mar 2017 09:45:40 +0300
Message-ID: <AD8231DF-E503-49E5-B612-F4CDA9B778F9@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi All,

I=E2=80=99m beginner on IB stack and try to understand a flow control in =
SRQ case.
Based on IB specification=20
C9-150.2.1: For QPs that are not associated with an SRQ, each HCA =
receive
queue shall generate end-to-end flow control credits. If a QP is =
associated
with an SRQ, the HCA receive queue shall not generate end-toend
flow control credits.

did it mean - SRQ owner responsible to the process an =
IB_EVENT_SRQ_LIMIT_REACHED and submit a more WR into SRQ to avoid =
requests lost?
Or requests will be resend via handling an RNR error ?


Big thanks for answer,
Alexey=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
