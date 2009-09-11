From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [GIT PULL] please pull ummunotify
Date: Thu, 10 Sep 2009 21:38:22 -0700
Message-ID: <aday6omhz9d.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Linus, please consider pulling from

    master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git u=
mmunotify

This tree is also available from kernel.org mirrors at:

    git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git=
 ummunotify

This will get "ummunotify," a new character device that allows a
userspace library to register for MMU notifications; this is
particularly useful for MPI implementions (message passing libraries
used in HPC) to be able to keep track of what wacky things consumers
do to their memory mappings.  My colleague Jeff Squyres from the Open
MPI project posted a blog entry about why MPI wants this:

http://blogs.cisco.com/ciscotalk/performance/comments/better_linux_memo=
ry_tracking/

His summary of ummunotify:

  "It=E2=80=99s elegant, doesn=E2=80=99t require strange linker tricks,=
 and seems to
   work in all cases.  Yay!"

This code went through several review iterations on lkml and was in
-mm and -next for quite a few weeks.  Andrew is OK with merging it (I
think -- Andrew please correct me if I misunderstood you).

Roland Dreier (1):
      ummunotify: Userspace support for MMU notifications

 Documentation/Makefile                  |    3 +-
 Documentation/ummunotify/Makefile       |    7 +
 Documentation/ummunotify/ummunotify.txt |  150 ++++++++
 Documentation/ummunotify/umn-test.c     |  200 +++++++++++
 drivers/char/Kconfig                    |   12 +
 drivers/char/Makefile                   |    1 +
 drivers/char/ummunotify.c               |  566 +++++++++++++++++++++++=
++++++++
 include/linux/Kbuild                    |    1 +
 include/linux/ummunotify.h              |  121 +++++++
 9 files changed, 1060 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/ummunotify/Makefile
 create mode 100644 Documentation/ummunotify/ummunotify.txt
 create mode 100644 Documentation/ummunotify/umn-test.c
 create mode 100644 drivers/char/ummunotify.c
 create mode 100644 include/linux/ummunotify.h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
