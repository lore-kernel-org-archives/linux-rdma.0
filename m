From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv2 infiniband-diags] smpdump.c: Print number of bytes
 returned by umad_recv
Date: Thu, 8 Feb 2018 07:31:58 -0500
Message-ID: <b28d72b9-7520-c295-bb6e-a5f8cb6101c3@dev.mellanox.co.il>
References: <c0e1648e-06cc-9c79-05f7-4fc06dd3617a@dev.mellanox.co.il>
 <20180208062039.GA16888@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180208062039.GA16888-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/8/2018 1:20 AM, ira.weiny wrote:
> On Wed, Feb 07, 2018 at 12:05:40PM -0500, Hal Rosenstock wrote:
>>
>> when debug is set
>>
>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>> Change from v1:
>> Only print when debug is set
>>
>>  src/smpdump.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/src/smpdump.c b/src/smpdump.c
>> index bc8559a..efc522f 100644
>> --- a/src/smpdump.c
>> +++ b/src/smpdump.c
>> @@ -281,6 +281,9 @@ int main(int argc, char *argv[])
>>  	if (umad_recv(portid, umad, &length, -1) != mad_agent)
>>  		IBPANIC("recv error: %s", strerror(errno));
>>  
>> +	if (ibdebug)
>> +		fprintf(stdout, "%d bytes received\n", length);
> 
> To match the other debug output I changed this to stderr.

debug output also uses stdout (see DEBUG or IBDEBUG macros).

Anyhow, stderr is fine for this.

> Applied thanks,

Thanks.

-- Hal

> Ira
> 
>> +
>>  	if (!dump_char) {
>>  		xdump(stdout, 0, smp->data, 64);
>>  		if (smp->status)
>> -- 
>> 2.8.4
>>
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
