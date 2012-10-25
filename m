From: =?UTF-8?Q?Xavier_Gu=C3=A9rin?= <xrguerin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IBV_WR_SEND_WITH_IMM failure
Date: Wed, 24 Oct 2012 23:03:16 -0400
Message-ID: <CAHBb3itE0URZ6eEX6GORX_d3NHdZp4ZxEL8uwvyVsUZ6Sk+3gg@mail.gmail.com>
References: <CAHBb3isJ1CKSUSJPqCTckunGyBjWJZO6rxHeHHjK1ZE9rtXL6w@mail.gmail.com>
	<CAMQe6Ks1o9gAvK5d8X7jF=XOb9ZfstmC8UCPQ6PaRCiEHt-VyA@mail.gmail.com>
	<CAHBb3isXXT1pnzdHnb+H3B7uSwMfROVCtcCFLtL-msq8o=ewHg@mail.gmail.com>
	<CAMQe6KtvvMdkpwALySbwS0dr6bGOhLtuLeV4f-QUNbmZ+afwUw@mail.gmail.com>
	<CAHBb3isoS0q9Q2tePOMe4syrtWZqBAhJ5vA_77x72Wm8ahsU-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHBb3isoS0q9Q2tePOMe4syrtWZqBAhJ5vA_77x72Wm8ahsU-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Dotan,

Enforcing the MTU to 1KB did the trick. Thanks for you precious help !

Xavier

On Wed, Oct 24, 2012 at 10:19 PM, Xavier Gu=C3=A9rin <xrguerin-Re5JQEeQqe8@public.gmane.org=
m> wrote:
> Hello Dotan,
>
>> I'm trying to understand exactly what you did...
>>
>> I'm guessing here the scenario, please correct me if I'm wrong:
>> You've tried to work with RoCE over ConnectX-3 using RC QP.
>> You were able to send messages up to 1024 (including this value) and=
 it failed.
>>
>> You've to execute the same test over ConnectX-2 SDR and everything p=
assed.
>
> You understood correctly.
>
>> I suspect that the problem is with the MTU, since in IB the MTU valu=
es
>> are different than in Ethernet (the "typical" value in IB is 2/4KB a=
nd
>> in Ethernet it is 1500 bytes).
>>
>> Can you try to set the path MTU of the QPs (when calling
>> ibv_modify_qp) to 1K MTU?
>> Maybe this will solve your problem ...
>
> I so far used a common/default setting for both IB and ETH mode of 2K=
B MTU.
> I will try lowering that value for RoCE and keep you updated.
>
> Thanks !
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
