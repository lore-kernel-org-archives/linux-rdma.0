From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] rds: store socket timestamps as ktime_t
Date: Fri, 31 Aug 2018 18:04:24 -0700 (PDT)
Message-ID: <20180831.180424.463682127429889241.davem@davemloft.net>
References: <20180829154732.844217-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180829154732.844217-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de
Cc: santosh.shilimkar@oracle.com, sowmini.varadhan@oracle.com, willemb@google.com, ka-cheong.poon@oracle.com, s.mesoraca16@gmail.com, avinash.repaka@oracle.com, edumazet@google.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 29 Aug 2018 17:47:19 +0200

> rds is the last in-kernel user of the old do_gettimeofday()
> function. Convert it over to ktime_get_real() to make it
> work more like the generic socket timestamps, and to let
> us kill off do_gettimeofday().
> 
> A follow-up patch will have to change the user space interface
> to deal better with 32-bit tasks, which may use an incompatible
> layout for 'struct timespec'.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks.
