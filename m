From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH infiniband-diags 2/2] smpdump.c: Print number of bytes
 returned by umad_recv
Date: Wed, 7 Feb 2018 06:46:10 -0500
Message-ID: <1e5e2f67-1492-cf1d-b9e7-1867b142c4ed@dev.mellanox.co.il>
References: <499f1d77-7da6-2c00-e826-bf4d0809f48a@dev.mellanox.co.il>
 <20180207053515.GC25132@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180207053515.GC25132-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/7/2018 12:35 AM, ira.weiny wrote:
> On Mon, Dec 11, 2017 at 09:57:23AM -0500, Hal Rosenstock wrote:
>>
>> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  src/smpdump.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/src/smpdump.c b/src/smpdump.c
>> index bc8559a..bb304d4 100644
>> --- a/src/smpdump.c
>> +++ b/src/smpdump.c
>> @@ -281,6 +281,8 @@ int main(int argc, char *argv[])
>>  	if (umad_recv(portid, umad, &length, -1) != mad_agent)
>>  		IBPANIC("recv error: %s", strerror(errno));
>>  
>> +	printf("%d bytes received\n", length);
> 
> This seems like it is more for debugging.

I don't recall now what the case was exactly where umad_recv succeeded
but it was unclear whether the data was valid or not. In that sense,
it's a missing part of the current information returned.

I think this command geared at manual debug of attribute IDs not
supported in smpquery.

> How will this affect any scripts which include this command?  

AFAIK there are no such scripts.

> Should we make this debug output?

That's probably better/safer and at least provides a way to obtain the
proposed added information.

Do you want an updated patch for this ?

-- Hal

> Ira
> 
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
