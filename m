From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 1/3] IB/CM: Add OPA Path record support to CM
Date: Wed, 7 Jun 2017 10:26:59 -0700
Message-ID: <84a4439a-95e7-555c-f635-4d08ce898f6a@intel.com>
References: <1496686803-51338-1-git-send-email-don.hiatt@intel.com>
 <1496686803-51338-2-git-send-email-don.hiatt@intel.com>
 <20170605193357.GA21236@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170605193357.GA21236-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 6/5/2017 12:33 PM, Jason Gunthorpe wrote:
> On Mon, Jun 05, 2017 at 02:20:01PM -0400, Don Hiatt wrote:
>> Add OPA path record support to the Connection Manager.
>>
>> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>   drivers/infiniband/core/cm.c | 50 +++++++++++++++++++++++++++++++++++++-------
>>   include/rdma/opa_addr.h      | 18 ++++++++++++++++
>>   2 files changed, 60 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
>> index 8525d65..f8602e0 100644
>> +++ b/drivers/infiniband/core/cm.c
>> @@ -1175,6 +1175,11 @@ static void cm_format_req(struct cm_req_msg *req_msg,
>>   {
>>   	struct sa_path_rec *pri_path = param->primary_path;
>>   	struct sa_path_rec *alt_path = param->alternate_path;
>> +	bool pri_ext = false;
>> +
>> +	if (pri_path->rec_type == SA_PATH_REC_TYPE_OPA)
>> +		pri_ext = opa_is_extended_lid(pri_path->opa.dlid,
>> +					      pri_path->opa.slid);
>>   
>>   	cm_format_mad_hdr(&req_msg->hdr, CM_REQ_ATTR_ID,
>>   			  cm_form_tid(cm_id_priv, CM_MSG_SEQUENCE_REQ));
>> @@ -1202,18 +1207,24 @@ static void cm_format_req(struct cm_req_msg *req_msg,
>>   		cm_req_set_srq(req_msg, param->srq);
>>   	}
>>   
>> +	req_msg->primary_local_gid = pri_path->sgid;
>> +	req_msg->primary_remote_gid = pri_path->dgid;
>> +	if (pri_ext) {
>> +		req_msg->primary_local_gid.global.interface_id
>> +			= OPA_MAKE_ID(be32_to_cpu(pri_path->opa.slid));
>> +		req_msg->primary_remote_gid.global.interface_id
>> +			=
>> OPA_MAKE_ID(be32_to_cpu(pri_path->opa.dlid));
> Doesn't OPA have a CM format that includes 32 bit lids?
>
> Jason
Since 32bit LIDs can be carried in the OPA GID and all the other fields 
are the same, there is no need to define a new protocol at this time.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
