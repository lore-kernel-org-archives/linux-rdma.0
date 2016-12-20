From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] Add Connect-X5 device ID to device white
 lists
Date: Tue, 20 Dec 2016 13:05:33 -0500
Message-ID: <4d929998-946a-4d01-3fff-8a051cf23b7e@dev.mellanox.co.il>
References: <cb54fa49-84fb-3d2f-6431-e6b513b6fb46@dev.mellanox.co.il>
 <20161220165728.GC29564@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161220165728.GC29564-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/20/2016 11:57 AM, ira.weiny wrote:
> On Mon, Dec 19, 2016 at 04:24:34PM -0500, Hal Rosenstock wrote:
>>
>> Connect-X5 is device ID 0x1017
>>
>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> After the patch from Vincent I had to apply this by hand.
> 
> So basically applied.
> 
> But after I push all this could you double check that this is ok?

It looks fine to me.

Thanks!

-- Hal

> Thanks,
> Ira
> 
> 
>> ---
>>  libibnetdisc/src/ibnetdisc.c | 2 +-
>>  src/ibdiag_common.c          | 2 +-
>>  src/vendstat.c               | 2 +-
>>  3 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/libibnetdisc/src/ibnetdisc.c b/libibnetdisc/src/ibnetdisc.c
>> index 7ba5c91..57fc33e 100644
>> --- a/libibnetdisc/src/ibnetdisc.c
>> +++ b/libibnetdisc/src/ibnetdisc.c
>> @@ -199,7 +199,7 @@ static int is_mlnx_ext_port_info_supported(ibnd_port_t * port)
>>  
>>  	if ((devid >= 0xc738 && devid <= 0xc73b) || devid == 0xcb20 || devid == 0xcf08 || devid == 0x1b02)
>>  		return 1;
>> -	if (devid >= 0x1003 && devid <= 0x1016)
>> +	if (devid >= 0x1003 && devid <= 0x1017)
>>  		return 1;
>>  	return 0;
>>  }
>> diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
>> index f74eed4..981f82d 100644
>> --- a/src/ibdiag_common.c
>> +++ b/src/ibdiag_common.c
>> @@ -532,7 +532,7 @@ int is_mlnx_ext_port_info_supported(uint32_t devid)
>>  	if (ibd_ibnetdisc_flags & IBND_CONFIG_MLX_EPI) {
>>  		if ((devid >= 0xc738 && devid <= 0xc73b) || devid == 0xcb20 || devid == 0xcf08 || devid == 0x1b02)
>>  			return 1;
>> -		if (devid >= 0x1003 && devid <= 0x1016)
>> +		if (devid >= 0x1003 && devid <= 0x1017)
>>  			return 1;
>>  	}
>>  	return 0;
>> diff --git a/src/vendstat.c b/src/vendstat.c
>> index 284ef93..7f88bf3 100644
>> --- a/src/vendstat.c
>> +++ b/src/vendstat.c
>> @@ -148,7 +148,7 @@ static uint16_t ext_fw_info_device[][2] = {
>>  	{0xcb20, 0xcb20},	/* Switch-IB */
>>  	{0xcf08, 0xcf08},	/* Switch-IB2 */
>>  	{0x01b3, 0x01b3},	/* IS-4 */
>> -	{0x1003, 0x1016},	/* Connect-X */
>> +	{0x1003, 0x1017},	/* Connect-X */
>>  	{0x1b02, 0x1b02},	/* Bull */
>>  	{0x0000, 0x0000}};
>>  
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
