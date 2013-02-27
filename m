From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH/RFC] IPoIB: Free ipoib neigh on path record failure so
 path rec queries are retried
Date: Wed, 27 Feb 2013 11:32:18 +0100
Message-ID: <512DE0B2.9090806@profitbricks.com>
References: <1361814409-6704-1-git-send-email-roland@kernel.org> <512C8F4F.9000606@mellanox.com> <CAG4TOxMyTEMKLUF1+YLej7Txj4P5MLZ49cVqAhQP4CW8qi0AUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxMyTEMKLUF1+YLej7Txj4P5MLZ49cVqAhQP4CW8qi0AUA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 26.02.2013 17:55, Roland Dreier wrote:
[...]
> In fact I bet this is why the bug has been there as long as it has
> been: almost no one is using IPv6 on IPoIB seriously, and IPv4 should
> work OK as you point out.

Thanks a lot,.... Unfortunately, we are using IPoIB with IPv6 in
production for the inter-VM and the internet gateway traffic. We had an
issue last Friday were one of our gateway machines wasn't reachable
anymore and pings didn't come through. We had to reload the ib_ipoib
modules of nearly every server connected to that gateway. I'm so glad
that we use SRP - all SRP connections survived.

I don't have the time to care for IPoIB as well at ProfitBricks so I
will encourage our networking teams to get their hands on IPoIB and
linux-rdma communication.

How to verify if we've hit this bug? How to reproduce this bug?

Cheers,
Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
