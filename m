From: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] IB/IPoIB: ibX: failed to create mcg debug file
Date: Tue, 28 Mar 2017 12:19:41 +0300
Message-ID: <20170328091940.GA14058@srabinov-linux.uk.oracle.com>
References: <1490599139-12665-1-git-send-email-shamir.rabinovitch@oracle.com>
 <20170327195500.GH20443@mtr-leonro.local>
 <20170327201714.GB29831@srabinov-linux.uk.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170327201714.GB29831-t9juWtktDCT52KUv/Ok+f8QLKKaP9WJ9VpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vijay.ac.kumar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 27, 2017 at 11:17:14PM +0300, Shamir Rabinovitch wrote:
> 
> > >
> > > +#ifdef CONFIG_INFINIBAND_IPOIB_DEBUG
> > > +static int ipoib_netdev_event(struct notifier_block *this,
> > > +			      unsigned long event, void *ptr)
> > > +{
> > > +	struct netdev_notifier_info *ni = ptr;
> > > +	struct net_device *dev = ni->dev;
> > > +
> > > +	if (dev->netdev_ops->ndo_open != ipoib_open)
> > > +		return NOTIFY_DONE;
> > > +
> > > +	switch (event) {
> > > +	case NETDEV_REGISTER:
> > > +		ipoib_create_debug_files(dev);
> > > +		break;
> > > +	case NETDEV_CHANGENAME:
> > > +		ipoib_debugfs_rename(dev);
> > 
> > Why do we need explicit ipoib_debugfs_rename function?
> > Will it work by simply calling ipoib_delete_debug_files
> > and immediately after that ipoib_create_debug_files?
> > 
> > 
> > > +		break;
> > > +	case NETDEV_UNREGISTER:
> > > +		ipoib_delete_debug_files(dev);
> > > +		break;
> > > +	}
> > > +
> > > +	return NOTIFY_DONE;
> > > +}
> > > +#endif
> > > +
> 
> Hi Leon, 
> 
> Good point. 
> I will have look on this idea and get back to you.
> 
> BR, Shamir

Hi Leon,

It seems that the difference between using debugfs_rename and a
combination of debugfs_create_file and debugfs_remove is mainly the
atomicy of the rename operation with regard to the file system.
debugfs_rename is atomic operation while the above combination is not.
As result I see kernel panic when the rename operation interleave with
the delete due to module unload. So after carefully considering what you
suggest I think it might introduce unexpected issues.

BR, Shamir  
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
