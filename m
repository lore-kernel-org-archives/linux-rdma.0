From: Saeed Mahameed <saeedm@dev.mellanox.co.il>
Subject: Re: [PATCH V2 mlx5-next 0/4] mlx5 core CQE API and misc updates
Date: Sun, 9 Dec 2018 18:18:44 -0800
Message-ID: <CALzJLG8UeRgqpOBKiyrtnqavYKhRLCbNrug5tkWyrV4dfmgxrg@mail.gmail.com>
References: <20181205230810.1886-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181205230810.1886-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, Linux Netdev List <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 5, 2018 at 3:08 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> Hi
>
> This patchset is for mlx5-next shared branch, and will be applied there
> once the review is done.
>
> Patches 1,2,3 are trivial improvements to CQE API
> 1. return CQE pointer instead of void pointer in get_cqe function
> 2. helper function for retrieving the CQE opcode, used in rdma and netdev
>
> Patch 4, Move flow counters data structures definition to c file.
>
> V1->v2:
>         - move #include <llist.h> in patch 4
>

Applied to mlx5-next.

Thanks.
