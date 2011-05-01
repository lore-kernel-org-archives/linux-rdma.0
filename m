From: Eli Dorfman <elido-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/vendstat: Fixed general info query
Date: Sun, 01 May 2011 09:28:57 +0300
Message-ID: <4DBCFDA9.4040903@dev.mellanox.co.il>
References: <4DB92ED0.4050907@dev.mellanox.co.il> <4DB97EDA.6030104@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DB97EDA.6030104-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/28/2011 05:51 PM, Hal Rosenstock wrote:
> On 4/28/2011 5:09 AM, Eli Dorfman wrote:
>> Fixed general info query
>>
>> There was no output when query succeeded
> 
> Do you mean failed ?

No I meant succeeded.
Since the IBERROR was missing the print of GeneralInfo is skipped.
If it fails then the "if (general_info)" code is reached but it will print garbage.

Eli

> 
> -- Hal
> 
>>
>> Signed-off-by: Eli Dorfman <elido-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  src/vendstat.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/src/vendstat.c b/src/vendstat.c
>> index 92a90c8..8dbd1ee 100644
>> --- a/src/vendstat.c
>> +++ b/src/vendstat.c
>> @@ -375,6 +375,7 @@ int main(int argc, char **argv)
>>  	gi = (is3_general_info_t *) & buf;
>>  	if (do_vendor(&portid, srcport, IB_MLX_VENDOR_CLASS, IB_MAD_METHOD_GET,
>>  		      IB_MLX_IS3_GENERAL_INFO, 0, gi))
>> +		IBERROR("generalinfo query");
>>  
>>  	if (general_info) {
>>  		/* dump IS3 or IS4 general info here */
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
