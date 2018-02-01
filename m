From: Greg KH <greg@kroah.com>
Subject: Re: Backport Mellanox mlx5 patches to stable 4.9.y
Date: Thu, 1 Feb 2018 09:21:16 +0100
Message-ID: <20180201082116.GG15896@kroah.com>
References: <622645763.11304810.1517303571694.JavaMail.zimbra@kalray.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <622645763.11304810.1517303571694.JavaMail.zimbra@kalray.eu>
Sender: netdev-owner@vger.kernel.org
To: Marta Rybczynska <mrybczyn@kalray.eu>
Cc: matanb@mellanox.com, leonro@mellanox.com, saeedm@mellanox.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 30, 2018 at 10:12:51AM +0100, Marta Rybczynska wrote:
> Hello Mellanox maintainers,
> I'd like to ask you to OK backporting two patches in mlx5 driver to 4.9 stable
> tree (they're in master for some time already).
> 
> We have multiple deployment in 4.9 that are running into the bug fixed by those
> patches. We're deploying patched kernels and the issue disappears.
> 
> The patches are:
> 1410a90ae449061b7e1ae19d275148f36948801b net/mlx5: Define interface bits for fencing UMR wqe
> 6e8484c5cf07c7ee632587e98c1a12d319dacb7c RDMA/mlx5: set UMR wqe fence according to HCA cap

Looks good, now queued up, thanks.

greg k-h
