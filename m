From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH V2 mlx5-next 4/9] net/mlx5: Add monitor commands layout
 and event data
Date: Mon, 10 Dec 2018 16:48:58 -0800
Message-ID: <CAM_iQpUN+veKna5rAFvJMLXWsS5BKLCBbuBFCX_Hy_Z36T22JA@mail.gmail.com>
References: <20181210211517.3686-1-saeedm@mellanox.com> <20181210211517.3686-5-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181210211517.3686-5-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: leonro@mellanox.com, Linux Kernel Network Developers <netdev@vger.kernel.org>, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, eyald@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 10, 2018 at 1:55 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
> +enum mlx5_monitor_counter_ppcnt {
> +       MLX5_QUERY_MONITOR_PPCNT_IN_RANGE_LENGTH_ERRORS      = 0X0,
> +       MLX5_QUERY_MONITOR_PPCNT_OUT_OF_RANGE_LENGTH_FIELD   = 0X1,
> +       MLX5_QUERY_MONITOR_PPCNT_FRAME_TOO_LONG_ERRORS       = 0X2,
> +       MLX5_QUERY_MONITOR_PPCNT_FRAME_CHECK_SEQUENCE_ERRORS = 0X3,
> +       MLX5_QUERY_MONITOR_PPCNT_ALIGNMENT_ERRORS            = 0X4,
> +       MLX5_QUERY_MONITOR_PPCNT_IF_OUT_DISCARDS             = 0X5,
> +};
> +
> +enum {
> +       MLX5_QUERY_MONITOR_Q_COUNTER_RX_OUT_OF_BUFFER     = 0X4,
> +};

Is there any reason to capitalize these 0X prefixes?

Thanks.
