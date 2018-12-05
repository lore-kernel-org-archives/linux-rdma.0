From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH mlx5-next 2/4] net/mlx5: Use helper to get CQE opcode
Date: Tue, 4 Dec 2018 20:55:45 -0800
Message-ID: <CAM_iQpUpiE3weH5Rw9a3Uz7bcLbNVxWH+WTjnSZNL+15ih6wAQ@mail.gmail.com>
References: <20181205020303.16318-1-saeedm@mellanox.com> <20181205020303.16318-3-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181205020303.16318-3-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: leonro@mellanox.com, Linux Kernel Network Developers <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 4, 2018 at 6:06 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> +static inline u8 get_cqe_opcode(struct mlx5_cqe64 *cqe)

Make it const please.
