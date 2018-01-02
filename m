From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH net 0/2] IB/ipoib: ip link support
Date: Tue, 2 Jan 2018 09:29:05 +0200
Message-ID: <CAJ3xEMiRGpwp8NVdjm9ozTswer_YRP3uvjV5bUFg7cQ7Jh97vw@mail.gmail.com>
References: <1514718983-466-1-git-send-email-denisd@mellanox.com> <CAJ3xEMiVHc=E7=uKJ4cRRRDxjNDRKQ17=NxnYsEeXNe6-RUvvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMiVHc=E7=uKJ4cRRRDxjNDRKQ17=NxnYsEeXNe6-RUvvQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Denis Drozdov <denisd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Netdev List <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 31, 2017 at 2:28 PM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Sun, Dec 31, 2017 at 1:16 PM, Denis Drozdov <denisd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>> IP link was broken due to the changes in IPoIB for the rdma_netdev
>> support after commit cd565b4b51e5
>> ("IB/IPoIB: Support acceleration options callbacks").
>
> you are approaching stable kernels, right? lets make sure dave is okay
> to pick the net (touching dev.c etc) patch to stable even if the
> offending patch didn't change anything there.

Erez, Denis

The offending commit went in 4.12-rc1, so the fix should be getting
a while back. RU sure you need the net/core patch to fix that up or
we can come up with ipoib only patch?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
