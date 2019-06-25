From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH][next] RDMA/hns: fix potential integer overflow on left
 shift
Date: Tue, 25 Jun 2019 13:19:15 +0000
Message-ID: <20190625131911.GA10878@mellanox.com>
References: <20190624214608.11765-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190624214608.11765-1-colin.king@canonical.com>
Content-Language: en-US
Content-ID: <62262B7684038143A1595B5CC61C0407@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Lijun Ou <oulijun@huawei.com>, Wei Hu <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 24, 2019 at 10:46:08PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>=20
> There is a potential integer overflow when int i is left shifted
> as this is evaluated using 32 bit arithmetic but is being used in
> a context that expects an expression of type dma_addr_t.  Fix this
> by casting integer i to dma_addr_t before shifting to avoid the
> overflow.
>=20
> Addresses-Coverity: ("Unintentional integer overflow")
> Fixes: 2ac0bc5e725e ("RDMA/hns: Add a group interfaces for optimizing buf=
fers getting flow")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/infiniband/hw/hns/hns_roce_alloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to for-next, thanks

Jason
