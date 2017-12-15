From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core] srp_daemon: Install signal handler for ibsrpdm
Date: Fri, 15 Dec 2017 10:59:44 -0700
Message-ID: <20171215175944.GF12434@ziepe.ca>
References: <20171214110241.4701-1-honli@redhat.com>
 <1513263572.2986.2.camel@wdc.com>
 <20171215013628.GA743@dhcp-13-42.nay.redhat.com>
 <20171215172800.GA12434@ziepe.ca>
 <1513360253.2571.23.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1513360253.2571.23.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 15, 2017 at 05:50:54PM +0000, Bart Van Assche wrote:
> On Fri, 2017-12-15 at 10:28 -0700, Jason Gunthorpe wrote:
> > Though overall, there is really no reason to even cleanup the threads,
> > just call exit?
> 
> Memory leak detectors like the one in Valgrind only produce meaningful results
> if threads are stopped cleanly before exit() is called.

Fair enough

> > @@ -1887,7 +1888,9 @@ static void free_res(struct resources *res)
> >  		modify_qp_to_err(res->ud_res->qp);
> >  
> >  	if (res->reconnect_thread) {
> > -		pthread_kill(res->reconnect_thread, SIGINT);
> > +		uint64_t val = 1;
> > +
> > +		write(res->sync_res->stop_event_fd, &val, sizeof(val));
> >  		pthread_join(res->reconnect_thread, &status);
> 
> This patch does not remove all pthread_kill() calls. There are two other such
> calls:
> 
> $ git grep -nHw pthread_kill
> srp_daemon/srp_daemon.c:1897:		pthread_kill(res->async_ev_thread, SIGINT);
> srp_daemon/srp_daemon.c:1901:		pthread_kill(res->trap_thread, SIGINT);

Correct, this is why I called it a sketch :) I'm sure there are a few
mistakes too..

Hopefully Honggang can finish it and test it, as he found a real bug.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
