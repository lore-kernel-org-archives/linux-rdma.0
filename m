From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: iSER with policy based routing error
Date: Mon, 15 May 2017 13:39:45 +0300
Message-ID: <71232433-a3d1-1bc0-a995-ae32fc05913f@grimberg.me>
References: <CAANLjFoB3V6_exH8TnQQobaHkz2K1Lxj0sVOVa2Q+MKAsCqCKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFoB3V6_exH8TnQQobaHkz2K1Lxj0sVOVa2Q+MKAsCqCKQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Robert,

> We are trying to leverage multiple cards/ports for iSER for
> performance and resiliency reasons. The ports are configured with only
> IPv6 addresses and each port is on a separate VLAN/subnet that is
> routable to each other subnet. We are using rules with tables to set a
> default gateway for each adapter/subnet based on the source IPv6
> address (policy based routing). Using TCP for iSCSI, everything works
> fine and traffic ingresses/egresses the right ports. However, when we
> try using iSER, we get connection errors.
>
> May 12 13:39:27 prv-0-14-roberttest kernel: iser: iser_connect:
> rdma_resolve_addr failed: -101
> May 12 13:39:27 prv-0-14-roberttest iscsid: Received iferror -101:
> Network is unreachable.
> May 12 13:39:27 prv-0-14-roberttest iscsid: cannot make a connection
> to 2604:3140:40:300:0:580:d0:0:3260 (-101,0)

This looks 100% rdma_cm to me. iser is completely agnostic to address
families and routes.

> If we put a default gateway for IPv6 in the 'default' table, then iSER
> is able to make a connection, but we can only use one port. It looks
> as if iSER is not following the rules in the default routing table to
> find the appropriate default gateway in a different table.

As I said, iser relies on rdma_cm for routing decisions.
I would suspect that all rdma_cm based protocols to be
affected as well (nfs, nvmf).

Did you check plain rping like Or suggested?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
