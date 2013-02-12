From: Sarat Kakarla <sarat.kakarla-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] libibmad: Add  ib_resolve_noderecord_via  API
Date: Tue, 12 Feb 2013 15:03:46 -0800
Message-ID: <511ACA52.4060104@oracle.com>
References: <511AA890.8050106@oracle.com> <511AC06B.3030005@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <511AC06B.3030005-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: weiny2-i2BcT+NCU+M@public.gmane.org, HANLIN.QIAN-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, "Jia Shi (E-mail)" <JIA.SHI-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hal,

Thanks for reviewing it. My answers are in-lined with [SK] prefix.

Sarat

On 2/12/2013 2:21 PM, Hal Rosenstock wrote:
> On 2/12/2013 3:39 PM, Sarat Kakarla wrote:
>> Add ib_resolve_noderecord_via wrapper similar to ib_resolve_portid_str_via
>
> Note that this patch depends on a patch previously submitted on 1/31 but
> not yet accepted: "libibmad: Add NodeRecord query API" due to it's use
> of ib_node_query_via below.
>
>> Signed-off-by: Sarat Kakarla <sarat.kakarla-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>
>> --- include/infiniband/mad.h  2009-11-01 16:17:12.000000000 -0800
>> +++ ../libibmad-1.3.3.wrapper/include/infiniband/mad.h  2013-02-07
>> 10:32:05.000000000 -0800
>> @@ -934,6 +934,8 @@
>>       DEPRECATED;
>>   MAD_EXPORT int ib_resolve_self(ib_portid_t * portid, int *portnum,
>>               ibmad_gid_t * gid) DEPRECATED;
>> +MAD_EXPORT int ib_resolve_noderecord_via(char *addr_str,
>> +                                         const struct ibmad_port
>> *srcport);
>>
>>   /* resolve.c new interface */
>>   MAD_EXPORT int ib_resolve_smlid_via(ib_portid_t * sm_id, int timeout,
>> --- src/libibmad.map  2009-10-29 18:18:01.000000000 -0700
>> +++ ../libibmad-1.3.3.wrapper/src/libibmad.map  2013-02-11
>> 10:47:13.000000000 -0800
>> @@ -105,6 +105,7 @@
>>      ib_resolve_gid_via;
>>      ib_resolve_portid_str_via;
>>      ib_resolve_self_via;
>> +    ib_resolve_noderecord_via;
>
> Formatting looks wrong to me here and other places. Is this using spaces
> rather than tabs ?

[SK] By habit I have used spaces I will replace them with the tabs.

>
>>      mad_field_name;
>>      bm_call_via;
>>    local: *;
>> --- src/resolve.c 2009-11-01 16:17:12.000000000 -0800
>> +++ ../libibmad-1.3.3.wrapper/src/resolve.c 2013-02-11
>> 10:46:10.000000000 -0800
>> @@ -226,3 +226,21 @@
>>   {
>>    return ib_resolve_self_via(portid, portnum, gid, ibmp);
>>   }
>> +
>> +int ib_resolve_noderecord_via(char *addr_str, const struct ibmad_port
>> *srcport)
>> +{
>> +   uint64_t    guid;
>> +   ib_portid_t sm_id;
>> +   char        buf[IB_SA_DATA_SIZE] = { 0 };
>> +
>> +   if (!(guid = strtoull(addr_str, 0, 0)))
>> +     return -1;
>> +
>> +   if (ib_resolve_smlid_via(&sm_id, MAD_DEF_TIMEOUT_MS, srcport) < 0)
>
> Should second parameter be timeout rather than MAD_DEF_TIMEOUT_MS ?

[SK] I wanted to make ib_resolve_noderecord_via look like ib_resolve_portid_str_via API which does not take any timeout parameter.
      I can pass '0' instead of MAD_DEF_TIMEOUT_MS, that's what passed as timeout to ib_resolve_guid_via function from  ib_resolve_portid_str_via function.

>
> -- Hal
>
>> +      return -1;
>> +
>> +   return ib_node_query_via(srcport, guid, &sm_id, buf);
>> +}
>> +
>> +
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
