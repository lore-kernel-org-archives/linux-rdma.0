From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: iSER with policy based routing error
Date: Thu, 18 May 2017 12:51:41 -0600
Message-ID: <CAANLjFqNkNVDiGr-yW9y6XCiWE_O7+OewmxWM+xmWHQ39n4wkw@mail.gmail.com>
References: <CAANLjFoB3V6_exH8TnQQobaHkz2K1Lxj0sVOVa2Q+MKAsCqCKQ@mail.gmail.com>
 <CAJ3xEMiYwGDott_gLrh7e4tG9Ti71vftMPuvyT3+czu7jWwqFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMiYwGDott_gLrh7e4tG9Ti71vftMPuvyT3+czu7jWwqFA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, May 13, 2017 at 11:55 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Sat, May 13, 2017 at 12:02 AM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
> [...]
>> If we put a default gateway for IPv6 in the 'default' table, then iSER
>> is able to make a connection, but we can only use one port. It looks
>> as if iSER is not following the rules in the default routing table to
>> find the appropriate default gateway in a different table.
>
> can you just try to make rdma connection with the rping utility? do
> you see the same problem/s?

Using mlx4 cards with IB/RoCE, I am seeing the same connection problem
with rping. There seems to be a bug that prevents rping from working
with RoCE on mlx5.

I also found a thread between you and Mike Christie
https://groups.google.com/forum/#!topic/open-iscsi/IywifztV7Xs. It
doesn't say that things were all worked out about binding to dev/ip
address. Should iSER be able to bind to ip address (my preference), or
by device name (workable) to provide multipathing? Should this binding
be able to work with additional tables for finding the proper gateway?
We are intending to route all RoCE traffic over L3 boundaries as it
greatly simplifies the network configuration.

Here is the test that I ran to show the problem (it is also in the
"rdma_cm unable to find route on sub-table" thread):


----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
