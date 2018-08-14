From: Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH] rds: fix building with IPV6=m
Date: Tue, 14 Aug 2018 12:15:06 -0700
Message-ID: <xr93mutosqth.fsf@gthelen.svl.corp.google.com>
References: <20180814090752.1681486-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180814090752.1681486-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Santosh Shilimkar <santosh.shilimkar@oracle.com>, "David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Anders Roxell <anders.roxell@linaro.org>, Ka-Cheong Poon <ka-cheong.poon@oracle.com>, Stephen Hemminger <stephen@networkplumber.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:

> When CONFIG_RDS_TCP is built-in and CONFIG_IPV6 is a loadable
> module, we get a link error agains the modular ipv6_chk_addr()
> function:
>
> net/rds/tcp.o: In function `rds_tcp_laddr_check':
> tcp.c:(.text+0x3b2): undefined reference to `ipv6_chk_addr'
>
> This adds back a dependency that forces RDS_TCP to also be
> a loadable module when IPV6 is one.
>
> Fixes: e65d4d96334e ("rds: Remove IPv6 dependency")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Greg Thelen <gthelenq@google.com>
