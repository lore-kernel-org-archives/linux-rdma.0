From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 infiniband-diags] ibdiag_common.c: Disambiguate link
 speed when QDR and could be FDR10
Date: Tue, 20 Dec 2016 07:31:59 -0500
Message-ID: <b29d8763-94c5-2a7a-2e5f-31f707507152@dev.mellanox.co.il>
References: <094d3fd9-a478-ce30-b2de-8983c783c411@dev.mellanox.co.il>
 <20161220104149.GC7351@yuval-lap.uk.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161220104149.GC7351-Hxa29pjIrETlQW142y8m19+IiqhCXseY@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/20/2016 5:41 AM, Yuval Shaia wrote:
> On Mon, Dec 19, 2016 at 05:25:11PM -0500, Hal Rosenstock wrote:
>>
>> Rather than printing "Could be FDR10", print
>> "Could be FDR10 (Found link at QDR but expected speed is FDR10)"
>> for this case.
>>
>> Confusion is with words "Could be" and fact that both
>> QDR and FDR10 are both 10.0 Gbps.
>>
>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>> Change since v1:
>> Preserved original "Could be FDR10" so can grep for "Could be"
>> along with adding new language.
>>
>>  src/ibdiag_common.c | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
>> index f74eed4..ad8551f 100644
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
>> +				 "Could be FDR10 (Found link at QDR but expected speed is FDR10)");
>> +		else
>> +			snprintf(speed_msg, msg_size, "Could be FDR10");
>> +	}
> 
> Since there is no "formatting" here can you take advantage with this change
> and consider using strncpy instead of snprintf?


This patch was merely changing the messages.

Sure; strncpy rather than snprintf could be used in these cases. That
could be done in a separate patch which would change all such
occurrences and not just here.

>>  }
>>  
>>  int vsnprint_field(char *buf, size_t n, enum MAD_FIELDS f, int spacing,
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
