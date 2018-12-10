From: Saeed Mahameed <saeedm@dev.mellanox.co.il>
Subject: Re: [PATCH V2 mlx5-next 0/9] mlx5 core updates and cleanups
Date: Mon, 10 Dec 2018 14:01:13 -0800
Message-ID: <CALzJLG8AyCY_6T0nAMfCgnYfDquPZgZJ=9Pawgu5P=qVCDXkFg@mail.gmail.com>
References: <20181210211517.3686-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181210211517.3686-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, Linux Netdev List <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Jason Gunthorpe <jgg@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 10, 2018 at 1:15 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> Hi
>
> This patchset is for mlx5-next shared branch, and will be applied there
> once the review is done.
>
> 1) From Eli Britstein, add mlx5 core support for flow steering extended
> destination
> 2) From Mikhael Goikhman, port module events cleanup and support for
> PCIe power slot exceeded errors and plugged-disabled cable status.
> 3) Eyal Davidovich adds monitor commands layout and event data.
> 4) From Or Gerlitz, remove unsed mlx5 interface callback (get_protocol).
> 5) From Oz Shlomo, Revise gre and nvgre key formats
>
> v1->v2:
>  - Improve commit message for "Change vhca id valid bool field to bit flag"
>  - mlx5_core_warn instead of pr_warn
>  - drop "IB/mlx5: Simplify netdev unbinding" patch, it can go to rdma only
>

Applied to mlx5-next.

Thanks.
