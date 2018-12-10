From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH mlx5-next 07/10] net/mlx5: E-Switch, Change vhca id valid
 bool field to bit flag
Date: Mon, 10 Dec 2018 21:51:30 +0200
Message-ID: <CAJ3xEMj0MBdYSkuqj-Bb+t=A2JXBZCnagQarmmszBh-z-YS=ug@mail.gmail.com>
References: <20181210030442.7543-1-saeedm@mellanox.com> <20181210030442.7543-8-saeedm@mellanox.com>
 <20181210161216.GF3459@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181210161216.GF3459@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Linux Netdev List <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Eli Britstein <elibr@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 10, 2018 at 6:31 PM Jason Gunthorpe <jgg@mellanox.com> wrote:
> On Sun, Dec 09, 2018 at 07:04:39PM -0800, Saeed Mahameed wrote:
> > From: Eli Britstein <elibr@mellanox.com>
> >
> > Change the driver flow destination struct to use bit flags with the vhca
> > id valid being the 1st one. Done to avoid bool fields in structs, as
> > warned by static checkers, with no functionality change.
>
> This is a thing now? I thought the warning was not to use bool with
> bitfields for some reason?

we have downstream, patch that puts more content into the flags field, so
the change is justified also as pre-step to that commit
