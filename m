From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [GIT PULL] please pull ummunotify
Date: Thu, 17 Sep 2009 13:30:28 +0200
Message-ID: <1253187028.8439.2.camel@twins>
References: <aday6omhz9d.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <aday6omhz9d.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Anton Blanchard <anton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2009-09-10 at 21:38 -0700, Roland Dreier wrote:
> Linus, please consider pulling from
>=20
>     master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git=
 ummunotify
>=20
> This tree is also available from kernel.org mirrors at:
>=20
>     git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.g=
it ummunotify
>=20
> This will get "ummunotify," a new character device that allows a
> userspace library to register for MMU notifications; this is
> particularly useful for MPI implementions (message passing libraries
> used in HPC) to be able to keep track of what wacky things consumers
> do to their memory mappings.  My colleague Jeff Squyres from the Open
> MPI project posted a blog entry about why MPI wants this:
>=20
> http://blogs.cisco.com/ciscotalk/performance/comments/better_linux_me=
mory_tracking/
>=20
> His summary of ummunotify:
>=20
>   "It=E2=80=99s elegant, doesn=E2=80=99t require strange linker trick=
s, and seems to
>    work in all cases.  Yay!"
>=20
> This code went through several review iterations on lkml and was in
> -mm and -next for quite a few weeks.  Andrew is OK with merging it (I
> think -- Andrew please correct me if I misunderstood you).

Anton Blanchard suggested a while back that this might be integrated
with perf-counters, since perf-counters already does mmap() tracking an=
d
also provides events through an mmap()'ed buffer.

Has anybody looked into this?

If someone did and I missed the discussion on why it isn't appropriate,
kindly point me in the right direction ;-)


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
