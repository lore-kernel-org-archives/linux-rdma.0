From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V3 01/11] IB/core: Add gid_type to gid attribute
Date: Wed, 23 Dec 2015 17:38:49 +0200
Message-ID: <567AC009.2030106@dev.mellanox.co.il>
References: <1450875417-19262-1-git-send-email-matanb@mellanox.com>
 <1450875417-19262-2-git-send-email-matanb@mellanox.com>
 <20151223134053.GB3599@leon.nu>
 <CAAKD3BBipJ_2vr2=UYnUZhRqFhfp=23i+rG4FRx089cZ=6rTVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAKD3BBipJ_2vr2=UYnUZhRqFhfp=23i+rG4FRx089cZ=6rTVQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, leon-2ukJVAZIZ/Y@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>> +static const char * const gid_type_str[] = {
>>                     ^^ ^^
>> IMHO, The white spaces can be a little bit confusing to understand.
>>
>
> Pay attention to the double const - I think it's more clear that way.

I agree.

>
>>> +     [IB_GID_TYPE_IB]        = "IB/RoCE v1",
>>> +};
>>> +
>>> +const char *ib_cache_gid_type_str(enum ib_gid_type gid_type)
>>> +{
>>> +     if (gid_type < ARRAY_SIZE(gid_type_str) && gid_type_str[gid_type])
>> Why do you need to check second condition?
>
> If we want to leave a gap for an invalid GID type, we could do that.
> Anyway, we could remove this as an incremental future patch if that's
> really important.

Leave it in, better safe than sorry...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
