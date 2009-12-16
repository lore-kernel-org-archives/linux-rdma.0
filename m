From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_vl15intf.c Log change
Date: Wed, 16 Dec 2009 11:36:58 +0200
Message-ID: <4B28AA3A.8090700@dev.mellanox.co.il>
References: <4B0FD804.2020309@Sun.COM> <f0e08f230912150812r8fa3a89kf62aa2412e8b824@mail.gmail.com>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f0e08f230912150812r8fa3a89kf62aa2412e8b824-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Line Holen <Line.Holen-xsfywfwIY+M@public.gmane.org>, sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 15/Dec/09 18:12, Hal Rosenstock wrote:
> On Fri, Nov 27, 2009 at 8:45 AM, Line Holen<Line.Holen-xsfywfwIY+M@public.gmane.org>  wrote:
>> Added transaction ID to a message
>>
>> Signed-off-by: Line Holen<Line.Holen-xsfywfwIY+M@public.gmane.org>
>>
>> ---
>>
>> diff --git a/opensm/opensm/osm_vl15intf.c b/opensm/opensm/osm_vl15intf.c
>> index c380a55..cc3ff33 100644
>> --- a/opensm/opensm/osm_vl15intf.c
>> +++ b/opensm/opensm/osm_vl15intf.c
>> @@ -1,4 +1,5 @@
>>   /*
>> + * Copyright (c) 2009 Sun Microsystems, Inc. All rights reserved.
>>   * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
>>   * Copyright (c) 2002-2006 Mellanox Technologies LTD. All rights reserved.
>>   * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
>> @@ -91,7 +92,8 @@ static void vl15_send_mad(osm_vl15_t * p_vl, osm_madw_t * p_madw)
>>         }
>>
>>         OSM_LOG(p_vl->p_log, OSM_LOG_ERROR, "ERR 3E03: "
>> -               "MAD send failed (%s)\n", ib_get_err_str(status));
>> +               "MAD send failed (%s), TID 0x%" PRIx64 "\n",
>> +               ib_get_err_str(status), cl_ntoh64(p_madw->p_mad->trans_id));
>
> I don't think it's safe to touch the MAD once it's been returned to
> the pool. So either this change needs to be reverted or the
> transaction ID (and any other info to be printed on error) saved and
> logged on error.

I'm actually seeing OSM crashing on this line
pretty reliably. For now I've issued a revert
patch.

-- Yevgeny

> -- Hal
>
>>
>>         /*
>>            The MAD was never successfully sent, so
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
