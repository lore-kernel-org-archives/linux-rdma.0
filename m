From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] rds: fix building with IPV6=m
Date: Tue, 14 Aug 2018 10:06:52 -0700 (PDT)
Message-ID: <20180814.100652.1049665545919235495.davem@davemloft.net>
References: <20180814090752.1681486-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180814090752.1681486-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de
Cc: santosh.shilimkar@oracle.com, anders.roxell@linaro.org, gthelen@google.com, ka-cheong.poon@oracle.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 14 Aug 2018 11:07:42 +0200

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

Applied.
