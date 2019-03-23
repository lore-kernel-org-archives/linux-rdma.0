From: Kangjie Lu <kjlu@umn.edu>
Subject: Re: [PATCH] infiniband: cxgb4: fix a potential NULL pointer
 dereference
Date: Fri, 22 Mar 2019 21:37:46 -0500
Message-ID: <CC1E06D8-7817-4314-AAD4-434FEB8C4157@umn.edu>
References: <20190309051921.15212-1-kjlu@umn.edu>
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190309051921.15212-1-kjlu@umn.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: kjlu@umn.edu
Cc: pakki001@umn.edu, Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



> On Mar 8, 2019, at 11:19 PM, Kangjie Lu <kjlu@umn.edu> wrote:
>=20
> get_skb may fail and return NULL. The fix returns "ENOMEM"
> when it fails to avoid NULL dereference.
>=20
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
> drivers/infiniband/hw/cxgb4/cm.c | 3 +++
> 1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c =
b/drivers/infiniband/hw/cxgb4/cm.c
> index 8221813219e5..502a54d57e2c 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -1919,6 +1919,9 @@ static int send_fw_act_open_req(struct c4iw_ep =
*ep, unsigned int atid)
> 	int win;
>=20
> 	skb =3D get_skb(NULL, sizeof(*req), GFP_KERNEL);
> +	if (!skb)
> +		return -ENOMEM;
> +

Can someone review this patch? Thanks.

> 	req =3D __skb_put_zero(skb, sizeof(*req));
> 	req->op_compl =3D htonl(WR_OP_V(FW_OFLD_CONNECTION_WR));
> 	req->len16_pkd =3D =
htonl(FW_WR_LEN16_V(DIV_ROUND_UP(sizeof(*req), 16)));
> --=20
> 2.17.1
>=20
