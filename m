From: "Justin P. Mattock" <justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 6/9]drivers:char:nvram.c Change the copyright info.
Date: Fri, 08 Jul 2011 11:54:07 -0700
Message-ID: <4E17524F.3020000@gmail.com>
References: <1290838879-11038-1-git-send-email-justinmattock@gmail.com> <1290838879-11038-7-git-send-email-justinmattock@gmail.com> <alpine.LNX.2.00.1107081832490.11049@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LNX.2.00.1107081832490.11049-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07/08/2011 09:33 AM, Jiri Kosina wrote:
> On Fri, 26 Nov 2010, Justin P. Mattock wrote:
>
>> Change the copyright info from Sun Microsystems to Oracle since Oracle now owns them.
>>
>> Signed-off-by: Justin P. Mattock<justinmattock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> ---
>>   drivers/char/nvram.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
>> index 166f1e7..33e8faa 100644
>> --- a/drivers/char/nvram.c
>> +++ b/drivers/char/nvram.c
>> @@ -3,7 +3,7 @@
>>    *
>>    * Copyright (C) 1997 Roman Hodek<Roman.Hodek-jNDFPZUTrfT6U6xlzOR6HsSSVFg4/55HhC4ANOJQIlc@public.gmane.org>
>>    * idea by and with help from Richard Jelinek<rj-l3A5Bk7waGM@public.gmane.org>
>> - * Portions copyright (c) 2001,2002 Sun Microsystems (thockin-xsfywfwIY+M@public.gmane.org)
>> + * Portions copyright (c) 2001,2002 Oracle and/or its affiliates. (thockin-xsfywfwIY+M@public.gmane.org)
>>    *
>>    * This driver allows you to access the contents of the non-volatile memory in
>>    * the mc146818rtc.h real-time clock. This chip is built into all PCs and into
>
> You can't just change other people/company copyright.
>
> This will need Signoff from the original copyright holder at least.
>

yeah I think somebody from oracle had already told me this the day I had 
sent these out. from what I remember here is the original thread:
https://lkml.org/lkml/2010/11/27/31

so somebody from oracle needs to claim this, and the rest of the kernel!


Justin P. Mattock
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
