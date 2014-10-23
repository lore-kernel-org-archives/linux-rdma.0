From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [Users] Linux kernel: Crash of IB peer in RC mode is not detected
Date: Thu, 23 Oct 2014 11:43:56 -0700
Message-ID: <CAL1RGDXtVYqVuc7S6tYwcQ=ftHnAnYTnNeWLigvKOekyjYF5-A@mail.gmail.com>
References: <20141023131522.GD316@fholler.de> <CAD+HZHU1ALaCzVA8X8xhgh1-s=+hVryJYHa9d-biA93vJyX1uQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAD+HZHU1ALaCzVA8X8xhgh1-s=+hVryJYHa9d-biA93vJyX1uQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Fabian Holler <fabian.holler-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, users-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 23, 2014 at 6:50 AM, Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> I expected that RDMA-Write operations will fail if the other crashes.
>> Also I hoped that an event is generated when a host is crashed. The subnet
>> manager should notice it and notify every other device in the network.
>>
>> Are we missing something in our modules?
>> Is there a way to determine that a RC peer crashed without implementing a
>> ping-pong mechanism?

If the remote system crashes then any memory regions, QPs, etc. are
still valid with the remote HCA, and RDMA read/write operations will
continue to succeed.  (Unless the system reboots and reinitializes the
adapter or something like that).

There isn't a way to detect a remote crash unless that remote crash
disconnects your QP or otherwise affects the HCA on the crashed
system.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
