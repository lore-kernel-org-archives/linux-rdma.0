From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next 00/10] IPoIB uninit
Date: Thu, 2 Aug 2018 20:31:17 -0600
Message-ID: <20180803023117.GA11840@ziepe.ca>
References: <20180729083500.5352-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180729083500.5352-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Denis Drozdov <denisd@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 29, 2018 at 11:34:50AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> IP link was broken due to the changes in IPoIB for the rdma_netdev
> support after commit cd565b4b51e5 ("IB/IPoIB: Support acceleration options callbacks").
> 
> This patchset restores IPoIB pkey creation and removal using rtnetlink.
> 
> It is completely rewritten variant of
> https://marc.info/?l=linux-rdma&m=151553425830918&w=2 patch series.
> 
> Thanks
> 
> Erez Shitrit (2):
>   IB/ipoib: Use cancel_delayed_work_sync for neigh-clean task
>   IB/ipoib: Make ipoib_neigh_hash_uninit fully fence its work
> 
> Jason Gunthorpe (8):
>   IB/ipoib: Get rid of IPOIB_FLAG_GOING_DOWN
>   IB/ipoib: Move all uninit code into ndo_uninit
>   IB/ipoib: Move init code to ndo_init
>   RDMA/netdev: Use priv_destructor for netdev cleanup
>   IB/ipoib: Get rid of the sysfs_mutex
>   IB/ipoib: Do not remove child devices from within the ndo_uninit
>   IB/ipoib: Maintain the child_intfs list from ndo_init/uninit
>   IB/ipoib: Consolidate checking of the proposed child interface

Applied to for-next, finally this bug is fixed..

I squashed these two patches though:

   IB/ipoib: Use cancel_delayed_work_sync for neigh-clean task
   IB/ipoib: Make ipoib_neigh_hash_uninit fully fence its work

Thanks,
Jason
