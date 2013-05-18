From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: list corruption in IPOIB
Date: Sat, 18 May 2013 22:37:33 +0300
Message-ID: <CAJZOPZJNA7E005x9+XdVMG31fLEZm2mKB1nkpt5m3hA1qh7fYg@mail.gmail.com>
References: <519686B4.7010300@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <519686B4.7010300-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 17, 2013 at 10:36 PM, Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org> wrote:
> We've seen below neigh->list list corruption warning during testing,

So about little heads up on what kernel you are using? what's the way
to trigger this warning?

>  From Dongsu's and my opinion, several place also need
> netif_tx_lock(_bh)/netif_tx_unlock(_bh) pairs around neigh->list , I
> tried to add netif_tx_lock/netif_tx_unlock into ipoib_cm_destroy_tx, it
> improved the situation, there're some other places in ipoib_main.c and
> ipoib_mcast.c, but I don't know which lock should be added, if you can
> take some time to look into it, that will be great.


what do you mean by improved the situation? the waring is gone? and if
yes, what's remain?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
