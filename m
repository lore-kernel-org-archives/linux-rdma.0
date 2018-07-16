From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [RFC PATCH mlx5-next 02/18] net/mlx5: Export modify header
 alloc/dealloc functions
Date: Tue, 17 Jul 2018 00:27:18 +0300
Message-ID: <CAJ3xEMjk6_G52tE2UoOX9LvHcbNbJviLpR6HGE1DnkG5A2vcKw@mail.gmail.com>
References: <20180716082305.11744-1-leon@kernel.org> <20180716082305.11744-3-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716082305.11744-3-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Mark Bloch <markb@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 16, 2018 at 11:22 AM, Leon Romanovsky <leon@kernel.org> wrote:
> From: Mark Bloch <markb@mellanox.com>
>
> Those function will be used by the RDMA side to create modify header

function --> functions

> actions to be attached to flow steering rules via verbs.
