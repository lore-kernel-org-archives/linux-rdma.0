From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH][next] net/mlx5e: Remove redundant assignment
Date: Tue, 05 Mar 2019 19:03:23 -0800 (PST)
Message-ID: <20190305.190323.1175144356168830240.davem@davemloft.net>
References: <da1f1300-20f4-2929-078b-71ac1772a933@mellanox.com>
        <20190304062645.GZ15253@mtr-leonro.mtl.com>
        <176546c027a13f39c0dd8d5915b2d16b98637782.camel@mellanox.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <176546c027a13f39c0dd8d5915b2d16b98637782.camel@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: saeedm@mellanox.com
Cc: roid@mellanox.com, leon@kernel.org, netdev@vger.kernel.org, gustavo@embeddedor.com, elibr@mellanox.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Tue, 5 Mar 2019 22:21:39 +0000

> On Mon, 2019-03-04 at 08:26 +0200, Leon Romanovsky wrote:
>> On Sun, Mar 03, 2019 at 03:20:57PM +0000, Roi Dayan wrote:
>> > 
>> > On 02/03/2019 21:39, Gustavo A. R. Silva wrote:
>> > > Remove redundant assignment to tun_entropy->enabled.
>> > > 
>> > > Addesses-Coverity-ID: 1477328 ("Unused value")
>> > > Fixes: 97417f6182f8 ("net/mlx5e: Fix GRE key by controlling port
>> > > tunnel entropy calculation")
>> > 
>> > the commit doesn't fix any real issue but is more of a cleanup.
>> > so I'm not sure if fixes line is relevant or not.
>> > beside that looks ok.
>> 
>> It doesn't matter if it is real issue or not, the code is wrong and
>> should be fixed. This alone is enough to see the Fixes line.
>> 
>> Thanks,
>> Acked-by: Leon Romanovsky <leonro@mellanox.com>
> 
> Acked-by: Saeed Mahameed <saeedm@mellanox.com>
> Dave, Do you think such patch should go to net, or do you want me to
> send it in my next pull request to net-next, once it is open of course
> ?

This feels more like net-next stuff to me, thanks for asking.
