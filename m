From: Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH mlx5-next 1/2] net/mlx5: Add temperature warning event to
 log
Date: Wed, 30 May 2018 18:17:20 +0200
Message-ID: <20180530161720.GE27537@lunn.ch>
References: <20180530001954.12000-1-saeedm@mellanox.com>
 <20180530001954.12000-2-saeedm@mellanox.com>
 <20180530010404.GB30239@lunn.ch>
 <994d317b8c28c197ec4f8b7db67bcd045cb0284e.camel@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <994d317b8c28c197ec4f8b7db67bcd045cb0284e.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Ilan Tayari <ilant@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>, Adi Nissim <adin@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

> Hi Andrew, yes the temperature is available by other means, this patch
> is needed for alert information reasons in order to know which internal
> sensors triggered the alarm.
> We are working in parallel to expose temperature sensor to hwmon, but
> this is still WIP.
> 
> 
> Is it ok to have both ?

Hi Saeed

Ideally no. hwmon has mechanisms for setting alarm thresholds, and
indicating the thresholds have been exceeded. There are also ways to
tie this to thermal zones, so the system can react on overheating,
slow down the CPU, drop voltages, ramp up fans, etc. hwmon should be
your primary interface, not dmesg.

But if you are stuck doing things in the wrong order, i guess it is
O.K. I don't think dmesg is a Binary API, so you can remove it later.

     Andrew
