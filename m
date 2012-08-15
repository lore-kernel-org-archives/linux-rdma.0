From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: handling rdma apps using chroot
Date: Wed, 15 Aug 2012 13:32:14 -0600
Message-ID: <20120815193214.GB2957@obsidianresearch.com>
References: <SNT114-DS11B5280C71EEE30408772DADB60@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <SNT114-DS11B5280C71EEE30408772DADB60-MsuGFMq8XAE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <pookieween-EMRzualFZlQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 15, 2012 at 12:07:25PM -0700, Sean Hefty wrote:
> I'm looking for ideas on the best way for handling applications which use
> chroot, which results in failures using the rdma libraries.  Specifically,
> and not surprisingly, I see failures reading /sys/class/... and
> /dev/infiniband/...
> 
> For background, I'm trying to run vsftpd over rsockets using the preload
> library with fork support.  vsftpd will run only if I comment out its use of
> chroot.  I can reproduce the issue by inserting a chroot call into rstream.
> 
> Does anyone have any suggestions?

Somehow you need to open the verbs device before doing the choot.. I
think once verbs is open there is no further need for sysfs and dev..

Sounds like you are chrooting before creating the listening socket?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
