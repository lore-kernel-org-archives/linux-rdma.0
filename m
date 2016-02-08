From: "leon-2ukJVAZIZ/Y@public.gmane.org" <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH v2] IB/ipoib: fix for rare multicast join race condition.
Date: Mon, 8 Feb 2016 15:22:45 +0200
Message-ID: <20160208132245.GA13321@leon.nu>
References: <20160206135041.11630.77019.stgit@phlsvlogin03.ph.intel.com>
 <20160206171828.GD8584@leon.nu>
 <F3529576D8E232409F431C309E29399328F6C7FE@CRSMSX102.amr.corp.intel.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F3529576D8E232409F431C309E29399328F6C7FE-8k97q/ur5Z1cIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 08, 2016 at 12:23:07PM +0000, Estrin, Alex wrote:
> > 2. This function declared as a void, it is an error to add "return 0".
> > 
> ipoib_mcast_join() is declared as int.  Please see a very first change.
> 
> > -static void ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast)
> > +static int ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast)
> 

You are right.
Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
