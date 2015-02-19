From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 10/30] IB/core: Add gid_type to path and rdma_id_private
Date: Thu, 19 Feb 2015 17:53:51 +0200
Message-ID: <54E6070F.1090501@mellanox.com>
References: <1424383365-19337-1-git-send-email-somnath.kotur@emulex.com>
 <0ebef7be-0586-47bf-bcc4-f3ff21ca4f3b@CMEXHTCAS2.ad.emulex.com>
 <54E60695.3050907@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54E60695.3050907-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2/19/2015 5:51 PM, Haggai Eran wrote:
> On 20/02/2015 00:02, Somnath Kotur wrote:
>> @@ -1521,6 +1520,8 @@ static int cm_req_handler(struct cm_work *work)
>>   	struct ib_cm_id *cm_id;
>>   	struct cm_id_private *cm_id_priv, *listen_cm_id_priv;
>>   	struct cm_req_msg *req_msg;
>> +	union ib_gid gid;
>> +	struct ib_gid_attr gid_attr;
>>   	int ret;
>>
>>   	req_msg = (struct cm_req_msg *)work->mad_recv_wc->recv_buf.mad;
>> @@ -1560,11 +1561,19 @@ static int cm_req_handler(struct cm_work *work)
>>   	cm_format_paths_from_req(req_msg, &work->path[0], &work->path[1]);
>>
>>   	memcpy(work->path[0].dmac, cm_id_priv->av.ah_attr.dmac, ETH_ALEN);
>> -	ret = cm_init_av_by_path(&work->path[0], &cm_id_priv->av);
>> +	ret = ib_get_cached_gid(work->port->cm_dev->ib_device,
>> +				work->port->port_num,
>> +				cm_id_priv->av.ah_attr.grh.sgid_index,
>> +				&gid, &gid_attr);
>> +	if (!ret) {
>> +		work->path[0].gid_type = gid_attr.gid_type;
>> +		ret = cm_init_av_by_path(&work->path[0], &cm_id_priv->av);
>> +	}
>>   	if (ret) {
>>   		ib_get_cached_gid(work->port->cm_dev->ib_device,
>>   				  work->port->port_num, 0, &work->path[0].sgid,
>> -				  NULL);
>> +				  &gid_attr);
>> +		work->path[0].gid_type = gid_attr.gid_type;
>>   		ib_send_cm_rej(cm_id, IB_CM_REJ_INVALID_GID,
>>   			       &work->path[0].sgid, sizeof work->path[0].sgid,
>>   			       NULL, 0);
>
> Is there support for alternative path? (Because I don't see a similar
> change for path[1]).
>

No, support was never implemented for path[1]. We filled some attributes 
of path[1] before, but no vendor implemented any support for it (in RoCE 
obviously).
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
