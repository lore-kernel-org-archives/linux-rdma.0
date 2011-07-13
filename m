From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] opensm: Add support for PID file
Date: Tue, 12 Jul 2011 22:14:41 -0600
Message-ID: <20110713041441.GA26663@obsidianresearch.com>
References: <20110710120442.GA11284@localhost.localdomain>
 <20110712162740.29e2d7d1.weiny2@llnl.gov>
 <20110712235222.GG10216@obsidianresearch.com>
 <20110712165817.16076a3d.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110712165817.16076a3d.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aleksey Senin <alekseys-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 12, 2011 at 04:58:17PM -0700, Ira Weiny wrote:

> > The usual way to do this is to have the daemon drop a pidfile to the
> > location set by its --pidfile argument after it forks, but before the
> > command returns.
> 
> You mean like Alex's patch did?  I have not seen this done before.
> I checked out apache's httpd command and I don't see it doing this.

I didn't look closely..

At least sshd, ntpd, acpid, and dbus are working that way on my ubuntu
system.. Some commands write a default pidfile automaticaly rather
than doing nothing, but upstart and systemd eliminate the need
for a pid file at all, so I prefer to see a no write option.

> > If --pidfile is not given it should not drop a pidfile anyplace.
> 
> "it" is opensm in this case?

Yes

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
