From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [RFC PATCH mlx5-next 01/18] net/mlx5: Add proper NIC TX steering
 flow tables support
Date: Tue, 17 Jul 2018 00:14:03 +0300
Message-ID: <CAJ3xEMinTavwbF3fbD=FDGxGCKt9DuGFPNQOJwA2mwpEHN3Ttw@mail.gmail.com>
References: <20180716082305.11744-1-leon@kernel.org> <20180716082305.11744-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716082305.11744-2-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Mark Bloch <markb@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 16, 2018 at 11:22 AM, Leon Romanovsky <leon@kernel.org> wrote:
> From: Mark Bloch <markb@mellanox.com>
>
> Expose the ability to add steering rules to NIC TX flow tables.
> For now, we are only adding TX bypass (egress) which is used by the RDMA
> side. While we are here clean the switch logic.
>
> We expose the same number of priorities as the RX bypass.

What is the use-case / model for priorities in TX steering?

Is/where this (tx prios) is used @ downstream patch?

Or.
