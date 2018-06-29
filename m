From: Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [PATCH] [v2] infiniband: i40iw, nes: don't use wall time for TCP
 sequence numbers
Date: Fri, 29 Jun 2018 17:10:52 -0500
Message-ID: <20180629221052.GA14152@ssaleem-MOBL4.amr.corp.intel.com>
References: <20180627132628.915978-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180627132628.915978-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "Latif, Faisal" <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, "David S. Miller" <davem@davemloft.net>, "Orosco, Henry" <henry.orosco@intel.com>, "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>, "Ismail, Mustafa" <mustafa.ismail@intel.com>, Bart Van Assche <bart.vanassche@wdc.com>, Yuval Shaia <yuval.shaia@oracle.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 27, 2018 at 07:26:05AM -0600, Arnd Bergmann wrote:
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
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: use secure_tcpv6_seq for IPv6 support as suggested by Shiraz Saleem.
> ---

Looks good.

Acked-by: Shiraz Saleem <shiraz.saleem@intel.com>
