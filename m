From: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Users] Linux kernel: Crash of IB peer in RC mode is not detected
Date: Thu, 23 Oct 2014 15:50:09 +0200
Message-ID: <CAD+HZHU1ALaCzVA8X8xhgh1-s=+hVryJYHa9d-biA93vJyX1uQ@mail.gmail.com>
References: <20141023131522.GD316@fholler.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141023131522.GD316-99BIx50xQYGELgA04lAiVw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Fabian Holler <fabian.holler-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: users-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

cc to linux-rdma, which is more proper for this kind of questions.

2014-10-23 15:15 GMT+02:00 Fabian Holler <fabian.holler-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>:
> Hello,
>
> we are implementing Linux kernel modules that are transferring data
> with RDMA-Write operations via an RC-connection between 2 hosts.
>
> After the RDMA connection between the hosts was established we are causing a
> kernel Oops on one of them with "echo c > /proc/sysrq-trigger".
>
> The other peer of the RC connection don't notice the crash.
> RDMA-Write operations are still finished successfully with a WC event 10min
> after the crash.
> Our module has event handlers registered for:
> - CQ ib_event_handler,
> - QP ib_event_handler,
> - device ib_event_handler,
> - connection manager event handler.
> But we don't receive any events that indicate a connection abort.
>
> I expected that RDMA-Write operations will fail if the other crashes.
> Also I hoped that an event is generated when a host is crashed. The subnet
> manager should notice it and notify every other device in the network.
>
> Are we missing something in our modules?
> Is there a way to determine that a RC peer crashed without implementing a
> ping-pong mechanism?
>
> Our setup:
> - Linux 3.14.13
> - Mellanox Technologies MT27500 Family [ConnectX-3],
>   mlx4_core driver
> - both peers are directly connected, no switch in between
> - on both hosts OpenSM 3.2.6 is running
>
>
> thanks in advance
>
> Fabian
>
> _______________________________________________
> Users mailing list
> Users-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
> http://lists.openfabrics.org/mailman/listinfo/users
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
