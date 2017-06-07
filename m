From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/3] IB/CM: Create appropriate path records when
 handling CM request
Date: Wed, 7 Jun 2017 10:23:54 -0700
Message-ID: <e1d035ef-f8f8-6ea1-8277-646e01c55bd3@intel.com>
References: <1496686803-51338-1-git-send-email-don.hiatt@intel.com>
 <1496686803-51338-3-git-send-email-don.hiatt@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB140319@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB140319-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 6/5/2017 1:40 PM, Hefty, Sean wrote:
>> +			/*
>> +			 * If the gid in the request is an OPA GID,
>> +			 * create an OPA PR
>> +			 */
>> +			if (ib_is_opa_gid(&req_msg->primary_local_gid) &&
>> +			    rdma_cap_opa_ah(work->port->cm_dev->ib_device,
>> +					    work->port->port_num))
>> +				work->path[0].rec_type = SA_PATH_REC_TYPE_OPA;
>> +			else
>> +				work->path[0].rec_type = SA_PATH_REC_TYPE_IB;
> Maybe create a function for this logic (repeated 3 times)?  E.g. cm_path_rec_type(device, port, gid)
>
Good point. Will do in next revision.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
