From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] net/mlx5e: fix high stack usage
Date: Fri, 2 Nov 2018 11:00:20 -0600
Message-ID: <20181102170020.GB17096@ziepe.ca>
References: <20181102153316.1492515-1-arnd@arndb.de>
 <20181102160858.GA17096@ziepe.ca>
 <CAK8P3a2pvkfR1A6dHAMm8ETd13E1LSxXrEsQHSOFYWbr-7R2Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK8P3a2pvkfR1A6dHAMm8ETd13E1LSxXrEsQHSOFYWbr-7R2Sw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, "David S. Miller" <davem@davemloft.net>, Tariq Toukan <tariqt@mellanox.com>, Eran Ben Elisha <eranbe@mellanox.com>, Boris Pismenny <borisp@mellanox.com>, Ilya Lesokhin <ilyal@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>, Kamal Heib <kamalh@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 02, 2018 at 05:23:26PM +0100, Arnd Bergmann wrote:
> On 11/2/18, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > On Fri, Nov 02, 2018 at 04:33:03PM +0100, Arnd Bergmann wrote:
> >> A patch that looks harmless causes the stack usage of the
> >> mlx5e_grp_sw_update_stats()
> >> function to drastically increase with x86 gcc-4.9 and higher (tested up to
> >> 8.1):
> >>
> >> drivers/net/ethernet/mellanox/mlx5/core/en_stats.c: In function
> >> ‘mlx5e_grp_sw_update_stats’:
> >> drivers/net/ethernet/mellanox/mlx5/core/en_stats.c:216:1: warning: the
> >> frame size of 1276 bytes is larger than 500 bytes [-Wframe-larger-than=]
> >
> > Why is the stack size so big here? The mlx5e_sw_stats is < 500 bytes
> > and all the other on-stack stuff looks pretty small?
> 
> I am not entirely sure, but my analysis indicates that gcc tries loop unrolling
> or some other optimization that leads to two copies on the stack.

Wow how strange

Did you consier adding a
  __attribute__((optimize("no-unroll-loops"))) 

type macro?

Jason
