From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] opensm: Add support for PID file
Date: Tue, 12 Jul 2011 17:52:22 -0600
Message-ID: <20110712235222.GG10216@obsidianresearch.com>
References: <20110710120442.GA11284@localhost.localdomain>
 <20110712162740.29e2d7d1.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110712162740.29e2d7d1.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aleksey Senin <alekseys-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 12, 2011 at 04:27:40PM -0700, Ira Weiny wrote:

> -    @sbindir@/opensm --daemon $OPTIONS > /dev/null
> +    daemon --pidfile=$PIDFILE @sbindir@/opensm --daemon $OPTIONS > /dev/null

You need to drop the --daemon from opensm if you run it under daemon..

The usual way to do this is to have the daemon drop a pidfile to the
location set by its --pidfile argument after it forks, but before the
command returns.

If --pidfile is not given it should not drop a pidfile anyplace.

Generally the daemon should make sure it can run without exiting
before forking, which is why this approach is prefered to using the
daemon command.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
