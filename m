From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2] IB/mlx4: Increase the timeout for CM cache
Date: Fri, 22 Feb 2019 11:18:00 -0700
Message-ID: <20190222181800.GA9524@ziepe.ca>
References: <20190217144512.1171546-1-haakon.bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190217144512.1171546-1-haakon.bugge@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?B?SMOla29u?= Bugge <haakon.bugge@oracle.com>
Cc: Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, jackm@dev.mellanox.co.il, majd@mellanox.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 17, 2019 at 03:45:12PM +0100, Håkon Bugge wrote:
> Using CX-3 virtual functions, either from a bare-metal machine or
> pass-through from a VM, MAD packets are proxied through the PF driver.
> 
> Since the VF drivers have separate name spaces for MAD Transaction Ids
> (TIDs), the PF driver has to re-map the TIDs and keep the book keeping
> in a cache.
> 
> Following the RDMA Connection Manager (CM) protocol, it is clear when
> an entry has to evicted form the cache. But life is not perfect,
> remote peers may die or be rebooted. Hence, it's a timeout to wipe out
> a cache entry, when the PF driver assumes the remote peer has gone.
> 
> During workloads where a high number of QPs are destroyed concurrently,
> excessive amount of CM DREQ retries has been observed
> 
> The problem can be demonstrated in a bare-metal environment, where two
> nodes have instantiated 8 VFs each. This using dual ported HCAs, so we
> have 16 vPorts per physical server.
> 
> 64 processes are associated with each vPort and creates and destroys
> one QP for each of the remote 64 processes. That is, 1024 QPs per
> vPort, all in all 16K QPs. The QPs are created/destroyed using the
> CM.
> 
> When tearing down these 16K QPs, excessive CM DREQ retries (and
> duplicates) are observed. With some cat/paste/awk wizardry on the
> infiniband_cm sysfs, we observe as sum of the 16 vPorts on one of the
> nodes:
> 
> cm_rx_duplicates:
>       dreq  2102
> cm_rx_msgs:
>       drep  1989
>       dreq  6195
>        rep  3968
>        req  4224
>        rtu  4224
> cm_tx_msgs:
>       drep  4093
>       dreq 27568
>        rep  4224
>        req  3968
>        rtu  3968
> cm_tx_retries:
>       dreq 23469
> 
> Note that the active/passive side is equally distributed between the
> two nodes.
> 
> Enabling pr_debug in cm.c gives tons of:
> 
> [171778.814239] <mlx4_ib> mlx4_ib_multiplex_cm_handler: id{slave:
> 1,sl_cm_id: 0xd393089f} is NULL!
> 
> By increasing the CM_CLEANUP_CACHE_TIMEOUT from 5 to 30 seconds, the
> tear-down phase of the application is reduced from approximately 90 to
> 50 seconds. Retries/duplicates are also significantly reduced:
> 
> cm_rx_duplicates:
>       dreq  2460
> []
> cm_tx_retries:
>       dreq  3010
>        req    47
> 
> Increasing the timeout further didn't help, as these duplicates and
> retries stems from a too short CMA timeout, which was 20 (~4 seconds)
> on the systems. By increasing the CMA timeout to 22 (~17 seconds), the
> numbers fell down to about 10 for both of them.
> 
> Adjustment of the CMA timeout is not part of this commit.
> 
> Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
> Acked-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
> ---

Applied to for-next

Thanks,
Jason
