From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core: Location of 70-persistent-ipoib.rules
Date: Mon, 11 Sep 2017 10:25:21 -0600
Message-ID: <20170911162521.GD32117@obsidianresearch.com>
References: <1505129627.3732.3.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1505129627.3732.3.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 11, 2017 at 01:33:47PM +0200, Benjamin Drung wrote:

> Since 70-persistent-ipoib.rules is just a commented example, should we
> better put it into /usr/share/doc/rdma-core instead (where udev.md is
> placed)?

That would be fine for me, but I think /etc/ is appropriate in this
case and the lintian rule is just overzealous.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
