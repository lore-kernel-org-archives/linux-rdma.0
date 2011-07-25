From: Roland Dreier <roland@kernel.org>
Subject: Re: [PATCH 0/7] More sane neigh infrastructure
Date: Mon, 25 Jul 2011 09:34:16 -0700
Message-ID: <CAG4TOxOv1WsgfRXxrBWWq-+9ee3apEE0B_Onn+JB=tEEuOhhxg@mail.gmail.com>
References: <20110725.030109.1723861338142084129.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20110725.030109.1723861338142084129.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 25, 2011 at 3:01 AM, David Miller <davem@davemloft.net> wro=
te:
> Devices provide up to three things:
>
> 1) netdev->neighpriv_len, length of per-neighbour device private
> =A0 state, accessible via neighbour_priv(neigh)
>
> 2) net_device_ops->ndo_neigh_construct(), invoked right after
> =A0 neigh_tbl->constructor(), can fail

Hey Dave,

I'll definitely look at converting IPoIB over to using this stuff.
Would love to get rid of all the dicy handling of ipoib_neigh lifetime
that we currently have.  However, I have a question about what the
intention for ndo_neigh_construct() is in the IPoIB case.

As we talked about, IPoIB has to trigger a path lookup to the subnet
manager (SM) when it gets a remote port ID.  However the SM is a
remote entity, so this lookup means we send a message and then
asynchronously wait for it to complete (or possibly timeout), just
like the ARP itself.  But this is done after we get the port ID via
normal RFC 826 ARP (with an address format as specified by RFC 4391).

So I don't think we can use custom neigh_ops with a new solict method
the way clip does -- we actually want to let the normal stack do ARP
or ND, but then extend the process by another message/response step.
I'm sure this is possible within your scheme but I'm not sure I
understand what the "right" way is.

Thanks!
  Roland
