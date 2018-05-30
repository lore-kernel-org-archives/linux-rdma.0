From: Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH mlx5-next 1/2] net/mlx5: Add temperature warning event to
 log
Date: Wed, 30 May 2018 03:04:04 +0200
Message-ID: <20180530010404.GB30239@lunn.ch>
References: <20180530001954.12000-1-saeedm@mellanox.com>
 <20180530001954.12000-2-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180530001954.12000-2-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>, Ilan Tayari <ilant@mellanox.com>, Adi Nissim <adin@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 29, 2018 at 05:19:53PM -0700, Saeed Mahameed wrote:
> From: Ilan Tayari <ilant@mellanox.com>
> 
> Temperature warning event is sent by FW to indicate high temperature
> as detected by one of the sensors on the board.
> Add handling of this event by writing the numbers of the alert sensors
> to the kernel log.

Hi Saaed

Is the temperature itself available? If so, it would be better to
expose this as a hwmon device per temperature sensor.

       Andrew
