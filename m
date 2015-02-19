From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 08/30] IB/core: Support find sgid index using a filter
 function
Date: Thu, 19 Feb 2015 14:48:27 +0200
Message-ID: <54E5DB9B.9010103@mellanox.com>
References: <1424383365-19337-1-git-send-email-somnath.kotur@emulex.com>
 <3f9746be-8d95-429c-945e-59b0b90a17e8@CMEXHTCAS2.ad.emulex.com>
 <54E5DA0D.4020002@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54E5DA0D.4020002-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2/19/2015 2:41 PM, Haggai Eran wrote:
> On 20/02/2015 00:02, Somnath Kotur wrote:
>> @@ -111,6 +111,33 @@ int ib_find_cached_gid_by_port(struct ib_device *device,
>>   			       struct net	*net,
>>   			       int		if_index,
>>   			       u16              *index);
>> +
>> +/**
>> + * ib_find_cached_gid_by_port - Returns the GID table index where a specified
> You probably meant ib_find_gid_by_filter.

Correct, we'll fix for next version.

>
>> + * GID value occurs
>> + * @device: The device to query.
>> + * @gid: The GID value to search for.
>> + * @port_num: The port number of the device where the GID value could be
>> + *   searched.
>> + * @filter: The filter function is executed on any matching GID in the table.
>> + *   If the filter function returns true, the corresponding index is returned,
>> + *   otherwise, we continue searching the GID table. It's guaranteed that
>> + *   while filter is executed, ndev field is valid and the structure won't
>> + *   change. filter is executed in an atomic context. filter must be NULL
>> + *   when RoCE GID cache isn't supported on the respective device's port.
>> + * @index: The index into the cached GID table where the GID was found.  This
>> + *   parameter may be NULL.
>> + *
>> + * ib_find_cached_gid_by_port() searches for the specified GID value in
> Here too.

Thanks,
Matan

>
>> + * the local software cache.
>> + */
>> +int ib_find_gid_by_filter(struct ib_device *device,
>> +			  union ib_gid *gid,
>> +			  u8 port_num,
>> +			  bool (*filter)(const union ib_gid *gid,
>> +					 const struct ib_gid_attr *,
>> +					 void *),
>> +			  void *context, u16 *index);
>>   /**
>>    * ib_get_cached_pkey - Returns a cached PKey table entry
>>    * @device: The device to query.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
