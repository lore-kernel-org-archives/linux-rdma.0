From: Benjamin Drung <benjamin.drung@profitbricks.com>
Subject: Bug#894995: rdma-core: Please add support for new architecture "riscv64" (RISC-V 64 bits little-endian)
Date: Thu, 19 Apr 2018 14:00:18 +0200
Message-ID: <1524139218.4781.9.camel@profitbricks.com>
References: <152297424964.29286.16311629290309565149.reportbug@reva.itsari.org> <152297424964.29286.16311629290309565149.reportbug@reva.itsari.org>
Reply-To: Benjamin Drung <benjamin.drung@profitbricks.com>, 894995@bugs.debian.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist2=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.894995.B894995.15241392224602@bugs.debian.org>
In-Reply-To: <152297424964.29286.16311629290309565149.reportbug@reva.itsari.org>
List-URL: <https://lists.debian.org/debian-bugs-dist/>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: "Manuel A. Fernandez Montecelo" <mafm@debian.org>, 894995@bugs.debian.org, List Linux RDMA Mailing <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Thanks for reporting this bug.

Am Freitag, den 06.04.2018, 02:24 +0200 schrieb Manuel A. Fernandez
Montecelo:
> Source: rdma-core
> Version: 17.1-1
> Severity: normal
> Tags: patch
> User: debian-riscv@lists.debian.org
> Usertags: riscv64
> 
> Hello,
> 
> The current version of this package doesn't build for the riscv64
> port.
> 
> First it fails to be considered to build (due to missing valgrind)
> and, when
> fixing that problem, FBTFS, because of missing files (see at bottom).

I'll apply that part of the patch.

> I applied the same fix as for many other arches, which is to add the
> arch to the
> list of NO_COHERENT_DMA_ARCHS in debian/rules.
> 
> I am not sure if support could be added at a later date, but for the
> time being,
> seems to be the best way to get it working -- I don't know enough
> details of the
> architecture or the assembly language to get the necessary
> incantations in
> place.

RISC-V has a FENCE instruction and the A extension (which is part of
the G instruction set) provides atomic memory operations. So the
architecture should provide coherent DMA support. To enable support,
util/udma_barrier.h needs to be adjusted. I am including
linux-rdma@vger.kernel.org in the loop for help.
