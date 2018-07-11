From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] [v3] infiniband: i40iw, nes: don't use wall time for TCP
 sequence numbers
Date: Wed, 11 Jul 2018 12:26:06 -0600
Message-ID: <20180711182606.GA22284@ziepe.ca>
References: <20180709083523.448587-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180709083523.448587-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>, "David S. Miller" <davem@davemloft.net>, Geert Uytterhoeven <geert@linux-m68k.org>, Yuval Shaia <yuval.shaia@oracle.com>, Henry Orosco <henry.orosco@intel.com>, Tatyana Nikolova <tatyana.e.nikolova@intel.com>, Mustafa Ismail <mustafa.ismail@intel.com>, Jia-Ju Bai <baijiaju1990@gmail.com>, Bart Van Assche <bart.vanassche@wdc.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 09, 2018 at 10:34:43AM +0200, Arnd Bergmann wrote:
> The nes infiniband driver uses current_kernel_time() to get a nanosecond
> granunarity timestamp to initialize its tcp sequence counters. This is
> one of only a few remaining users of that deprecated function, so we
> should try to get rid of it.
> 
> Aside from using a deprecated API, there are several problems I see here:
> 
> - Using a CLOCK_REALTIME based time source makes it predictable in
>   case the time base is synchronized.
> - Using a coarse timestamp means it only gets updated once per jiffie,
>   making it even more predictable in order to avoid having to access
>   the hardware clock source
> - The upper 2 bits are always zero because the nanoseconds are at most
>   999999999.
> 
> For the Linux TCP implementation, we use secure_tcp_seq(), which appears
> to be appropriate here as well, and solves all the above problems.
> 
> i40iw uses a variant of the same code, so I do that same thing there
> for ipv4. Unlike nes, i40e also supports ipv6, which needs to call
> secure_tcpv6_seq instead.
> 
> Acked-by: Shiraz Saleem <shiraz.saleem@intel.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: use secure_tcpv6_seq for IPv6 support as suggested by Shiraz Saleem.
> v3: add a soft IPv6 dependency to prevent a link error with CONFIG_IPV6=m,
>     this now forces i40iw to be a module as well, add an IS_ENABLED()
>     check to avoid calling it when IPV6 is completely disabled.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/infiniband/hw/i40iw/Kconfig    |  1 +
>  drivers/infiniband/hw/i40iw/i40iw_cm.c | 26 +++++++++++++++++++++-----
>  drivers/infiniband/hw/nes/nes_cm.c     |  8 +++++---
>  net/core/secure_seq.c                  |  1 +
>  4 files changed, 28 insertions(+), 8 deletions(-)

Applied to for-next thanks

Jason
