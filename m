From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] ibdiag_common.c: Disambiguate link speed
 when QDR and could be FDR10
Date: Thu, 8 Dec 2016 11:19:00 -0500
Message-ID: <93e3fb9c-43ff-640c-39a8-12d973663ccc@dev.mellanox.co.il>
References: <99b0d971-af69-1ad3-454f-6b6e4f47c892@dev.mellanox.co.il>
 <20161208161024.GE24724@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208161024.GE24724-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/8/2016 11:10 AM, ira.weiny wrote:
> On Wed, Nov 23, 2016 at 11:47:59AM -0500, Hal Rosenstock wrote:
>> Rather than printing "Could be FDR10", print
>> "Found link at QDR but expected speed is FDR10" for this case.
>>
>> Confusion is with words "Could be" since both
>> QDR and FDR10 are both 10.0 Gbps.
> 
> I'm not sure that I like this change.  I understand that the "speed" may be the
> same but generally FDR10 was supposed to be "better".

FDR10 is better than QDR.

> For all the other speed
> checks the string is "Could be" and I know I have used that to grep for any
> links which are not at "maximum" (Or "best supported") speed.

I was trying to minimize the change rather than changing every
occurrence of "Could be"

> For this reason, I don't think it is going to generally be good for customers.
> 
> Was there a particular reason you needed to change this?

Customer complaint that wording was confusing to them and proposed
wording was acceptable to eliminate their confusion with this.

Where do we go from here ?

-- Hal

> Ira
> 
> 
>>
>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  src/ibdiag_common.c | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
>> index 2a1e971..fa9a294 100644
>> --- a/src/ibdiag_common.c
>> +++ b/src/ibdiag_common.c
>> @@ -814,8 +814,14 @@ check_ext_speed:
>>  
>>  check_fdr10_active:
>>  	if ((mad_get_field(port->ext_info, 0,
>> -			   IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F) & FDR10) == 0)
>> -		snprintf(speed_msg, msg_size, "Could be FDR10");
>> +			   IB_MLNX_EXT_PORT_LINK_SPEED_ACTIVE_F) & FDR10) == 0) {
>> +		/* Special case QDR to try to avoid confusion with FDR10 */
>> +		if (mad_get_field(port->info, 0, IB_PORT_LINK_SPEED_ACTIVE_F) == 4)
>> +			snprintf(speed_msg, msg_size,
>> +				 "Found link at QDR but expected speed is FDR10");
>> +		else
>> +			snprintf(speed_msg, msg_size, "Could be FDR10");
>> +	}
>>  }
>>  
>>  int vsnprint_field(char *buf, size_t n, enum MAD_FIELDS f, int spacing,
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
