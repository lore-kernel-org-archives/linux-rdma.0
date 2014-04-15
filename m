From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH]  libibmad/src/dump.c : Set the vlaue of LinkWidthActive
 to undefined(width) when the port is down
Date: Tue, 15 Apr 2014 12:54:10 -0400
Message-ID: <534D6432.5000602@dev.mellanox.co.il>
References: <0a2301cf41e2$3ebde380$bc39aa80$@asaltech.com> <20140415094316.f16055aaa70c239bd8fe7159@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140415094316.f16055aaa70c239bd8fe7159-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ammar Haj Hamad <ahamad-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rafiw-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/15/2014 12:43 PM, Ira Weiny wrote:
> Ammar,
> 
> This patch does not apply cleanly.
> 
> 09:41:21 > git am ../\[PATCH\]__libibmad_src_dump.c___Set_the_vlaue_of__LinkWidthActive_to_undefined\(width\)_when_the_port_is_down.eml 
> Applying: libibmad/src/dump.c : Set the vlaue of LinkWidthActive to undefined(width) when the port is down
> fatal: patch fragment without header at line 18: @@ -171,6 +171,9 @@ void mad_dump_linkwidth(char *buf, int bufsz, void *val,
> Patch failed at 0001 libibmad/src/dump.c : Set the vlaue of LinkWidthActive to undefined(width) when the port is down
> 
> 
> Also I don't think it showed up on linux-rdma.
> 
> Could you make sure to send as plain text.  That could be why linux-rdma dropped it and I missed it.
> 
> Thanks,
> Ira
> 
> 
> On Mon, 17 Mar 2014 15:10:10 +0200
> Ammar Haj Hamad <ahamad-DMD6N21cJuFWk0Htik3J/w@public.gmane.org> wrote:
> 
>> This patch is to set the vlaue of LinkWidthActive to undefined({width}) when
>> the port is down
>>
>>  
>>
>> Signed-off-by: Ammar Haj Hamad <ahamad-DMD6N21cJuFWk0Htik3J/w@public.gmane.org>
>>
>> ---
>>
>> src/dump.c |    3 +++
>>
>> 1 files changed, 3 insertions(+), 0 deletions(-)
>>
>>  
>>
>> diff --git a/src/dump.c b/src/dump.c
>>
>> index f77d739..4bc8153 100644
>>
>> --- a/src/dump.c
>>
>> +++ b/src/dump.c
>>
>> @@ -171,6 +171,9 @@ void mad_dump_linkwidth(char *buf, int bufsz, void *val,
>> int valsz)
>>
>>                int width = *(int *)val;
>>
>>                 switch (width) {
>>
>> +             case 0: 
>>
>> +                             snprintf(buf , bufsz , "undefined (%d)",
>> width);
>>
>> +                             break;

Why special case width 0 and not handle this in default case as is
currently done in mad_dump_linkspeed ?

-- Hal

>>
>>                case 1:
>>
>>                                snprintf(buf, bufsz, "1X");
>>
>>                                break;
>>
>> -- 
>>
>> 1.7.1
>>
>>  
>>
>>  
>>
>>  
>>
>>  
>>
>>   _____  
>>
>> Ammar Omar Haj Hamad |    Software Engineer           |   ASAL technologies
>> - Mellanox
>>
>> Mobile : +970599751673  |    ahamad-DMD6N21cJuFWk0Htik3J/w@public.gmane.org   | Skype :
>> ammar.hajhamad.asal
>>
>>  
>>
> 
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
