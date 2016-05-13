From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/IPoIB: Allow setting the device address
Date: Fri, 13 May 2016 10:45:48 -0600
Message-ID: <20160513164548.GA27209@obsidianresearch.com>
References: <1462340207-16174-1-git-send-email-leon@kernel.org>
 <20160504184105.GB20554@obsidianresearch.com>
 <VI1PR05MB1391263ABAC5F4892DBD69E9D2710@VI1PR05MB1391.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR05MB1391263ABAC5F4892DBD69E9D2710-79XLn2atqDP8GeyK7vyn2tqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 10, 2016 at 03:26:27PM +0000, Mark Bloch wrote:

> > Did these checks from eth_prepare_mac_addr_change get included?
> > 
> >          if (!(dev->priv_flags & IFF_LIVE_ADDR_CHANGE) &&
> > netif_running(dev))
> >                  return -EBUSY;
> > 
> Why do I need to include that?

That is standard in all the other implementations - you should be
asking instead why IPoIB doesn't need to copy that.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
