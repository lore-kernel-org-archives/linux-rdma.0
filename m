From: Saeed Mahameed <saeedm@dev.mellanox.co.il>
Subject: Re: [PATCH] net/mlx5e: Fix uninitialized variable
Date: Tue, 31 Jul 2018 14:47:58 -0700
Message-ID: <CALzJLG8=TttvWE_tqsqafU=qcV_c67UQYLqQzPwYnXXfX3PokA@mail.gmail.com>
References: <20180731142157.GA24066@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180731142157.GA24066@embeddedor.com>
Sender: netdev-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Tariq Toukan <tariqt@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leon@kernel.org>, "David S. Miller" <davem@davemloft.net>, Linux Netdev List <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 31, 2018 at 7:21 AM, Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
> There is a potential execution path in which variable *err* is returned
> without being properly initialized previously.
>
> Fix this by initializing variable *err* to 0.
>
> Addresses-Coverity-ID: 1472116 ("Uninitialized scalar variable")
> Fixes: 0ec13877ce95 ("net/mlx5e: Gather all XDP pre-requisite checks in a single function")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Acked-by: Saeed Mahameed <saeedm@mellanox.com>
