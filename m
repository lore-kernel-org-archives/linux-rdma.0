From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Infiniband stack allows references to freed memory
Date: Wed, 1 Feb 2012 15:28:18 -0800
Message-ID: <CAG4TOxN75jXze4iy_nCBO1vwqvXnwKcqbAFAEFR=n-PdiG4moA@mail.gmail.com>
References: <20120201.165041.1820098802489365638.davem@davemloft.net>
 <20120201.170210.981802234698152048.davem@davemloft.net> <CAG4TOxNNTOc0hwjOuEa-p2SBf5GBnEjVQyOERiTq5gkprLioYQ@mail.gmail.com>
 <20120201.171703.1299449838314569881.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120201.171703.1299449838314569881.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 1, 2012 at 2:17 PM, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org> wrote:
> So it should be just a matter of checking skb->protocol or similar,
> plucking out the daddr from the ipv4/ipv6 header, and then adding
> the appropriate neigh release calls.
>
> I have absolutely no way to test this stuff, so could you please
> work on the dst_lookup_neigh() conversion of ipoib?

I'm happy to do it but I'm still not quite sure I understand what the
end state is.  Is it just a matter of peeking into the skb contents
to get at the daddr, looking up the neigh based on that and then
continuing to handle neighs as we do now?

Does that also work for ARP packets?

Are there any examples in your tree I can crib off of?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
