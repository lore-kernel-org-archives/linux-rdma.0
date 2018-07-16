From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [RFC PATCH mlx5-next 04/18] net/mlx5: Break encap/decap into two
 separated flags
Date: Tue, 17 Jul 2018 00:28:43 +0300
Message-ID: <CAJ3xEMipNtMX52K1om-e-9YkSYkBqYeBfbBL03NLkC3sXp=bbA@mail.gmail.com>
References: <20180716082305.11744-1-leon@kernel.org> <20180716082305.11744-5-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180716082305.11744-5-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Mark Bloch <markb@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 16, 2018 at 11:22 AM, Leon Romanovsky <leon@kernel.org> wrote:
> From: Mark Bloch <markb@mellanox.com>
>
> Today we are able to attach encap and decap actions only to the FDB.
> In preparation to enable those actions on the NIC flow tables break

tables break --> tables, break

> the single flag into two.
