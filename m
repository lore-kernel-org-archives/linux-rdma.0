From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v1] mellanox: Switch to bitmap_zalloc()
Date: Mon, 04 Mar 2019 10:15:35 -0800 (PST)
Message-ID: <20190304.101535.1911763456650200123.davem@davemloft.net>
References: <20190304085700.88095-1-andriy.shevchenko@linux.intel.com>
        <20190304115946.GY2314@nanopsycho>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190304115946.GY2314@nanopsycho>
Sender: netdev-owner@vger.kernel.org
To: jiri@resnulli.us
Cc: andriy.shevchenko@linux.intel.com, netdev@vger.kernel.org, saeedm@mellanox.com, leon@kernel.org, jiri@mellanox.com, idosch@mellanox.com, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Mon, 4 Mar 2019 12:59:46 +0100

> Mon, Mar 04, 2019 at 09:57:00AM CET, andriy.shevchenko@linux.intel.com wrote:
>>Switch to bitmap_zalloc() to show clearly what we are allocating.
>>Besides that it returns pointer of bitmap type instead of opaque void *.
>>
>>Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> 
> Hoever, net-next is closed now, so you might have to repost after it
> opens again.

I'll probably take this one...
