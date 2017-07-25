From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 16/21] srp_daemon: Do not use LOG_PERROR
Date: Tue, 25 Jul 2017 11:44:41 -0600
Message-ID: <20170725174441.GB10905@obsidianresearch.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1500926429-31822-17-git-send-email-jgunthorpe@obsidianresearch.com>
 <1501001276.8931.1.camel@wdc.com>
 <20170725171735.GC3164@obsidianresearch.com>
 <1501003688.8931.6.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501003688.8931.6.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org" <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, "jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 25, 2017 at 05:28:10PM +0000, Bart Van Assche wrote:
> On Tue, 2017-07-25 at 11:17 -0600, Jason Gunthorpe wrote:
> > On Tue, Jul 25, 2017 at 04:47:59PM +0000, Bart Van Assche wrote:
> > > LOG_PERROR is very convenient when debugging srp_daemon. How about using
> > > the result of isatty(STDERR_FILENO) to decide whether or not to enable
> > > LOG_PERROR?
> > 
> > How about a --debug option that sets
> > 
> >   s_log_dest = log_to_stderr;
> 
> Sorry but I prefer that LOG_PERROR is retained when srp_daemon is started in
> another way than by systemd. How about adding StandardError=null to the
> srp_daemon unit file?

No, then emergency prints from libraries are lost forever eg glibc
malloc corruption prints.

How about a --systemd option? I think we are going to want that anyhow
down the road.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
