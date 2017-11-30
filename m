From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 4/6] IB/CM: Change sgid to IB GID when handling
 CM request
Date: Thu, 30 Nov 2017 15:39:57 -0800
Message-ID: <3d9177ff-b546-15aa-b237-e776e82dac1d@intel.com>
References: <20171114122859.10579.79788.stgit@scvm10.sc.intel.com>
 <20171114123436.10579.95655.stgit@scvm10.sc.intel.com>
 <VI1PR0502MB3008698B4478B2973FE1FA27D1280@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB3008698B4478B2973FE1FA27D1280-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Parav,

On 11/14/2017 10:50 AM, Parav Pandit wrote:
> Hi Dennis,
>
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Dennis Dalessandro
>> Sent: Tuesday, November 14, 2017 6:35 AM
>> To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Ira Weiny
>> <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Subject: [PATCH for-next 4/6] IB/CM: Change sgid to IB GID when handling CM
>> request
>>
>> From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> ULPs do not understand OPA GIDs and will reject CM requests if the sgid does
>> not match the local_gid. In order to fix this behavior we convert the OPA GID
>> back to an IB GID.
>>
>> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> ---
>>   drivers/infiniband/core/cm.c |   38
>> ++++++++++++++++++++++++++++++++++++--
>>   1 files changed, 36 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c index
>> 5927ee4..f9f6f5e 100644
>> --- a/drivers/infiniband/core/cm.c
>> +++ b/drivers/infiniband/core/cm.c
>> @@ -1560,6 +1560,37 @@ static u16 cm_get_bth_pkey(struct cm_work *work)
>>   	return pkey;
>>   }
>>
>> +/**
>> + * Convert OPA SGID to IB SGID
>> + * ULPs (such as IPoIB) do not understand OPA GIDs and will
>> + * reject them as the local_gid will not match the sgid. Therefore,
>> + * change the pathrec's SGID to an IB SGID.
>> + *
> Address and other conversions are in ib_sa.h such as path_conv_opa_to_ib().
> Do path_conv_opa_to_ib function also need such opa to ib gid conversion?
> Can you place cm_opa_to_ib_sgid function in core/addr.c as it deals with addresses.
Since this function is only used by the CM (and is only necessary 
because the responder is not performing a path record query itself, 
while the requester has already done query for us) there is no point in 
moving it to core/addr.c. Further, if we do move the function there, we 
will have to include all the required include files (pathrec, wc, helper 
functions) . Given the limited applicability of this function I prefer 
to keep it as a static function as it is.
> While replying back to CM request, is it ok to reply back with IB GID and reverse conversion not needed or it replies with OPA GID?

Yes, it is okay to reply back with an IB GID and we do not need the 
reverse conversion (effectively they are the same thing as the requester 
in this case has already done a pathrec query and does nothing with the 
reply, and, even if it does the requester already has the IB gid and 
will know how to resolve it).
>> + * @work: Work completion
>> + * @path: Path record
>> + */
>> +static void cm_opa_to_ib_sgid(struct cm_work *work,
>> +			      struct sa_path_rec *path)
>> +{
>> +	struct ib_device *dev = work->port->cm_dev->ib_device;
>> +	struct ib_gid_attr gid_attr;
>> +	u8 port_num = work->port->port_num;
>> +
>> +	if (rdma_cap_opa_ah(dev, port_num) &&
>> +	    (ib_is_opa_gid(&path->sgid))) {
>> +		union ib_gid sgid;
>> +
>> +		if (ib_get_cached_gid(dev, port_num, 0,
> Only gid 0 needs conversion?
Yes,  because gid 1 is the OPA gid (per the OPA spec there is only one 
gid per port so gid 1
is a caching point for the opa gid).
>> +				      &sgid, &gid_attr)) {
> Since gid attribute is not used here and applicable to RoCE and its optional, can you pass NULL and avoid gid_attr?
Will do.
>> +			dev_warn(&dev->dev,
>> +				 "Error updating sgid in CM request\n");
>> +			return;
>> +		}
>> +
>> +		path->sgid = sgid;
>> +	}
>> +}
>> +
>>   static void cm_format_req_event(struct cm_work *work,
>>   				struct cm_id_private *cm_id_priv,
>>   				struct ib_cm_id *listen_id)
>> @@ -1573,10 +1604,13 @@ static void cm_format_req_event(struct cm_work
>> *work,
>>   	param->bth_pkey = cm_get_bth_pkey(work);
>>   	param->port = cm_id_priv->av.port->port_num;
>>   	param->primary_path = &work->path[0];
>> -	if (req_msg->alt_local_lid)
>> +	cm_opa_to_ib_sgid(work, param->primary_path);
>> +	if (cm_req_has_alt_path(req_msg)) {
>>   		param->alternate_path = &work->path[1];
>> -	else
>> +		cm_opa_to_ib_sgid(work, param->alternate_path);
>> +	} else {
>>   		param->alternate_path = NULL;
>> +	}
>>   	param->remote_ca_guid = req_msg->local_ca_guid;
>>   	param->remote_qkey = be32_to_cpu(req_msg->local_qkey);
>>   	param->remote_qpn = be32_to_cpu(cm_req_get_local_qpn(req_msg));
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body
>> of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
