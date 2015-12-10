From: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/usnic: Handle 0 counts in resource allocation
Date: Thu, 10 Dec 2015 11:22:24 -0800
Message-ID: <5669D0F0.7010104@cisco.com>
References: <1449686539-29959-6-git-send-email-neescoba@cisco.com>
 <20151210064702.GC8662@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151210064702.GC8662-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-2ukJVAZIZ/Y@public.gmane.org" <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/9/2015 10:47 PM, Leon Romanovsky wrote:
> On Wed, Dec 09, 2015 at 10:42:19AM -0800, Nelson Escobar wrote:
>> -	if (usnic_vnic_res_free_cnt(vnic, type) < cnt || cnt < 1 || !owner)
>> +	if (usnic_vnic_res_free_cnt(vnic, type) < cnt || cnt < 0 || !owner)
> Before this change you returned EINVAL if no free_cnt were available,
> now you will continue. is this behaviour expected?
Yes.  If cnt is 0, then no resources are being requested, so it is OK if
there are no resources available.
> 
>>  		return ERR_PTR(-EINVAL);
>>  
>>  	ret = kzalloc(sizeof(*ret), GFP_ATOMIC);
>> @@ -247,26 +247,28 @@ usnic_vnic_get_resources(struct usnic_vnic *vnic, enum usnic_vnic_res_type type,
>>  		return ERR_PTR(-ENOMEM);
>>  	}
>>  
>> -	ret->res = kzalloc(sizeof(*(ret->res))*cnt, GFP_ATOMIC);
>> -	if (!ret->res) {
>> -		usnic_err("Failed to allocate resources for %s. Out of memory\n",
>> -				usnic_vnic_pci_name(vnic));
>> -		kfree(ret);
>> -		return ERR_PTR(-ENOMEM);
>> -	}
>> +	if (cnt > 0) {
>> +		ret->res = kcalloc(cnt, sizeof(*(ret->res)), GFP_ATOMIC);
>> +		if (!ret->res) {
>> +			usnic_err("Failed to allocate resources for %s. Out of memory\n",
>> +					usnic_vnic_pci_name(vnic));
> You don't need to print OOM messages, failure in memory allocation very hard to miss.
OOM messages are hard to miss, but this message is already in upstream
and outside the scope of this patch.
>> +			kfree(ret);
>> +			return ERR_PTR(-ENOMEM);
>> +		}
>>  
>> -	spin_lock(&vnic->res_lock);
>> -	src = &vnic->chunks[type];
>> -	for (i = 0; i < src->cnt && ret->cnt < cnt; i++) {
>> -		res = src->res[i];
>> -		if (!res->owner) {
>> -			src->free_cnt--;
>> -			res->owner = owner;
>> -			ret->res[ret->cnt++] = res;
>> +		spin_lock(&vnic->res_lock);
>> +		src = &vnic->chunks[type];
>> +		for (i = 0; i < src->cnt && ret->cnt < cnt; i++) {
>> +			res = src->res[i];
>> +			if (!res->owner) {
>> +				src->free_cnt--;
> It will be negative, because of skip usnic_vnic_res_free_cnt check
> before.
We are inside the 'if (cnt > 0)' clause here, so the previous
usnic_vnic_res_free_cnt check wasn't skipped.
>> +				res->owner = owner;
>> +				ret->res[ret->cnt++] = res;
>> +			}
>>  		}
>> -	}
>>  
>> -	spin_unlock(&vnic->res_lock);
>> +		spin_unlock(&vnic->res_lock);
>> +	}
>>  	ret->type = type;
>>  	ret->vnic = vnic;
>>  	WARN_ON(ret->cnt != cnt);
>> @@ -281,14 +283,16 @@ void usnic_vnic_put_resources(struct usnic_vnic_res_chunk *chunk)
>>  	int i;
>>  	struct usnic_vnic *vnic = chunk->vnic;
>>  
>> -	spin_lock(&vnic->res_lock);
>> -	while ((i = --chunk->cnt) >= 0) {
>> -		res = chunk->res[i];
>> -		chunk->res[i] = NULL;
>> -		res->owner = NULL;
>> -		vnic->chunks[res->type].free_cnt++;
>> +	if (chunk->cnt > 0) {
>> +		spin_lock(&vnic->res_lock);
>> +		while ((i = --chunk->cnt) >= 0) {
>> +			res = chunk->res[i];
>> +			chunk->res[i] = NULL;
>> +			res->owner = NULL;
>> +			vnic->chunks[res->type].free_cnt++;
>> +		}
>> +		spin_unlock(&vnic->res_lock);
>>  	}
>> -	spin_unlock(&vnic->res_lock);
>>  
>>  	kfree(chunk->res);
>>  	kfree(chunk);
>> -- 
>> 2.4.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
