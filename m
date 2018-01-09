From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/8] infiniband: fix ulp/opa_vnic/opa_vnic_encap.h
 kernel-doc for Sphinx
Date: Tue, 9 Jan 2018 08:46:49 -0500
Message-ID: <719e4232-3802-b2ab-99d5-2c4ba45bfd40@intel.com>
References: <5a50168d.4a9b620a.2c596.4dfd@mx.google.com>
 <c7e46f04-ac60-448f-3e5d-e23fe7221c9a@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c7e46f04-ac60-448f-3e5d-e23fe7221c9a-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Randy Dunlap <rd.dunlab-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/5/2018 7:38 PM, Bart Van Assche wrote:
> On 01/05/18 16:21, Randy Dunlap wrote:
>> Use '\' escape characters in kernel-doc notation to eliminate a warning
>> from Sphinx.
>>
>> ../drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h:243: WARNING: 
>> Inline strong start-string without end-string.
>>
>> Signed-off-by: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> ---
>>   drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> --- 
>> linux-next-20171222.orig/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h
>> +++ linux-next-20171222/drivers/infiniband/ulp/opa_vnic/opa_vnic_encap.h
>> @@ -239,7 +239,7 @@ struct opa_veswport_mactable_entry {
>>    * @offset: mac table starting offset
>>    * @num_entries: Number of entries to get or set
>>    * @mac_tbl_digest: mac table digest
>> - * @tbl_entries[]: Array of table entries
>> + * @tbl_entries\[\]: Array of table entries
>>    *
>>    * The EM sends down this structure in a MAD indicating
>>    * the starting offset in the forwarding table that this
> 
> Wouldn't it be better to fix the toolchain such that it escapes Sphinx 
> metacharacters in kernel-doc headers instead of modifying the source 
> code with patches like the above one?

I tend to agree with Bart here.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
