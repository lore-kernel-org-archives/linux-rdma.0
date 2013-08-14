From: Andreas Bluemle <andreas.bluemle@itxperts.de>
Subject: Re: [ceph-users] Help needed porting Ceph to RSockets
Date: Wed, 14 Aug 2013 09:21:24 +0200
Message-ID: <20130814092124.3f8c3b03@doppio>
References: <CAJA05UmTDGze7S50_j8RgHmPFYonk2Z94Fi6CQtxND9QxgRr3g@mail.gmail.com>
	<CAJA05Umgio7XftGZtQdRzyWq70pXBb3oEx2jrT3BxcBr6MLoVQ@mail.gmail.com>
	<20130812075513.43c338e1@andylap>
	<CAJA05U=i22jHy2xbvCUk+UVN0+hOFDgt-JMSHTWKmr1+DZu0Dg@mail.gmail.com>
	<20130812180644.447ca089@andylap>
	<CAJA05U=KqzYis14sYXusbpk-T-F=uqvNz1XPurutmdeRz6BAdg@mail.gmail.com>
	<20130813075312.7cac0d46@andylap>
	<20130813160612.037ea9f2@andylap>
	<1978D1F9-C675-4A37-AA57-C7E1158B2F72@ornl.gov>
	<1828884A29C6694DAF28B7E6B8A8237388CA5A0F@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CA5A0F@ORSMSX109.amr.corp.intel.com>
Sender: ceph-devel-owner@vger.kernel.org
To: "Hefty, Sean" <sean.hefty@intel.com>
Cc: "Atchley, Scott" <atchleyes@ornl.gov>, Matthew Anderson <manderson8787@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "linux-rdma@vger.kernel.org (linux-rdma@vger.kernel.org)" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

maybe some information about the environment I am
working in:

- CentOS 6.4 with custom kernel 3.8.13
- librdmacm / librspreload from git, tag 1.0.17
- application started with librspreload in LD_PRELOAD environment

Currently, I have increased the value of the spin time by setting the
default value for polling_time in the source code.

I guess that the correct way to do this is via
configuration in /etc/rdma/rsocket/polling_time?

Concerning the rpoll() itself, some more comments/questions
embedded below.

On Tue, 13 Aug 2013 21:44:42 +0000
"Hefty, Sean" <sean.hefty@intel.com> wrote:

> > > I found a workaround for my (our) problem: in the librdmacm
> > > code, rsocket.c, there is a global constant polling_time, which
> > > is set to 10 microseconds at the moment.
> > >
> > > I raise this to 10000 - and all of a sudden things work nicely.
> > 
> > I am adding the linux-rdma list to CC so Sean might see this.
> > 
> > If I understand what you are describing, the caller to rpoll()
> > spins for up to 10 ms (10,000 us) before calling the real poll().
> > 
> > What is the purpose of the real poll() call? Is it simply a means
> > to block the caller and avoid spinning? Or does it actually expect
> > to detect an event?
> 
> When the real poll() is called, an event is expected on an fd
> associated with the CQ's completion channel. 

The first question I would have is: why is the rpoll() split into
these two pieces? There must have been some reason to do a busy
loop on some local state information rather than just call the
real poll() directly.

> > > I think we are looking at two issues here:
> > > 1. the thread structure of ceph messenger
> > >   For a given socket connection, there are 3 threads of interest
> > >   here: the main messenger thread, the Pipe::reader and the
> > >   Pipe::writer.
> > >
> > >   For a ceph client like the ceph admin command, I see the
> > > following sequence
> > >     - the connection to the ceph monitor is created by the
> > >       main messenger  thread, the Pipe::reader and
> > >       Pipe::writer are instantiated.
> > >     - the requested command is sent to the ceph monitor, the
> > >       answer is read and printed
> > >     - at this point the Pipe::reader already has called
> > >       tcp_read_wait(), polling for more data or connection
> > > termination
> > >     - after the response had been printed, the main loop calls the
> > >       shutdown routines which in in turn shutdown() the socket
> > >
> > >    There is some time between the last two steps - and this gap is
> > >    long enough to open a race:
> > >
> > > 2. rpoll, ibv and poll
> > >   the rpoll implementation in rsockets is split in 2 phases:
> > >   - a busy loop which checks the state of the underlying ibv
> > > queue pair
> > >   - the call to real poll() system call (i.e. the uverbs(?)
> > >     implementation of poll() inside the kernel)
> > >
> > >   The busy loop has a maximum duration of polling_time (10
> > > microseconds by default) - and is able detect the local shutdown
> > > and returns a POLLHUP.
> > >
> > >   The poll() system call (i.e. the uverbs implementation of poll()
> > >   in the kernel) does not detect the local shutdown - and only
> > > returns after the caller supplied timeout expires.
> 
> It sounds like there's an issue here either with a message getting
> lost or a race.  Given that spinning longer works for you, it sounds
> like an event is getting lost, not being generated correctly, or not
> being configured to generate.
> 

I am looking at a multithreaded application here, and I believe that
the race is between thread A calling the rpoll() for POLLIN event and
thread B calling the shutdown(SHUT_RDWR) for reading and writing of
the (r)socket almost immediately afterwards.

I think that the shutdown itself does not cause a POLLHUP event to be
generated from the kernel to interupt the real poll().
(BTW: which kernel module implements the poll() for rsockets?
Is that ib_uverbs.ko with ib_uverbs_poll_cq()?)

> > > Increasing the rsockets polloing_time from 10 to 10000
> > > microseconds results in the rpoll to detect the local shutdown
> > > within the busy loop.
> > >
> > > Decreasing the ceph "ms tcp read timeout" from the default of 900
> > > to 5 seconds serves a similar purpose, but is much coarser.
> > >
> > > From my understanding, the real issue is neither at the ceph nor
> > > at the rsockets level: it is related to the uverbs kernel module.
> > >
> > > An alternative way to address the current problem at the rsockets
> > > level would be w re-write of the rpoll(): instead of the busy
> > > loop at the beginning followed by the reall poll() call with the
> > > full user specificed timeout value ("ms tcp read timeout" in our
> > > case), I would embed the real poll()  into a loop, splitting the
> > > user specified timeout into smaller portions and doing the
> > > rsockets specific rs_poll_check() on every timeout of the real
> > > poll().
> > 
> > I have not looked at the rsocket code, so take the following with a
> > grain of salt. If the purpose of the real poll() is to simply block
> > the user for a specified time, then you can simply make it a short
> > duration (taking into consideration what granularity the OS
> > provides) and then call ibv_poll_cq(). Keep in mind, polling will
> > prevent your CPU from reducing power.
> > 
> > If the real poll() is actually checking for something (e.g.
> > checking on the RDMA channel's fd or the IB channel's fd), then you
> > may not want to spin too much.
> 
> The real poll() call is intended to block the application until a
> timeout occurs or an event shows up.  Since increasing the spin time
> works for you, it makes me suspect that there is a bug in the CQ
> event handling in rsockets. 

> > >>> What's particularly weird is that the monitor receives a POLLHUP
> > >>> event when the ceph command shuts down it's socket but the ceph
> > >>> command never does. When using regular sockets both sides of the
> > >>> connection receive a POLLIN | POLLHUP | POLRDHUP event when the
> > >>> sockets are shut down. It would seem like there is a bug in
> > >>> rsockets that causes the side that calls shutdown first not to
> > >>> receive the correct rpoll events.
> 
> rsockets does not support POLLRDHUP.
> 

I don't think the issue is POLLRDHUP.
I think the issue is POLLHUP and/or POLLIN.
My impression is that on a local shutdown (r)socket, a poll
for POLLIN event should at least return a POLLIN event and
a subsequent read should return 0 bytes indicating EOF.
But the POLLIN is not generated from the layer below 
rsockets (ib_uverbs.ko?) as far as I can tell.

See also: http://www.greenend.org.uk/rjk/tech/poll.html

Best Regards

Andreas Bluemle

> - Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 




-- 
Andreas Bluemle                     mailto:Andreas.Bluemle@itxperts.de
ITXperts GmbH                       http://www.itxperts.de
Balanstrasse 73, Geb. 08            Phone: (+49) 89 89044917
D-81541 Muenchen (Germany)          Fax:   (+49) 89 89044910

Company details: http://www.itxperts.de/imprint.htm
