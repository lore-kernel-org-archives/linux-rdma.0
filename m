From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] ibsim/Makefile: Add install rpath to linker
Date: Thu, 27 Oct 2016 10:50:15 -0400
Message-ID: <e8a8a194-6f12-84d0-3705-e822dd722436@dev.mellanox.co.il>
References: <1477576531-29723-1-git-send-email-ilyan@dev.mellanox.co.il>
 <20161027143810.GJ3617@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161027143810.GJ3617-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ilya Nelkenbaum <ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/27/2016 10:38 AM, Leon Romanovsky wrote:
> On Thu, Oct 27, 2016 at 04:55:31PM +0300, Ilya Nelkenbaum wrote:
>> From: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> Signed-off-by: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  ibsim/Makefile | 2 ++
>>  1 file changed, 2 insertions(+)
> 
> Against which tree did you base your code?

Upstream ibsim git repo is git://git.openfabrics.org/~halr/ibsim.git
so I assume Ilya's patch is against this repo.

-- Hal

> 
> Thanks.
> 
>>
>> diff --git a/ibsim/Makefile b/ibsim/Makefile
>> index 5d1ac62..ad94651 100644
>> --- a/ibsim/Makefile
>> +++ b/ibsim/Makefile
>> @@ -1,5 +1,7 @@
>>  progs:=ibsim
>>
>> +ibsim_LDFLAGS = "-Wl,-rpath,\$$ORIGIN/../lib"
>> +
>>  -include ../defs.mk
>>
>>  all: $(progs)
>> --
>> 1.8.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
