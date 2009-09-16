From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [GIT PULL] please pull ummunotify
Date: Wed, 16 Sep 2009 09:30:09 -0700
Message-ID: <ada1vm6g8dq.fsf@cisco.com>
References: <aday6omhz9d.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <aday6omhz9d.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> (Roland Dreier's message of "Thu, 10
	Sep 2009 21:38:22 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Linus,

Sorry to hassle you about this, but I would like to know where things
stand.  I know (from the reflink discussion if nothing else) that you'r=
e
definitely not bashful about telling people when their code sucks, so
this silent treatment has me really flustered.  I've been showering and
brushing my teeth and everything, honest!

Seriously, this code solves a problem that the MPI/HPC people have been
complaining about for quite a while, and if possible I'd like to get
this upstream.  Or if you have a better idea, I'm all ears...

Thanks,
  Roland

 > Linus, please consider pulling from
 >=20
 >     master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.gi=
t ummunotify
 >=20
 > This tree is also available from kernel.org mirrors at:
 >=20
 >     git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.=
git ummunotify
 >=20
 > This will get "ummunotify," a new character device that allows a
 > userspace library to register for MMU notifications; this is
 > particularly useful for MPI implementions (message passing libraries
 > used in HPC) to be able to keep track of what wacky things consumers
 > do to their memory mappings.  My colleague Jeff Squyres from the Ope=
n
 > MPI project posted a blog entry about why MPI wants this:
 >=20
 > http://blogs.cisco.com/ciscotalk/performance/comments/better_linux_m=
emory_tracking/
 >=20
 > His summary of ummunotify:
 >=20
 >   "It=E2=80=99s elegant, doesn=E2=80=99t require strange linker tric=
ks, and seems to
 >    work in all cases.  Yay!"
 >=20
 > This code went through several review iterations on lkml and was in
 > -mm and -next for quite a few weeks.  Andrew is OK with merging it (=
I
 > think -- Andrew please correct me if I misunderstood you).
 >=20
 > Roland Dreier (1):
 >       ummunotify: Userspace support for MMU notifications
 >=20
 >  Documentation/Makefile                  |    3 +-
 >  Documentation/ummunotify/Makefile       |    7 +
 >  Documentation/ummunotify/ummunotify.txt |  150 ++++++++
 >  Documentation/ummunotify/umn-test.c     |  200 +++++++++++
 >  drivers/char/Kconfig                    |   12 +
 >  drivers/char/Makefile                   |    1 +
 >  drivers/char/ummunotify.c               |  566 ++++++++++++++++++++=
+++++++++++
 >  include/linux/Kbuild                    |    1 +
 >  include/linux/ummunotify.h              |  121 +++++++
 >  9 files changed, 1060 insertions(+), 1 deletions(-)
 >  create mode 100644 Documentation/ummunotify/Makefile
 >  create mode 100644 Documentation/ummunotify/ummunotify.txt
 >  create mode 100644 Documentation/ummunotify/umn-test.c
 >  create mode 100644 drivers/char/ummunotify.c
 >  create mode 100644 include/linux/ummunotify.h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
