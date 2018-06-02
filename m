From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH V2 mlx5-next 0/2] Mellanox, mlx5 new device events
Date: Sat, 02 Jun 2018 09:07:39 -0400 (EDT)
Message-ID: <20180602.090739.109800509954239583.davem@davemloft.net>
References: <20180531.153603.45475041396194381.davem@davemloft.net>
        <34cedd2bed26c85e886426bde8635081a4b36e64.camel@mellanox.com>
        <a6385f91ca1611184391b1949f26f531ae812911.camel@mellanox.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <a6385f91ca1611184391b1949f26f531ae812911.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: saeedm@mellanox.com
Cc: jgg@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, leonro@mellanox.com
List-Id: linux-rdma@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Sat, 2 Jun 2018 00:17:37 +0000

> On Fri, 2018-06-01 at 17:13 -0700, saeedm@mellanox.com wrote:
>> Hey Dave, this series was meant to go to mlx5-next tree as stated in
>> the cover letter and patches titles "[PATCH V2 mlx5-next 0/2]".
>> 
>> It is ok you applied those patches to net-next this time, but for
>> next
>> time I would like to apply them myself to mlx5-next and send a clean
>> pull request later to both rdma and net trees.
> 
> Sorry please ignore, I just saw that this was sorted out .. :).
> Thanks A lot !
> 
>> Is there a way for me to mark them as delegated in patchwork ?
>> I see that i have "update Properties" option in patchwork but i don't
>> know how to use it or whether I am allowed to do anything with it.
> 
> It would be great if we can mark such patches in patchwork though.. 

I really don't like it when others adjust patchwork state on me.
Florian Fainelli did it for a brief time for some of his own patches
and it caused a lot of confusion for me, so I asked him to stop.

Let's just make sure that the Subject line says mlx5-next or whatever
instead of net-next and I'll be mindful in such situations.

Thanks.
