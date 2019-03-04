From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v1] mellanox: Switch to bitmap_zalloc()
Date: Mon, 04 Mar 2019 10:19:46 -0800 (PST)
Message-ID: <20190304.101946.568923925126741734.davem@davemloft.net>
References: <20190304085700.88095-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190304085700.88095-1-andriy.shevchenko@linux.intel.com>
Sender: netdev-owner@vger.kernel.org
To: andriy.shevchenko@linux.intel.com
Cc: netdev@vger.kernel.org, saeedm@mellanox.com, leon@kernel.org, jiri@mellanox.com, idosch@mellanox.com, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Mon,  4 Mar 2019 10:57:00 +0200

> Switch to bitmap_zalloc() to show clearly what we are allocating.
> Besides that it returns pointer of bitmap type instead of opaque void *.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Applied.
