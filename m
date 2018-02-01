From: Marta Rybczynska <mrybczyn@kalray.eu>
Subject: Re: Backport Mellanox mlx5 patches to stable 4.9.y
Date: Thu, 1 Feb 2018 14:04:40 +0100 (CET)
Message-ID: <1067971124.17656949.1517490280812.JavaMail.zimbra@kalray.eu>
References: <622645763.11304810.1517303571694.JavaMail.zimbra@kalray.eu> <20180201082116.GG15896@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180201082116.GG15896@kroah.com>
Sender: stable-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: matanb@mellanox.com, leonro@mellanox.com, saeedm@mellanox.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sean hefty <sean.hefty@intel.com>, hal rosenstock <hal.rosenstock@gmail.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

----- Mail original -----
> On Tue, Jan 30, 2018 at 10:12:51AM +0100, Marta Rybczynska wrote:
>> Hello Mellanox maintainers,
>> I'd like to ask you to OK backporting two patches in mlx5 driver to 4.9 stable
>> tree (they're in master for some time already).
>> 
>> We have multiple deployment in 4.9 that are running into the bug fixed by those
>> patches. We're deploying patched kernels and the issue disappears.
>> 
>> The patches are:
>> 1410a90ae449061b7e1ae19d275148f36948801b net/mlx5: Define interface bits for
>> fencing UMR wqe
>> 6e8484c5cf07c7ee632587e98c1a12d319dacb7c RDMA/mlx5: set UMR wqe fence according
>> to HCA cap
> 
> Looks good, now queued up, thanks.
> 
> greg k-h

Thanks Greg!

Marta
