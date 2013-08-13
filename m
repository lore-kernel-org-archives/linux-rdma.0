From: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [ceph-users] Help needed porting Ceph to RSockets
Date: Tue, 13 Aug 2013 10:35:35 -0400
Message-ID: <1978D1F9-C675-4A37-AA57-C7E1158B2F72@ornl.gov>
References: <CAJA05UmTDGze7S50_j8RgHmPFYonk2Z94Fi6CQtxND9QxgRr3g@mail.gmail.com>
 <CAJA05Umgio7XftGZtQdRzyWq70pXBb3oEx2jrT3BxcBr6MLoVQ@mail.gmail.com>
 <20130812075513.43c338e1@andylap>
 <CAJA05U=i22jHy2xbvCUk+UVN0+hOFDgt-JMSHTWKmr1+DZu0Dg@mail.gmail.com>
 <20130812180644.447ca089@andylap>
 <CAJA05U=KqzYis14sYXusbpk-T-F=uqvNz1XPurutmdeRz6BAdg@mail.gmail.com>
 <20130813075312.7cac0d46@andylap> <20130813160612.037ea9f2@andylap>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130813160612.037ea9f2@andylap>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andreas Bluemle <andreas.bluemle-jy6uzZffzV0b1SvskN2V4Q@public.gmane.org>
Cc: Matthew Anderson <manderson8787-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Aug 13, 2013, at 10:06 AM, Andreas Bluemle <andreas.bluemle@itxperts=
=2Ede> wrote:

> Hi Matthew,
>=20
> I found a workaround for my (our) problem: in the librdmacm
> code, rsocket.c, there is a global constant polling_time, which
> is set to 10 microseconds at the moment.
>=20
> I raise this to 10000 - and all of a sudden things work nicely.

I am adding the linux-rdma list to CC so Sean might see this.

If I understand what you are describing, the caller to rpoll() spins fo=
r up to 10 ms (10,000 us) before calling the real poll().

What is the purpose of the real poll() call? Is it simply a means to bl=
ock the caller and avoid spinning? Or does it actually expect to detect=
 an event?

> I think we are looking at two issues here:
> 1. the thread structure of ceph messenger
>   For a given socket connection, there are 3 threads of interest
>   here: the main messenger thread, the Pipe::reader and the
>   Pipe::writer.
>=20
>   For a ceph client like the ceph admin command, I see the following
>   sequence
>     - the connection to the ceph monitor is created by the
>       main messenger  thread, the Pipe::reader and
>       Pipe::writer are instantiated.
>     - the requested command is sent to the ceph monitor, the
>       answer is read and printed
>     - at this point the Pipe::reader already has called
>       tcp_read_wait(), polling for more data or connection terminatio=
n
>     - after the response had been printed, the main loop calls the
>       shutdown routines which in in turn shutdown() the socket
>=20
>    There is some time between the last two steps - and this gap is
>    long enough to open a race:
>=20
> 2. rpoll, ibv and poll
>   the rpoll implementation in rsockets is split in 2 phases:
>   - a busy loop which checks the state of the underlying ibv queue pa=
ir
>   - the call to real poll() system call (i.e. the uverbs(?)
>     implementation of poll() inside the kernel)
>=20
>   The busy loop has a maximum duration of polling_time (10 microsecon=
ds
>   by default) - and is able detect the local shutdown and returns a
>   POLLHUP.
>=20
>   The poll() system call (i.e. the uverbs implementation of poll()=20
>   in the kernel) does not detect the local shutdown - and only return=
s
>   after the caller supplied timeout expires.
>=20
> Increasing the rsockets polloing_time from 10 to 10000 microseconds
> results in the rpoll to detect the local shutdown within the busy loo=
p.
>=20
> Decreasing the ceph "ms tcp read timeout" from the default of 900 to =
5
> seconds serves a similar purpose, but is much coarser.
>=20
> From my understanding, the real issue is neither at the ceph nor at t=
he
> rsockets level: it is related to the uverbs kernel module.
>=20
> An alternative way to address the current problem at the rsockets lev=
el
> would be w re-write of the rpoll(): instead of the busy loop at the
> beginning followed by the reall poll() call with the full user
> specificed timeout value ("ms tcp read timeout" in our case), I would
> embed the real poll()  into a loop, splitting the user specified time=
out
> into smaller portions and doing the rsockets specific rs_poll_check()
> on every timeout of the real poll().

I have not looked at the rsocket code, so take the following with a gra=
in of salt. If the purpose of the real poll() is to simply block the us=
er for a specified time, then you can simply make it a short duration (=
taking into consideration what granularity the OS provides) and then ca=
ll ibv_poll_cq(). Keep in mind, polling will prevent your CPU from redu=
cing power.

If the real poll() is actually checking for something (e.g. checking on=
 the RDMA channel's fd or the IB channel's fd), then you may not want t=
o spin too much.

Scott

> Best Regards
>=20
> Andreas Bluemle
>=20
>=20
> On Tue, 13 Aug 2013 07:53:12 +0200
> Andreas Bluemle <andreas.bluemle-jy6uzZffzV0b1SvskN2V4Q@public.gmane.org> wrote:
>=20
>> Hi Matthew,
>>=20
>> I can confirm the beahviour whichi you describe.
>> I too believe that the problem is on the client side (ceph command).
>> My log files show the very same symptom, i.e. the client side
>> not being able to shutdown the pipes properly.
>>=20
>> (Q: I had problems yesterday to send a mail to ceph-users list
>> with the log files attached to it because of the size of=20
>> the attachments exceeding some limit; I hadn=C4t been subscribed
>> to the list at that point. Is the uses of pastebin.com the better
>> way to provide such lengthy information in general?
>>=20
>>=20
>> Best Regards
>>=20
>> Andreas Bluemle
>>=20
>> On Tue, 13 Aug 2013 11:59:36 +0800
>> Matthew Anderson <manderson8787-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>=20
>>> Moving this conversation to ceph-devel where the dev's might be abl=
e
>>> to shed some light on this.
>>>=20
>>> I've added some additional debug to my code to narrow the issue dow=
n
>>> a bit and the reader thread appears to be getting locked by
>>> tcp_read_wait() because rpoll never returns an event when the socke=
t
>>> is shutdown. A hack way of proving this was to lower the timeout in
>>> rpoll to 5 seconds. When command like 'ceph osd tree' completes you
>>> can see it block for 5 seconds until rpoll times out and returns 0.
>>> The reader thread is then able to join and the pipe can be reaped.
>>>=20
>>> Ceph log is here - http://pastebin.com/rHK4vYLZ
>>> Mon log is here - http://pastebin.com/WyAJEw0m
>>>=20
>>> What's particularly weird is that the monitor receives a POLLHUP
>>> event when the ceph command shuts down it's socket but the ceph
>>> command never does. When using regular sockets both sides of the
>>> connection receive a POLLIN | POLLHUP | POLRDHUP event when the
>>> sockets are shut down. It would seem like there is a bug in rsocket=
s
>>> that causes the side that calls shutdown first not to receive the
>>> correct rpoll events.
>>>=20
>>> Can anyone comment on whether the above seems right?
>>>=20
>>> Thanks all
>>> -Matt
>>>=20
>>>=20
>>> On Tue, Aug 13, 2013 at 12:06 AM, Andreas Bluemle <
>>> andreas.bluemle-jy6uzZffzV0b1SvskN2V4Q@public.gmane.org> wrote:
>>>=20
>>>> Hi Matthew,
>>>>=20
>>>> I am not quite sure about the POLLRDHUP.
>>>> On the server side (ceph-mon), tcp_read_wait does see the
>>>> POLLHUP - which should be the indicator that the
>>>> the other side is shutting down.
>>>>=20
>>>> I have also taken a brief look at the client side (ceph mon stat).
>>>> It initiates a shutdown - but never finishes. See attached log
>>>> file from "ceph --log-file ceph-mon-stat.rsockets --debug-ms 30
>>>> mon stat". I have also attached the corresponding log file for
>>>> regualr TCP/IP sockets.
>>>>=20
>>>> It looks to me that in the rsockets case, the reaper is able to
>>>> cleanup even though there is still sth. left to do - and hence the
>>>> shutdown never completes.
>>>>=20
>>>>=20
>>>> Best Regards
>>>>=20
>>>> Andreas Bluemle
>>>>=20
>>>>=20
>>>> On Mon, 12 Aug 2013 15:11:47 +0800
>>>> Matthew Anderson <manderson8787-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>=20
>>>>> Hi Andreas,
>>>>>=20
>>>>> I think we're both working on the same thing, I've just changed
>>>>> the function calls over to rsockets in the source instead of
>>>>> using the pre-load library. It explains why we're having the
>>>>> exact same problem!
>>>>>=20
>>>>> From what I've been able to tell the entire problem revolves
>>>>> around rsockets not supporting POLLRDHUP. As far as I can tell
>>>>> the pipe will only be removed when tcp_read_wait returns -1.
>>>>> With rsockets it never receives the POLLRDHUP event after
>>>>> shutdown_socket() is called so the rpoll call blocks until
>>>>> timeout (900 seconds) and the pipe stays active.
>>>>>=20
>>>>> The question then would be how can we destroy a pipe without
>>>>> relying on POLLRDHUP? shutdown_socket() always gets called when
>>>>> the socket should be closed so could there might be a way to
>>>>> trick tcp_read_wait() into returning -1 by doing somethere in
>>>>> shutdown_socket() but I'm not sure how to go about it.
>>>>>=20
>>>>> Any ideas?
>>>>>=20
>>>>=20
>>=20
>>=20
>>=20
>=20
>=20
>=20
> --=20
> Andreas Bluemle                     mailto:Andreas.Bluemle@itxperts.d=
e
> Heinrich Boell Strasse 88           Phone: (+49) 89 4317582
> D-81829 Muenchen (Germany)          Mobil: (+49) 177 522 0151
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
