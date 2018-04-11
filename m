From: Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL] asm-generic fixes for v4.17-rc1
Date: Wed, 11 Apr 2018 17:40:02 +0200
Message-ID: <CAK8P3a081_hkr5d0FRWpTaT-AsJoqznsS1=_WF4JVLTUOupUgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sinan Kaya <okaya@codeaurora.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, linux-arch <linux-arch@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Ley Foon Tan <lftan@altera.com>, "moderated list:NIOS2 ARCHITECTURE" <nios2-dev@lists.rocketboards.org>, Michal Simek <monstr@monstr.eu>, "moderated list:H8/300 ARCHITECTURE" <uclinux-h8-devel@lists.sourceforge.jp>, Yoshinori Sato <ysato@users.sourceforge.jp>, sparclinux <sparclinux@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, Guan
List-Id: linux-rdma@vger.kernel.org

The following changes since commit 0adb32858b0bddf4ada5f364a84ed60b196dbcda:

  Linux 4.16 (2018-04-01 14:20:27 -0700)

are available in the git repository at:

  git+ssh://gitolite@ra.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git
tags/asm-generic

for you to fetch changes up to a71e7c44ffb7baea0c0795824afc34cc0bc1a301:

  io: change writeX_relaxed() to remove barriers (2018-04-10 16:37:34 +0200)

----------------------------------------------------------------
asm-generic fixes for v4.17-rc1

I have one regression fix for a minor build problem after the architecture
removal series, plus a rework of the barriers in the readl/writel
functions, thanks to work by Sinan Kaya:

This started from a discussion on the linuxpcc and rdma mailing lists
[1]. To summarize, we decided that architectures are responsible to
serialize readl() and writel() accesses on a device MMIO space relative
to DMA performed by that device.

This series provides a pessimistic implementation of that behavior for
asm-generic/io.h, which is in turn used by a number of architectures
(h8300, microblaze, nios2, openrisc, s390, sparc, um, unicore32, and
xtensa). Some of those presumably need no extra barriers, or something
weaker than rmb()/wmb(), and they are advised to override the new default
for better performance.

For inb()/outb(), the same barriers are used, but architectures might
want to add another barrier to outb() here if that can guarantee
non-posted behavior (some architectures can, others cannot do that).

The readl_relaxed()/writel_relaxed() family of functions retains the
existing behavior with no extra barriers.

[1]: https://lists.ozlabs.org/pipermail/linuxppc-dev/2018-March/170481.html

----------------------------------------------------------------
Liu, Changcheng (1):
      dts: remove cris & metag dts hard link file

Sinan Kaya (7):
      io: define several IO & PIO barrier types for the asm-generic version
      io: define stronger ordering for the default readX() implementation
      io: define stronger ordering for the default writeX() implementation
      io: change outX() to have their own IO barrier overrides
      io: change inX() to have their own IO barrier overrides
      io: change readX_relaxed() to remove barriers
      io: change writeX_relaxed() to remove barriers

 include/asm-generic/io.h           | 161
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------
 scripts/dtc/include-prefixes/cris  |   1 -
 scripts/dtc/include-prefixes/metag |   1 -
 3 files changed, 143 insertions(+), 20 deletions(-)
 delete mode 120000 scripts/dtc/include-prefixes/cris
 delete mode 120000 scripts/dtc/include-prefixes/metag
