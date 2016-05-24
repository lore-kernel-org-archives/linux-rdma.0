From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI 8/8] IB/core: Implement device_create with the new ABI
Date: Tue, 24 May 2016 16:11:18 -0600
Message-ID: <20160524221118.GG7950@obsidianresearch.com>
References: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
 <1464100526-31730-9-git-send-email-leonro@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0500F1@ORSMSX109.amr.corp.intel.com>
 <20160524215335.GE7950@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05024F@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB05024F-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 24, 2016 at 10:02:26PM +0000, Hefty, Sean wrote:
> > > > +	filp = ib_uverbs_alloc_event_file(file, ib_dev, 1);
> > > > +	if (IS_ERR(filp)) {
> > > > +		ret = PTR_ERR(filp);
> > > > +		goto err_fd;
> > > > +	}
> > >
> > > I was considering events being reported directly on the file that's
> > > already opened.  Any objects opened through a file would report
> > > their events on that file, with possibly a way to redirect events to
> > > a different file (similar to rdma_migrate_id processing).
> > 
> > Is this code then just an optional compat for libibverbs 1.0?
> 
> It can work for compat, but migrate id had other use cases, which
> might be applicable in other situations.

Sorry, I ment the code you are quoting.

Eg, should the above have the 'struct ib_uverbs_get_context_resp'
redone to not include the 'resp.async_fd' and a new method call be required
to get the events filp?

compat libibverbs 1.0 would always have to call the new method.

If we had a new libibverbs 2.0 event delivery scheme like you envision
then 2.0 would call a different method instead to setup the new
scheme.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
