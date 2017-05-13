From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: iSER with policy based routing error
Date: Sat, 13 May 2017 20:55:20 +0300
Message-ID: <CAJ3xEMiYwGDott_gLrh7e4tG9Ti71vftMPuvyT3+czu7jWwqFA@mail.gmail.com>
References: <CAANLjFoB3V6_exH8TnQQobaHkz2K1Lxj0sVOVa2Q+MKAsCqCKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFoB3V6_exH8TnQQobaHkz2K1Lxj0sVOVa2Q+MKAsCqCKQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, May 13, 2017 at 12:02 AM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
[...]
> If we put a default gateway for IPv6 in the 'default' table, then iSER
> is able to make a connection, but we can only use one port. It looks
> as if iSER is not following the rules in the default routing table to
> find the appropriate default gateway in a different table.

can you just try to make rdma connection with the rping utility? do
you see the same problem/s?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
