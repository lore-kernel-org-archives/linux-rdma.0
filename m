From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Infiniband Adapter with Documentation
Date: Tue, 23 Jun 2015 01:32:49 -0400
Message-ID: <CADPSxAiM-sHeFUbM+Hz5gx_zH3oV0Xiz1q-VoQ889FD76njJPA@mail.gmail.com>
References: <CAK9+cJVe+z_eWTsf6nVR-Gaqs2KeiCxXak-vXpBO23G5pWZ-gg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAK9+cJVe+z_eWTsf6nVR-Gaqs2KeiCxXak-vXpBO23G5pWZ-gg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Brandon Falk <bfalk-kQ3ioHgQxLs9XoPSrs7Ehg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I have looked a lot for publicly-available documentation for
RDMA-capable NICs, but without success.

AFAIK, Mellanox's datasheets (Programmer Reference Manuals - PRMs) are
available to "customers with a design-in portfolio" under an NDA:
https://community.mellanox.com/thread/1052. Can someone with more
experience shed some light on this? For example, if I buy a Mellanox
card, am I eligible for its PRM?

--Anuj

On Mon, Jun 22, 2015 at 6:04 PM, Brandon Falk <bfalk-kQ3ioHgQxLs9XoPSrs7Ehg@public.gmane.org> wrote:
> Heya,
>
> I have a compute cluster which uses a completely custom OS (not binary
> or source compatible with Linux by any means), and I'm really
> interested in Infiniband support. Are there any adapters out there
> that have development guides for system level stuff (such as PCI
> BAR/MMIO space, etc). I'd ideally implement for the Mellanox
> ConnectX-4, but I'm willing to go where the documentation is.
>
> I just want to make a limited driver capable of RDMA writes and reads,
> not planning on supporting much more beyond that. How feasible is
> that? I've written multiple 1GbE drivers and a 10GbE driver
> (specifically for the X540) which was a 8 hour project thanks to good
> documentation. Is documentation of this sort available for Infiniband?
>
> I'd be looking for the Infiniband equivalent of this
> https://www-ssl.intel.com/content/dam/www/public/us/en/documents/datasheets/ethernet-x540-datasheet.pdf
> .
>
> -B
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
