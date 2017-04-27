From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net-next] mlx5: work around unused function warning
Date: Thu, 27 Apr 2017 14:04:15 +0200
Message-ID: <CAK8P3a0kX4uNLBvLAHrhtmUc7eBLmD6dXA8=xxY+xJ4OsGFJbg@mail.gmail.com>
References: <20170427110421.2431598-1-arnd@arndb.de> <20170427115513.GH14088@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170427115513.GH14088@mtr-leonro.local>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>, Matan Barak <matanb@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Erez Shitrit <erezsh@mellanox.com>, Dan Carpenter <dan.carpenter@oracle.com>, Stephen Hemminger <stephen@networkplumber.org>, Networking <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 27, 2017 at 1:55 PM, Leon Romanovsky <leonro@mellanox.com> wrote:
> On Thu, Apr 27, 2017 at 01:04:02PM +0200, Arnd Bergmann wrote:
>> The previous patch addressed a sparse warning but replaced it with a
>> compiler warning when CONFIG_MODULES is disabled:
>>
>> drivers/net/ethernet/mellanox/mlx5/core/ipoib.c:485:13: error: 'mlx5_rdma_netdev_free' defined but not used [-Werror=unused-function]
>> drivers/net/ethernet/mellanox/mlx5/core/ipoib.c:423:27: error: 'mlx5_rdma_netdev_alloc' defined but not used [-Werror=unused-function]
>>
>> We should never export 'static' functions, so this makes them global
>> again but hides them in another #ifdef like the change before.
>>
>> Fixes: a7082ef066f0 ("mlx5: hide unused functions")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Hi Arnd,
>
> Thanks for the patch, but Stephen and Saeed already sent patch similar to it.
> http://marc.info/?l=linux-netdev&m=149288674816288&w=2

That link is for the patch that introduced the warning that I'm fixing here,
it showed up yesterday in linux-next.

Did you misread my patch, or just give the wrong link?

      Arnd
