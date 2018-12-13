From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] net/mlx5: Remove duplicated include from
 eswitch.c
Date: Wed, 12 Dec 2018 16:42:03 -0800 (PST)
Message-ID: <20181212.164203.103708083863926865.davem@davemloft.net>
References: <1544601818-134205-1-git-send-email-yuehaibing@huawei.com>
        <20181212.105545.763866630881735656.davem@davemloft.net>
        <3cf7b0661f16749bc1f1856f5f03b5ed385a06eb.camel@mellanox.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <3cf7b0661f16749bc1f1856f5f03b5ed385a06eb.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: saeedm@mellanox.com
Cc: yuehaibing@huawei.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, leon@kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Wed, 12 Dec 2018 20:27:59 +0000

> On Wed, 2018-12-12 at 10:55 -0800, David Miller wrote:
>> From: YueHaibing <yuehaibing@huawei.com>
>> Date: Wed, 12 Dec 2018 08:03:38 +0000
>> 
>> > Remove duplicated include.
>> > 
>> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> 
>> Saeed, how would you like me to handle small fixes like this which
>> have been
>> explicitly ACK'd by a Mellanox developer?
>> 
>> Do you want me to apply them directly or wait to get them from you in
>> your
>> next pull request?
>> 
> 
> Let's do the following, if I ACK them then you can apply them directly,
> otherwise i will notify and apply them to my branch and send them later
> to avoid any confusion or conflict with our shared branch.
> 
> Does that work for you ? if not then you can always leave them to me. 

That works for me, I'll apply directly only with your explicit ACK,
thanks Saeed.
