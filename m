From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: EINVAL when INIT -> RTR on RoCE
Date: Thu, 26 Jul 2012 00:25:38 -0700
Message-ID: <CAL1RGDUsk2YV4GwYF7doina+bDGqw6VAHAEajJ7Qg7PJhF6aew@mail.gmail.com>
References: <B2CAB3C7-6049-4B8B-90C1-9DD2180857EE@gmail.com> <CAL1RGDUEMiuNKBjShYUmj2OTAS=YDGgpK7d5Li090r2ot8VanQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUEMiuNKBjShYUmj2OTAS=YDGgpK7d5Li090r2ot8VanQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?Q?Xavier_R=2E_Gu=E9rin?= <guerinx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 26, 2012 at 12:24 AM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org=
> wrote:
> On Wed, Jul 25, 2012 at 9:53 PM, "Xavier R. Gu=E9rin" <guerinx@gmail.=
com> wrote:
>> I am confronted to a strange behavior with ibv_modify_qp. I moved my=
 application from ConnectX3 (IB) to ConnectX2-EN (RoCE), and my queue p=
airs refuse to reset on the RoCE board (no problem on the IB board).
>>
>> The queue pairs successfully switch from RESET to INIT, but miserabl=
y fail to switch from INIT to RTR with an EINVAL error code.
>
> On IBoE, are you passing in a path with a global routing info, ie a G=
ID?

for example, what is the value of

    qp_attr.ah_attr.is_global

that you pass into modify_qp for the INIT->RTR transition?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
