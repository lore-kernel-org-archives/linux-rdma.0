From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: where defined IBV_RC
Date: Fri, 13 Mar 2015 10:26:11 -0500
Message-ID: <55030193.4070504@opengridcomputing.com>
References: <CACaajQsqC4YiPWXnOMyCHWAn3s7LQAkwBwZCWHsduaoAN9rS5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQsqC4YiPWXnOMyCHWAn3s7LQAkwBwZCWHsduaoAN9rS5Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/13/2015 6:44 AM, Vasiliy Tolstov wrote:
> I'm try to use rdma_getaddrinfo but it complains about IBV_RC
>
> error: =E2=80=98IBV_RC=E2=80=99 undeclared (first use in this functio=
n)
>     rhints.ai_qp_type =3D IBV_RC;
>
> grepping headers does not helps.
>

Try IBV_QPT_RC from <infiniband/verbs.h>

Also get the librdmacm source and there are examples of using this API.

git://git.openfabrics.org/~shefty/librdmacm

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
