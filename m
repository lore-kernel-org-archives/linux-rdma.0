From: Saeed Mahameed <saeedm@dev.mellanox.co.il>
Subject: Re: [PATCH mlx5-next 07/10] net/mlx5: E-Switch, Change vhca id valid
 bool field to bit flag
Date: Mon, 10 Dec 2018 11:12:18 -0800
Message-ID: <CALzJLG9hD04A1GZwD=oRvMBFm8v1AL8AT-c4gwD8DEuJq3Q0Wg@mail.gmail.com>
References: <20181210030442.7543-1-saeedm@mellanox.com> <20181210030442.7543-8-saeedm@mellanox.com>
 <20181210161216.GF3459@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181210161216.GF3459@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Linux Netdev List <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, elibr@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 10, 2018 at 8:12 AM Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> On Sun, Dec 09, 2018 at 07:04:39PM -0800, Saeed Mahameed wrote:
> > From: Eli Britstein <elibr@mellanox.com>
> >
> > Change the driver flow destination struct to use bit flags with the vhca
> > id valid being the 1st one. Done to avoid bool fields in structs, as
> > warned by static checkers, with no functionality change.
>
> This is a thing now? I thought the warning was not to use bool with
> bitfields for some reason?
>

Yea, the commit message is kinda silly,
But the patch makes sense since having a flag can be more extendable
in the future, e.g in the next patch:
MLX5_FLOW_DEST_VPORT_REFORMAT_ID

We can fix the commit message.

> Jason
