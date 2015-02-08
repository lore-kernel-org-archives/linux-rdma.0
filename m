From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 2/2] iser-target: Remove duplicate function names
Date: Sun, 08 Feb 2015 21:03:04 +0200
Message-ID: <54D7B2E8.8060000@dev.mellanox.co.il>
References: <1423181345-18449-1-git-send-email-linux@rasmusvillemoes.dk>	 <1423181345-18449-2-git-send-email-linux@rasmusvillemoes.dk> <1423248545.9544.1.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1423248545.9544.1.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Sagi Grimberg <sagig@mellanox.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 2/6/2015 8:49 PM, Nicholas A. Bellinger wrote:
> On Fri, 2015-02-06 at 01:09 +0100, Rasmus Villemoes wrote:
>> The macro isert_dbg already ensures that __func__ is part of the
>> output, so there's no reason to duplicate the function name in the
>> format string itself.
>>
>> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>> ---
>>   drivers/infiniband/ulp/isert/ib_isert.c | 7 +++----
>>   1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
>> index dafb3c531f96..20097de9ac45 100644
>> --- a/drivers/infiniband/ulp/isert/ib_isert.c
>> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
>> @@ -949,7 +949,7 @@ isert_post_recv(struct isert_conn *isert_conn, u32 count)
>>   		isert_err("ib_post_recv() failed with ret: %d\n", ret);
>>   		isert_conn->post_recv_buf_count -= count;
>>   	} else {
>> -		isert_dbg("isert_post_recv(): Posted %d RX buffers\n", count);
>> +		isert_dbg("Posted %d RX buffers\n", count);
>>   		isert_conn->conn_rx_desc_head = rx_head;
>>   	}
>>   	return ret;
>> @@ -1709,8 +1709,7 @@ isert_put_cmd(struct isert_cmd *isert_cmd, bool comp_err)
>>   		 * associated cmd->se_cmd needs to be released.
>>   		 */
>>   		if (cmd->se_cmd.se_tfo != NULL) {
>> -			isert_dbg("Calling transport_generic_free_cmd from"
>> -				 " isert_put_cmd for 0x%02x\n",
>> +			isert_dbg("Calling transport_generic_free_cmd for 0x%02x\n",
>>   				 cmd->iscsi_opcode);
>>   			transport_generic_free_cmd(&cmd->se_cmd, 0);
>>   			break;
>> @@ -3136,7 +3135,7 @@ accept_wait:
>>   	spin_lock_bh(&np->np_thread_lock);
>>   	if (np->np_thread_state >= ISCSI_NP_THREAD_RESET) {
>>   		spin_unlock_bh(&np->np_thread_lock);
>> -		isert_dbg("np_thread_state %d for isert_accept_np\n",
>> +		isert_dbg("np_thread_state %d\n",
>>   			 np->np_thread_state);
>>   		/**
>>   		 * No point in stalling here when np_thread
>
> Applied to target-pending/for-next.
>
> Thanks Rasmus!

You can add my ack if you want:

Acked-by: Sagi Grimberg <sagig@mellanox.com>

Sagi.
