From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core] srp_daemon: Install signal handler for ibsrpdm
Date: Tue, 19 Dec 2017 14:13:12 -0700
Message-ID: <20171219211312.GG14814@ziepe.ca>
References: <20171214110241.4701-1-honli@redhat.com>
 <1513263572.2986.2.camel@wdc.com>
 <20171215013628.GA743@dhcp-13-42.nay.redhat.com>
 <20171215172800.GA12434@ziepe.ca>
 <20171219122050.GA19682@dhcp-13-42.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171219122050.GA19682-Y5OA6DF/u0nid9cnFhDO8BcY2uh10dtjAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 19, 2017 at 08:20:50PM +0800, Honggang LI wrote:

> > Here is a sketch on how to fix it properly. All the users of
> > pthread_kill should be eliminated.
> > 
> > Though overall, there is really no reason to even cleanup the threads,
> > just call exit?
> 
> No, if one pthread just calls 'exit', the entire process will be
> terminated immediately. So, we need to cleanup the threads.
> 
> I think the source of current issue is the async_ev_thread pthread.
> We should *NOT* create such pthread for ibsrpdm.
> 
> I checked the old srptools git repo.

FYI, this is merged into rdma-core, use
  git log -p --follow srp_daemon/srp_daemon.c

and it will show you full history on a single file.

> Commit ab57a5b92eb3b8c9221f77235a028814a462d2cb merges "ibsrpdm" into
> "srp_daemon". The old ibsrpdm program is a single thread program.
> srp_daemon is multi-thread program.

Makes sense that ibsrpdm does not need the
run_thread_listen_to_events() thread. Patch looks OK to me too.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
