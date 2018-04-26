From: Yanjun Zhu <yanjun.zhu@oracle.com>
Subject: Re: [PATCH] IB/rxe: add RXE_START_MASK for rxe_opcode
 IB_OPCODE_RC_SEND_ONLY_INV
Date: Thu, 26 Apr 2018 12:02:40 +0800
Message-ID: <f2df9d02-8693-60e6-e4fd-24c81817b898@oracle.com>
References: <1524714759-14654-1-git-send-email-jianchao.w.wang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1524714759-14654-1-git-send-email-jianchao.w.wang@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jianchao Wang <jianchao.w.wang@oracle.com>, monis@mellanox.com, dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 2018/4/26 11:52, Jianchao Wang wrote:
> w/o RXE_START_MASK, the last_psn of IB_OPCODE_RC_SEND_ONLY_INV
> will not be updated in update_wqe_psn, and the corresponding
> wqe will not be acked in rxe_completer due to its last_psn is
> zero. Finally, the other wqe will also not be able to be acked,
> because the wqe of IB_OPCODE_RC_SEND_ONLY_INV with last_psn 0
> is still there. This causes large amount of io timeout when
> nvmeof is over rxe.
>
> Add RXE_START_MASK for IB_OPCODE_RC_SEND_ONLY_INV to fix this.
>
> Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>

Reviewed-by: Zhu Yanjun <yanjun.zhu@oracle.com>

> ---
>   drivers/infiniband/sw/rxe/rxe_opcode.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_opcode.c b/drivers/infiniband/sw/rxe/rxe_opcode.c
> index 61927c1..4cf1106 100644
> --- a/drivers/infiniband/sw/rxe/rxe_opcode.c
> +++ b/drivers/infiniband/sw/rxe/rxe_opcode.c
> @@ -390,7 +390,7 @@ struct rxe_opcode_info rxe_opcode[RXE_NUM_OPCODE] = {
>   		.name	= "IB_OPCODE_RC_SEND_ONLY_INV",
>   		.mask	= RXE_IETH_MASK | RXE_PAYLOAD_MASK | RXE_REQ_MASK
>   				| RXE_COMP_MASK | RXE_RWR_MASK | RXE_SEND_MASK
> -				| RXE_END_MASK,
> +				| RXE_END_MASK  | RXE_START_MASK,
>   		.length = RXE_BTH_BYTES + RXE_IETH_BYTES,
>   		.offset = {
>   			[RXE_BTH]	= 0,
