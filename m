From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [GIT PULL] Please Pull Mellanox Shared Code
Date: Mon, 13 Jun 2016 16:49:13 +0300
Message-ID: <CAJ3xEMig1DCz=VE1uN6igUQ0uiP4L9bzdn=hJU0ij78qME4dHg@mail.gmail.com>
References: <20160613120301.GF5408@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20160613120301.GF5408@leon.nu>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, "David S. Miller" <davem@davemloft.net>, RDMA mailing list <linux-rdma@vger.kernel.org>, linux-netdev <netdev@vger.kernel.org>, Matan Barak <matanb@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 13, 2016 at 3:03 PM, Leon Romanovsky <leon@kernel.org> wrote:
> Hi Doug and David,
>
> This is Mellanox mlx5_core shared code for both net-next and RDMA
> trees for 4.8 kernel cycle.
>
> This mlx5_ifc update introduces following ConnectX-4 features.
>
> * netdev part:
>  - MLX5_CQ_PERIOD_NUM_MODES for adaptive moderation support
>  - QoS rate limiting
>  - SQ context rate limiting
>  - Auto negotiation fields in PTYS register
>  - Source SQN field in flow table entry match structure
>  - DCBX parameters
>
> * RDMA part:
>  - New XRQ opcodes, commands and capabilities layout
>  - Extend Q counters definition to support IB.

Leon, any reason not to send the actual patch over the list as any
other submission we do? please send it over.

Or.
