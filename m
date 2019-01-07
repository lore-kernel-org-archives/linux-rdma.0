From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH for-rc] RDMA/vmw_pvrdma: Return the correct opcode when
 creating WR
Date: Mon, 7 Jan 2019 18:59:13 +0000
Message-ID: <20190107185906.GD27929@mellanox.com>
References: <1546887183-1238-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1546887183-1238-1-git-send-email-aditr@vmware.com>
Content-Language: en-US
Content-ID: <5C4701467F680C47B780E75A543C6E58@eurprd05.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: Adit Ranadive <aditr@vmware.com>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Pv-drivers <Pv-drivers@vmware.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 07, 2019 at 06:53:24PM +0000, Adit Ranadive wrote:
> From: Adit Ranadive <aditr@vmware.com>
>=20
> Since the IB_WR_REG_MR opcode value changed, set some of the PVRDMA devic=
e
> opcodes explicitly.
>=20
> Reported-by: Ruishuang Wang <ruishuangw@vmware.com>
> Fixes: 9a59739bd01f ("IB/rxe: Revise the ib_wr_opcode enum")
> Cc: stable@vger.kernel.org
> Reviewed-by: Bryan Tan <bryantan@vmware.com>
> Reviewed-by: Ruishuang Wang <ruishuangw@vmware.com>
> Reviewed-by: Vishnu Dasa <vdasa@vmware.com>
> Signed-off-by: Adit Ranadive <aditr@vmware.com>
> ---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma.h | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)

So naughty!! How many other places in this driver are assuming the
intenal IB constants are stable?

Did you audit for other cases?
=20
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h b/drivers/infiniba=
nd/hw/vmw_pvrdma/pvrdma.h
> index 42b8685c997e..c2ed09e66d2b 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
> @@ -427,7 +427,26 @@ static inline enum ib_qp_state pvrdma_qp_state_to_ib=
(enum pvrdma_qp_state state)
> =20
>  static inline enum pvrdma_wr_opcode ib_wr_opcode_to_pvrdma(enum ib_wr_op=
code op)
>  {
> -	return (enum pvrdma_wr_opcode)op;
> +	switch (op) {
> +	case IB_WR_LSO:
> +		return PVRDMA_WR_LSO;
> +	case IB_WR_SEND_WITH_INV:
> +		return PVRDMA_WR_SEND_WITH_INV;
> +	case IB_WR_RDMA_READ_WITH_INV:
> +		return PVRDMA_WR_RDMA_READ_WITH_INV;
> +	case IB_WR_LOCAL_INV:
> +		return PVRDMA_WR_LOCAL_INV;
> +	case IB_WR_REG_MR:
> +		return PVRDMA_WR_FAST_REG_MR;
> +	case IB_WR_MASKED_ATOMIC_CMP_AND_SWP:
> +		return PVRDMA_WR_MASKED_ATOMIC_CMP_AND_SWP;
> +	case IB_WR_MASKED_ATOMIC_FETCH_AND_ADD:
> +		return PVRDMA_WR_MASKED_ATOMIC_FETCH_AND_ADD;
> +	case IB_WR_REG_SIG_MR:
> +		return PVRDMA_WR_REG_SIG_MR;
> +	default:
> +		return (enum pvrdma_wr_opcode)op;

No default, lets write them all out please.

Jason
