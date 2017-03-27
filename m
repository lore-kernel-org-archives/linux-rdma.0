From: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] IB/IPoIB: ibX: failed to create mcg debug file
Date: Mon, 27 Mar 2017 23:17:15 +0300
Message-ID: <20170327201714.GB29831@srabinov-linux.uk.oracle.com>
References: <1490599139-12665-1-git-send-email-shamir.rabinovitch@oracle.com>
 <20170327195500.GH20443@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170327195500.GH20443-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vijay.ac.kumar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 27, 2017 at 10:55:00PM +0300, Leon Romanovsky wrote:
> On Mon, Mar 27, 2017 at 03:18:59AM -0400, Shamir Rabinovitch wrote:
> > When udev renames the netdev devices, ipoib debugfs entries does not
> > get renamed. As a result, if subsequent probe of ipoib device reuse the
> > name then creating a debugfs entry for the new device would fail.
> >
> > Also, moved ipoib_create_debug_files and ipoib_delete_debug_files as part
> > of ipoib event handling in order to avoid any race condition between these.
> >
> > Signed-off-by: Vijay Kumar <vijay.ac.kumar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >
> > ---
> > v2->v3:
> > - Move rev change out of commit message
> > - Fix typo
> > v1->v2:
> > - Review comment from Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >   Verified again and NETDEV_UNREGISTER is called correctly. Debug
> >   files are removed as expected. Thanks.
> > - Fix compile warning when CONFIG_INFINIBAND_IPOIB_DEBUG is not set
> > ---
> >

[...]

> >
> > +#ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
> > +static int ipoib_netdev_event(struct notifier_block *this,
> > +			      unsigned long event, void *ptr)
> > +{
> > +	struct netdev_notifier_info *ni = ptr;
> > +	struct net_device *dev = ni->dev;
> > +
> > +	if (dev->netdev_ops->ndo_open != ipoib_open)
> > +		return NOTIFY_DONE;
> > +
> > +	switch (event) {
> > +	case NETDEV_REGISTER:
> > +		ipoib_create_debug_files(dev);
> > +		break;
> > +	case NETDEV_CHANGENAME:
> > +		ipoib_debugfs_rename(dev);
> 
> Why do we need explicit ipoib_debugfs_rename function?
> Will it work by simply calling ipoib_delete_debug_files
> and immediately after that ipoib_create_debug_files?
> 
> 
> > +		break;
> > +	case NETDEV_UNREGISTER:
> > +		ipoib_delete_debug_files(dev);
> > +		break;
> > +	}
> > +
> > +	return NOTIFY_DONE;
> > +}
> > +#endif
> > +

Hi Leon, 

Good point. 
I will have look on this idea and get back to you.

BR, Shamir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
