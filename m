From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v2 12/12] IB/isert: Support T10-PI protected transactions
Date: Thu, 13 Mar 2014 21:14:28 +0200
Message-ID: <53220394.7080805@dev.mellanox.co.il>
References: <1392825025-29943-1-git-send-email-sagig@mellanox.com>	 <1392825025-29943-13-git-send-email-sagig@mellanox.com>	 <1394734546.19265.2.camel@haakon3.risingtidesystems.com>	 <5321FFAE.5050105@dev.mellanox.co.il> <1394737184.19265.7.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1394737184.19265.7.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Sagi Grimberg <sagig@mellanox.com>, target-devel@vger.kernel.org, roland@kernel.org, linux-rdma@vger.kernel.org, oren@mellanox.com, martin.petersen@oracle.com
List-Id: linux-rdma@vger.kernel.org

On 3/13/2014 8:59 PM, Nicholas A. Bellinger wrote:
> On Thu, 2014-03-13 at 20:57 +0200, Sagi Grimberg wrote:
>> On 3/13/2014 8:15 PM, Nicholas A. Bellinger wrote:
>>> Hey Sagi,
>>>
>>> On Wed, 2014-02-19 at 17:50 +0200, Sagi Grimberg wrote:
>>>> In case the Target core passed transport T10 protection
>>>> operation:
>>>>
>>>> 1. Register data buffer (data memory region)
>>>> 2. Register protection buffer if exsists (prot memory region)
>>>> 3. Register signature region (signature memory region)
>>>>      - use work request IB_WR_REG_SIG_MR
>>>> 4. Execute RDMA
>>>> 5. Upon RDMA completion check the signature status
>>>>      - if succeeded send good SCSI response
>>>>      - if failed send SCSI bad response with appropriate sense buffer
>>>>
>>>> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
>>>> ---
>>>>    drivers/infiniband/ulp/isert/ib_isert.c |  321 ++++++++++++++++++++++++++++---
>>>>    drivers/infiniband/ulp/isert/ib_isert.h |    1 +
>>>>    2 files changed, 292 insertions(+), 30 deletions(-)
>>>>
>>>> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
>>>> index 3871ab2..04bdd79 100644
>>>> --- a/drivers/infiniband/ulp/isert/ib_isert.c
>>>> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
>>> <SNIP>
>>>
>>>> @@ -2454,26 +2708,33 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
>>>>    		return rc;
>>>>    	}
>>>>    
>>>> -	/*
>>>> -	 * Build isert_conn->tx_desc for iSCSI response PDU and attach
>>>> -	 */
>>>> -	isert_create_send_desc(isert_conn, isert_cmd, &isert_cmd->tx_desc);
>>>> -	iscsit_build_rsp_pdu(cmd, conn, true, (struct iscsi_scsi_rsp *)
>>>> -			     &isert_cmd->tx_desc.iscsi_header);
>>>> -	isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
>>>> -	isert_init_send_wr(isert_conn, isert_cmd,
>>>> -			   &isert_cmd->tx_desc.send_wr, true);
>>>> +	if (se_cmd->prot_type == TARGET_PROT_NORMAL) {
>>>> +		/*
>>>> +		 * Build isert_conn->tx_desc for iSCSI response PDU and attach
>>>> +		 */
>>>> +		isert_create_send_desc(isert_conn, isert_cmd,
>>>> +				       &isert_cmd->tx_desc);
>>>> +		iscsit_build_rsp_pdu(cmd, conn, false, (struct iscsi_scsi_rsp *)
>>>> +				     &isert_cmd->tx_desc.iscsi_header);
>>>> +		isert_init_tx_hdrs(isert_conn, &isert_cmd->tx_desc);
>>>> +		isert_init_send_wr(isert_conn, isert_cmd,
>>>> +				   &isert_cmd->tx_desc.send_wr, true);
>>>> +		isert_cmd->rdma_wr.s_send_wr.next = &isert_cmd->tx_desc.send_wr;
>>>> +	}
>>>>    
>>> So I'm fixing up some v3.14-rc6 context changes before applying this
>>> series to for-next, and noticed something above..
>>>
>>> Namely, that iscsi_build_rsp_pdu() has been changed to pass 'false' as
>>> it's second argument vs. the original case passing 'true'.  This boolean
>>> controls the incrementing of the StatSN in the traditional response
>>> header, which AFAICT should still be 'true' for this case.
>>>
>>> Is there a reason why this was changed..?
>> Well, it wrong... This probably was left around when I rebased to 3.14
>> (earlier versions incremented StatSN explicitly).
>> I wonder how that works though...
>>
>> Want me to fix and resend?
>>
> Nah, fixing this in for-next now.
>
> --nab
>

Thanks,

I just spotted something strange, I think it was already fixed sometime:

-	if (se_cmd->prot_type == TARGET_PROT_NORMAL) {

+	if (se_cmd->prot_op == TARGET_PROT_NORMAL) {

This is strange that I find a mismatch in our trees.
I'll check it out on Sunday.

Sagi.
