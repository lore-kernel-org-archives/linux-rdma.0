From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_helper.c: fix potential overrun of the array
Date: Sun, 12 Sep 2010 11:47:57 +0200
Message-ID: <4C8CA1CD.4080402@dev.mellanox.co.il>
References: <4C865419.9050005@mellanox.co.il> <20100909143607.GC11502@me>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100909143607.GC11502@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09-Sep-10 5:36 PM, Sasha Khapyorsky wrote:
> On 18:02 Tue 07 Sep     , Yevgeny Kliteynik wrote:
>> Max index of the ib_sm_method_str[] static array
>> is 0x20. Fixing OSM_SM_METHOD_STR_UNKNOWN_VAL to
>> match this value.
>>
>> Signed-off-by: Yevgeny Kliteynik<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>> ---
>>   opensm/opensm/osm_helper.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/opensm/opensm/osm_helper.c b/opensm/opensm/osm_helper.c
>> index 196d5aa..0233e70 100644
>> --- a/opensm/opensm/osm_helper.c
>> +++ b/opensm/opensm/osm_helper.c
>> @@ -148,7 +148,7 @@ static const char *ib_sm_method_str[] = {
>>   	"UNKNOWN"		/* 20 */
>>   };
>>
>> -#define OSM_SM_METHOD_STR_UNKNOWN_VAL 0x21
>> +#define OSM_SM_METHOD_STR_UNKNOWN_VAL 0x20
> 
> BTW, wouldn't it be better to use ARR_SIZE macro for those defines:
> 
> #define OSM_SM_METHOD_STR_UNKNOWN_VAL ARR_SIZE(ib_sm_method_str)

Good idea, with a small fix:

#define OSM_SM_METHOD_STR_UNKNOWN_VAL (ARR_SIZE(ib_sm_method_str) - 1)

-- Yevgeny

 
> , where:
> 
> #define ARR_SIZE(a) (sizeof(a)/sizeof(a[0]))
> 
> ?
> 
> Sasha
> 
>>
>>   static const char *ib_sm_attr_str[] = {
>>   	"RESERVED",		/* 0 */
>> -- 
>> 1.6.2.4
>>
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
