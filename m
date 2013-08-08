From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: using rsockets via librspreload: poll() support?
Date: Thu, 8 Aug 2013 18:46:33 +0200
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CA4C29@ORSMSX109.amr.corp.intel.com>
References: <20130808174629.46b698cf@doppio>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130808174629.46b698cf@doppio>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Bluemle <andreas.bluemle-jy6uzZffzV0b1SvskN2V4Q@public.gmane.org>
Cc: Sage Weil <sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org>, "Kasper, Dieter" <dieter.kasper-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I am currently testing rsockets in connection with ceph.
> I am using LD_PRELOAD and the librspreload.so to force
> the application (ceph) to use rsockets instead of regular
> tcp/ip sockets.
> 
> All this works pretty well - until the point where an
> established connection is shut down: this seems to not
> work and never finishes (unless the application is killed...).
> 
> The way ceph uses sockets is in a nonblocking mode.
> When reading from a socket, it polls the socket first
> with an event mask of POLLIN and POLLRDHUP.

rsockets does not handle POLLRDHUP.  Support for that would need to be added.
 
> On the return from the poll() I see that
>   - POLLIN and POLLHUP are set in the returned events
>     (POLLRDHUP is *not* set)
>   - errno is 95 (EOPNOTSUPP)
> 
> (The POLLHUP makes me believe that in this case the other
> end has shutdown the socket already.)
> 
> The EOPNOTSUPP confuses ceph quite a bit and prevents it
> from shutting down it's side of the socket connection properly.
> 
> 
> Question: is it possible that the POLLRDHUP causes the
> EOPNOTSUPP to be set by librspreload::poll() or
> rpoll()?

That's likely.

A call to poll() from the app eventually winds its way down to the real poll() routine.  The 'fd' representing the rsocket ends up being converted to an fd that's basically an open file used to communicate with the RDMA stack in the kernel.  Returning EOPNOTSUPP for POLLRDHUP on an open file looks reasonable.

If this is the case, POLLRDHUP needs to be removed from the real poll() call and handled within the rsocket rpoll() implementation.

Btw, if it's possible, copying the linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org mail list on this would be helpful in showing both the use of rsocket and where additional work is needed in a more public way.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
