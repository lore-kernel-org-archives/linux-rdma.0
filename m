From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ibacm: Required-Start on openibd
Date: Wed, 26 Apr 2017 17:19:10 -0600
Message-ID: <20170426231910.GA2305@obsidianresearch.com>
References: <1493046558.17795.8.camel@profitbricks.com>
 <20170424155907.GB7927@obsidianresearch.com>
 <1493247367.3041.140.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1493247367.3041.140.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 26, 2017 at 06:56:07PM -0400, Doug Ledford wrote:

> see if it's gone or not, but one would hope so. However, at least in
> the systemd world, the rdma service is autostarted, so ibacm probably
> ought to be autostarted too, regardless of whether it depends on the
> rdma service or not.

systemd socket activation on its unix domain socket is the way to go, imho.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
