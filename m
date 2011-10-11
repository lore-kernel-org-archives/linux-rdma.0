From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/5] net/mlx4_core: remove module param controlling the
 vlan table size
Date: Tue, 11 Oct 2011 21:18:29 +0200
Message-ID: <CAJZOPZJnzUm2M1zm1564TUwKCN3r=y3g-4pwTL4bJPDo2V4s9w@mail.gmail.com>
References: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com>
	<alpine.LRH.2.00.1110101055050.11243@ogerlitz.voltaire.com>
	<CAG4TOxNaQicA6ExuNsw8V95mJPD+AQX5Wrfg+rCoBxdr2E+2ww@mail.gmail.com>
	<4E93EF38.5040707@mellanox.com>
	<CAL1RGDVk2EOmgWU_iZQWQqKJFPNYN4o_5_14Qbr_6wUzTJ1bOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVk2EOmgWU_iZQWQqKJFPNYN4o_5_14Qbr_6wUzTJ1bOg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 11, 2011 at 7:28 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> No, I think we need to switch to ignoring the parameter and printing a
> warning if someone sets it, and then we can remove it in a year or so.

no problem, I don't think I will be able to send such patch before
Sunday, so in spite of the merge window coming soon and as the rest of
the series isn't dependant on that patch, if the other patches are
okay, they can be picked before this one is fixed.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
