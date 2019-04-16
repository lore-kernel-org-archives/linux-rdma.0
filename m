From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH] RDMA/cxgb4: fix null pointer dereference on alloc_skb
 failure
Date: Tue, 16 Apr 2019 11:06:22 +0000
Message-ID: <20190416110618.GA15844@mellanox.com>
References: <20190413160026.5873-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190413160026.5873-1-colin.king@canonical.com>
Content-Language: en-US
Content-ID: <3A441435B82E8A41B10EF6265175C80D@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Potnuri Bharat Teja <bharat@chelsio.com>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Apr 13, 2019 at 05:00:26PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>=20
> Currently if alloc_skb fails to allocate the skb a null skb is passed
> to t4_set_arp_err_handler and this ends up dereferencing the null skb.
> Avoid the null pointer dereference by checking for a null skb and
> returning early.
>=20
> Addresses-Coverity: ("Dereference null return")
> Fixes: b38a0ad8ec11 ("RDMA/cxgb4: Set arp error handler for PASS_ACCEPT_R=
PL messages")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Potnuri Bharat Teja <bharat@chelsio.com>
> ---
>  drivers/infiniband/hw/cxgb4/cm.c | 2 ++
>  1 file changed, 2 insertions(+)

Applied to for-next

Thanks,
Jason
