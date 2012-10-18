From: =?UTF-8?Q?Xavier_Gu=C3=A9rin?= <xrguerin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IBV_WR_SEND_WITH_IMM failure
Date: Thu, 18 Oct 2012 14:53:23 -0400
Message-ID: <CAHBb3isXXT1pnzdHnb+H3B7uSwMfROVCtcCFLtL-msq8o=ewHg@mail.gmail.com>
References: <CAHBb3isJ1CKSUSJPqCTckunGyBjWJZO6rxHeHHjK1ZE9rtXL6w@mail.gmail.com>
	<CAMQe6Ks1o9gAvK5d8X7jF=XOb9ZfstmC8UCPQ6PaRCiEHt-VyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMQe6Ks1o9gAvK5d8X7jF=XOb9ZfstmC8UCPQ6PaRCiEHt-VyA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Dotan,

Thanks for your answer.

>> I am having a puzzling error with IBV_WR_SEND_WITH_IMM. Polling fails
>> with IBV_WC_RETRY_EXC_ERR when I use buffer bigger that 1KB.
>> Send/Receive buffers are of a larger size and properly registered.
> This completion status means that the remote QP didn't send any ack/nack.
> If this is your first message, then this means that the connection was
> established in the wrong way. If this isn't the first message, the
> remote QP stopped being available (QP was destroyed/moved to reset or
> error state or the remote application completely ended).

I incrementally increase the size of my send message to the remote
controller. I start with 1 byte, then 128, 256, 512, 1024, etc...

The driver sends me this error when reaching 1024B. When trying only
1024B, the error appears immediately. It is interesting to note that
the same code works fine up to 16KB with a different adapter
(Connect-X 2 IB SDR).

I have not checked the status of the QP on the receiver side when the
sender fails. I'll do so and report it.

>> Incidentally, it fails when exceeding the MTU size of my device, a
>> Connect-X 3 VPI configured as 10Gb/s RoCE.
> What happens if you configures the QPs MTU to be 1KB in both sides?

Both sides have the same MTU. The adapter reports supporting MTUs up
to 2KB, but I have not found a way to do it for RoCE.

Thanks,
Xavier
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
