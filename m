From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] opensm: Add support for PID file
Date: Tue, 12 Jul 2011 16:58:17 -0700
Message-ID: <20110712165817.16076a3d.weiny2@llnl.gov>
References: <20110710120442.GA11284@localhost.localdomain>
	<20110712162740.29e2d7d1.weiny2@llnl.gov>
	<20110712235222.GG10216@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110712235222.GG10216-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aleksey Senin <alekseys-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 12 Jul 2011 16:52:22 -0700
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Tue, Jul 12, 2011 at 04:27:40PM -0700, Ira Weiny wrote:
> 
> > -    @sbindir@/opensm --daemon $OPTIONS > /dev/null
> > +    daemon --pidfile=$PIDFILE @sbindir@/opensm --daemon $OPTIONS > /dev/null
> 
> You need to drop the --daemon from opensm if you run it under daemon..
> 
> The usual way to do this is to have the daemon drop a pidfile to the
> location set by its --pidfile argument after it forks, but before the
> command returns.

You mean like Alex's patch did?  I have not seen this done before.  I checked out apache's httpd command and I don't see it doing this.

> 
> If --pidfile is not given it should not drop a pidfile anyplace.

"it" is opensm in this case?

> 
> Generally the daemon should make sure it can run without exiting
> before forking, which is why this approach is prefered to using the
> daemon command.

Ok, perhaps I am backwards, as I said I have not seen this done before.

Ira

> 
> Jason


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
