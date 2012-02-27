From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: ibv_fork_init() question
Date: Mon, 27 Feb 2012 11:58:45 -0800
Message-ID: <CAG4TOxMSS_2V8peLn6fcd9q6oWgWOFnCsxazAxKvhdRhnes46w@mail.gmail.com>
References: <4F4BDF8D.7070902@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F4BDF8D.7070902-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 27, 2012 at 11:54 AM, Steve Wise
<swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> I'm experimenting with doing RDMA operations from a child process and=
 I have
> a question. =A0My application calls ibv_fork_init() at startup (first=
 thing in
> main()) =A0and it succeeds, and I see, for instance, that libibverbs =
has
> initialized mm_root. =A0Next my application registers page-aligned me=
mory that
> is 8KB in size. =A0The memory was allocated with memalign(). =A0Then =
the app
> sets up a connection to an RDMA peer. =A0Next the application calls f=
ork().
> =A0The parent does a wait() and the child does an rdma read operation=
 into
> this registered memory from a valid mr of the peer. =A0The read succe=
eds from
> the rdma device perspective. =A0But when the child process tries to r=
ead the
> memory (to verify the rdma operation worked), I get a seg fault.
>
> Q: Am I doing something incorrect here? =A0I can't find much document=
ation on
> how this all should work.

Yeah, unfortunately this isn't really intended to work and I don't have=
 a
good suggestion on how to make it work.

Even with the libibverbs fork support, the expectation is that all RDMA
stuff will be done from the master process.  All that the ibv_fork_init=
()
call does is trigger tracking so that the address space that is used fo=
r
RDMA isn't mapped into the child process at all.

So yeah, what you see happening is exactly what I would expect.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
