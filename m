From: Hari Subramoni <subramon-wPOY3OvGL++pAIv7I8X2sze48wsgrGvP@public.gmane.org>
Subject: Re: CQ overrun
Date: Thu, 11 Feb 2010 10:56:46 -0500 (EST)
Message-ID: <Pine.GSO.4.40.1002111048350.53-100000@omicron.cse.ohio-state.edu>
References: <6978b4af1002110457j26224acbr3dc28f4afb8cfb86@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6978b4af1002110457j26224acbr3dc28f4afb8cfb86-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rui Machado <ruimario-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Rui,

It looks like you're overflowing the Completion Queue. On the application
side, this could manifest as a hang while polling the CQ.

This could happen you receive more completion queue entries than the CQ
could handle. The depth of the CQ is set while creating it. It is the
second parameter in the call to "ibv_create_cq". You can try increasing
this to a larger value and see if your problem goes away.

Another thing you could check is the Firmware version of your card
(from the debug output, I'm assuming its a Mellanox InfiniHost card). Is
it a really really old version (4.7.500)? If so, you could try upgrading
that. There were some fixes for similar issues checked in after that.

Thx,
Hari.

On Thu, 11 Feb 2010, Rui Machado wrote:

> Hi list,
>
> I'm seeing the following message:
>
> ib_mthca 0000:0d:00.0: CQ overrun on CQN 380090
>
> can someone please tell me what does it mean and/or why and when this happens?
> On the user-space side, the application is hanging while polling on
> the queue pair.
>
> Thanks in advance.
>
> Rui Machado
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
