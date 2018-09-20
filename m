From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH rdma-next v1 0/7] Preparation to DevX extension series
Date: Thu, 20 Sep 2018 23:16:01 +0300
Message-ID: <CAJ3xEMjcB=8QSEg1hXrKd4m8HF11Ttf2Pw_bRP17p9MJEte-GA@mail.gmail.com>
References: <20180920183526.13995-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180920183526.13995-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 20, 2018 at 9:35 PM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>

> Set uid as part of various IB commands so that the firmware can manage
> the IB object in a secured way.

This series deals with FS core and commands used by the Ethernet driver

>   net/mlx5: Update mlx5_ifc with DEVX UID bits
>   net/mlx5: Set uid as part of CQ commands
>   net/mlx5: Set uid as part of RQ commands
>   net/mlx5: Set uid as part of SQ commands

such as the life-cycle (create, modify, destroy) of objects like:
RQ/SQ/CQ/etc --
saying IB commands is inaccurate, please be more precise


>
> The firmware should mark this IB object with the given uid so that it
> can be used later on only by objects with the same uid.

these are not IB objects, but rather Ethernet objects

>
> Upon DEVX flows that use this objec, the pointed object must have
> the same uid as of the issuer uid command.

typo - objec --> object

>
> When a command is issued with uid=0 it means that the issuer of the
> command is trusted (i.e. kernel), in that case any pointed object
> can be used regardless of its uid.
>
> Thanks
>
>   net/mlx5: Set uid as part of SRQ commands
>   net/mlx5: Set uid as part of DCT commands
>   net/mlx5: Set uid as part of QP commands
