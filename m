From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH v1] mellanox: Switch to bitmap_zalloc()
Date: Mon, 4 Mar 2019 12:59:46 +0100
Message-ID: <20190304115946.GY2314@nanopsycho>
References: <20190304085700.88095-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190304085700.88095-1-andriy.shevchenko@linux.intel.com>
Sender: netdev-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Jiri Pirko <jiri@mellanox.com>, Ido Schimmel <idosch@mellanox.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Mon, Mar 04, 2019 at 09:57:00AM CET, andriy.shevchenko@linux.intel.com wrote:
>Switch to bitmap_zalloc() to show clearly what we are allocating.
>Besides that it returns pointer of bitmap type instead of opaque void *.
>
>Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>

Hoever, net-next is closed now, so you might have to repost after it
opens again.
