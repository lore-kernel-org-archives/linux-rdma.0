From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ceph-users] Help needed porting Ceph to RSockets
Date: Tue, 13 Aug 2013 21:44:42 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CA5A0F@ORSMSX109.amr.corp.intel.com>
References: <CAJA05UmTDGze7S50_j8RgHmPFYonk2Z94Fi6CQtxND9QxgRr3g@mail.gmail.com>
 <CAJA05Umgio7XftGZtQdRzyWq70pXBb3oEx2jrT3BxcBr6MLoVQ@mail.gmail.com>
 <20130812075513.43c338e1@andylap>
 <CAJA05U=i22jHy2xbvCUk+UVN0+hOFDgt-JMSHTWKmr1+DZu0Dg@mail.gmail.com>
 <20130812180644.447ca089@andylap>
 <CAJA05U=KqzYis14sYXusbpk-T-F=uqvNz1XPurutmdeRz6BAdg@mail.gmail.com>
 <20130813075312.7cac0d46@andylap> <20130813160612.037ea9f2@andylap>
 <1978D1F9-C675-4A37-AA57-C7E1158B2F72@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1978D1F9-C675-4A37-AA57-C7E1158B2F72-1Heg1YXhbW8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>, Andreas Bluemle <andreas.bluemle-jy6uzZffzV0b1SvskN2V4Q@public.gmane.org>
Cc: Matthew Anderson <manderson8787-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > I found a workaround for my (our) problem: in the librdmacm
> > code, rsocket.c, there is a global constant polling_time, which
> > is set to 10 microseconds at the moment.
> >
> > I raise this to 10000 - and all of a sudden things work nicely.
> 
> I am adding the linux-rdma list to CC so Sean might see this.
> 
> If I understand what you are describing, the caller to rpoll() spins for up to
> 10 ms (10,000 us) before calling the real poll().
> 
> What is the purpose of the real poll() call? Is it simply a means to block the
> caller and avoid spinning? Or does it actually expect to detect an event?

When the real poll() is called, an event is expected on an fd associated with the CQ's completion channel.
 
> > I think we are looking at two issues here:
> > 1. the thread structure of ceph messenger
> >   For a given socket connection, there are 3 threads of interest
> >   here: the main messenger thread, the Pipe::reader and the
> >   Pipe::writer.
> >
> >   For a ceph client like the ceph admin command, I see the following
> >   sequence
> >     - the connection to the ceph monitor is created by the
> >       main messenger  thread, the Pipe::reader and
> >       Pipe::writer are instantiated.
> >     - the requested command is sent to the ceph monitor, the
> >       answer is read and printed
> >     - at this point the Pipe::reader already has called
> >       tcp_read_wait(), polling for more data or connection termination
> >     - after the response had been printed, the main loop calls the
> >       shutdown routines which in in turn shutdown() the socket
> >
> >    There is some time between the last two steps - and this gap is
> >    long enough to open a race:
> >
> > 2. rpoll, ibv and poll
> >   the rpoll implementation in rsockets is split in 2 phases:
> >   - a busy loop which checks the state of the underlying ibv queue pair
> >   - the call to real poll() system call (i.e. the uverbs(?)
> >     implementation of poll() inside the kernel)
> >
> >   The busy loop has a maximum duration of polling_time (10 microseconds
> >   by default) - and is able detect the local shutdown and returns a
> >   POLLHUP.
> >
> >   The poll() system call (i.e. the uverbs implementation of poll()
> >   in the kernel) does not detect the local shutdown - and only returns
> >   after the caller supplied timeout expires.

It sounds like there's an issue here either with a message getting lost or a race.  Given that spinning longer works for you, it sounds like an event is getting lost, not being generated correctly, or not being configured to generate.

> > Increasing the rsockets polloing_time from 10 to 10000 microseconds
> > results in the rpoll to detect the local shutdown within the busy loop.
> >
> > Decreasing the ceph "ms tcp read timeout" from the default of 900 to 5
> > seconds serves a similar purpose, but is much coarser.
> >
> > From my understanding, the real issue is neither at the ceph nor at the
> > rsockets level: it is related to the uverbs kernel module.
> >
> > An alternative way to address the current problem at the rsockets level
> > would be w re-write of the rpoll(): instead of the busy loop at the
> > beginning followed by the reall poll() call with the full user
> > specificed timeout value ("ms tcp read timeout" in our case), I would
> > embed the real poll()  into a loop, splitting the user specified timeout
> > into smaller portions and doing the rsockets specific rs_poll_check()
> > on every timeout of the real poll().
> 
> I have not looked at the rsocket code, so take the following with a grain of
> salt. If the purpose of the real poll() is to simply block the user for a
> specified time, then you can simply make it a short duration (taking into
> consideration what granularity the OS provides) and then call ibv_poll_cq().
> Keep in mind, polling will prevent your CPU from reducing power.
> 
> If the real poll() is actually checking for something (e.g. checking on the
> RDMA channel's fd or the IB channel's fd), then you may not want to spin too
> much.

The real poll() call is intended to block the application until a timeout occurs or an event shows up.  Since increasing the spin time works for you, it makes me suspect that there is a bug in the CQ event handling in rsockets.
 
> >>> What's particularly weird is that the monitor receives a POLLHUP
> >>> event when the ceph command shuts down it's socket but the ceph
> >>> command never does. When using regular sockets both sides of the
> >>> connection receive a POLLIN | POLLHUP | POLRDHUP event when the
> >>> sockets are shut down. It would seem like there is a bug in rsockets
> >>> that causes the side that calls shutdown first not to receive the
> >>> correct rpoll events.

rsockets does not support POLLRDHUP.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
