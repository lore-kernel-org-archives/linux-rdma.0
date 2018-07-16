From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [RFC PATCH rdma-next 13/18] RDMA/mlx5: Enable decap and packet
 reformat on flow tables
Date: Tue, 17 Jul 2018 00:23:54 +0300
Message-ID: <CAJ3xEMiLrSZMqZTSySB+PwUsXoHfh99QJZ+_WdQQn4sgA2HYNQ@mail.gmail.com>
References: <20180716082305.11744-1-leon@kernel.org> <20180716082305.11744-14-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716082305.11744-14-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Mark Bloch <markb@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 16, 2018 at 11:23 AM, Leon Romanovsky <leon@kernel.org> wrote:
> From: Mark Bloch <markb@mellanox.com>
>
> If NIC RX flow tables support decap opertion, enable it on creation.

opertion --> operation

> If NIC TX flow tables support reformat opertion, enable it on creation.

What is the trigger to use the decap flag on RX table or encap flag on
TX table?

Please note that we have a short blanket w.r.t mutual usage by
NIC vs e-Switch  steering, did you consider to do that on demand?
