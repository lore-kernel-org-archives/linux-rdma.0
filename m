From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: next build: 7 warnings 0 failures (next/next-20160720)
Date: Wed, 20 Jul 2016 12:25:48 +0200
Message-ID: <5106658.dbvAtpQNOs@wuerfel>
References: <578f4bea.0568620a.1e97.8d17@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <578f4bea.0568620a.1e97.8d17@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kernel-build-reports@lists.linaro.org
Cc: Olof's autobuilder <build@lixom.net>, olof@lixom.net, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, gregkh@linuxfoundation.org, linux-media@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>, info@kernelci.org
List-Id: linux-rdma@vger.kernel.org

On Wednesday, July 20, 2016 3:01:14 AM CEST Olof's autobuilder wrote:
>        Passed:                 122
>        Failed:                 0
>        Warnings:               7
>        Section mismatches:     0

Looking pretty good, almost no warnings left. The first one in this
list is the only one that already exists in v4.7 (and a long time
before that), all other preexisting warnings are fixed in -next.

The kernelci autobuilder finds a couple of other warnings on top
of these, because they build more unusual configurations and use
some slightly older compilers that produce false positives.

> Warnings:
>       1 drivers/infiniband/core/cma.c:1242:12: warning: 'src_addr_storage.sin_addr.s_addr' may be used uninitialized in this function [-Wmaybe-uninitialized]

I sent a patch on July 4 to the infiniband list but got no reply.
It only shows up on powerpc, presumably with an older compiler, so I
don't consider this as urgent, the only reason to fix it up would be
to get to zero warnings for the common architectures.

Doug, any chance you can still pick up "infiniband: shut up a
maybe-uninitialized warning" for 4.8?

>       1 drivers/tty/serial/8250/8250_fintek.c:34:0: warning: "IRQ_MODE" redefined

I sent a patch on June 26 to Greg, but he hasn't applied any serial
driver patches since June 25, so I assume it's in his queue and will
make it into v4.8 without further action on my side.

>       2 drivers/media/dvb-frontends/cxd2841er.c:3408:40: warning: 'carrier_offset' may be used uninitialized in this function [-Wmaybe-uninitialized]

It's in patchwork, so I assume Mauro will get to it in time:
https://patchwork.linuxtv.org/patch/35398/

The warning was introduced by a patch outside of drivers/media
in linux-mm ("dynamic_debug: add jump label support").

>       3 drivers/net/wireless/ti/wlcore/spi.c:457:6: warning: unused variable 'ret' [-Wunused-variable]

This came up today, and the author of the patch that broke it already
sent a fix "wlcore: spi: fix build warning caused by redundant variable".

	Arnd
