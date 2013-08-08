From: Andreas Bluemle <andreas.bluemle-jy6uzZffzV0b1SvskN2V4Q@public.gmane.org>
Subject: Re: using rsockets via librspreload: poll() support?
Date: Thu, 8 Aug 2013 18:52:42 +0200
Message-ID: <20130808185242.5d6f039f@doppio>
References: <20130808174629.46b698cf@doppio>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130808174629.46b698cf@doppio>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sage Weil <sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org>, "Kasper, Dieter" <dieter.kasper-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

I begin to believe that this may be a more general
problem: it seems to me that errno is not always
initialized to 0 when the librspreload wrapper for
a socket system call or the corresponding r*()
routine from rsocket.c is called.

For the poll() I have cleared the errno explicitly
before polling the socket - and it is still cleared
on return from poll(). Hence: where I used to encounter
an EOPNOTSUPP, I now see errno 0 (i.e. "Success").


Best Regards

Andreas Bluemle


On Thu, 8 Aug 2013 17:46:29 +0200
Andreas Bluemle <andreas.bluemle-jy6uzZffzV0b1SvskN2V4Q@public.gmane.org> wrote:

> Hi Sean,
> 
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
> 
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
> 
> Best Regards
> 
> Andreas Bluemle
> 
> 
> 
> 



-- 
Andreas Bluemle                     mailto:Andreas.Bluemle-jy6uzZffzV0b1SvskN2V4Q@public.gmane.org
ITXperts GmbH                       http://www.itxperts.de
Balanstrasse 73, Geb. 08            Phone: (+49) 89 89044917
D-81541 Muenchen (Germany)          Fax:   (+49) 89 89044910

Company details: http://www.itxperts.de/imprint.htm
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
