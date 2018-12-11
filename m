From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH -next] IB/mlx5: remove duplicated include from mlx5_ib.h
Date: Tue, 11 Dec 2018 20:43:55 +0000
Message-ID: <20181211204352.GA7497@mellanox.com>
References: <20181210072759.26128-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181210072759.26128-1-yuehaibing@huawei.com>
Content-Language: en-US
Content-ID: <F76130A78C8274498E3749FC687F9B92@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: "leon@kernel.org" <leon@kernel.org>, "dledford@redhat.com" <dledford@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 10, 2018 at 03:27:59PM +0800, YueHaibing wrote:
> Remove duplicated include.
>=20
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> Acked-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/mlx5_ib.h | 1 -
>  1 file changed, 1 deletion(-)

Applied to for-next

Thanks,
Jason
