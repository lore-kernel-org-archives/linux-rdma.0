From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_ucast_cache.c: Cosmetic change to log message
 for consistency
Date: Sun, 18 Oct 2009 09:29:10 +0200
Message-ID: <4ADAC3C6.7050905@dev.mellanox.co.il>
References: <20091015133639.GB8041@comcast.net> <20091015192647.GF20210@me> <4AD79CBC.10606@dev.mellanox.co.il> <20091016120154.GO20210@me>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091016120154.GO20210@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sasha Khapyorsky wrote:
> On 00:05 Fri 16 Oct     , Yevgeny Kliteynik wrote:
>> If I remember it correctly, there's an INFO message
>> in the ucast mgr saying something like "switches
>> configured for unicast" or "<routing engine name>
>> tables configured", or something like that (I don't
>> have access to the code right now).
> 
> Yes, and there a needs of INFO level is also questionable IMHO.
> 
>> So I wanted to see one more line
> 
> There are more than one:
> 
> $ grep OSM_LOG_INFO opensm/osm_ucast_cache.c | wc -l 
> 19

That's true, but only one of them may be printed
each time the ucast manager runs.

-- Yevgeny

>> that says that
>> cache is not applicable.
> 
> We don't need an extra lines, one line instead (as I did in the posted
> patch) is enough.
> 
> Sasha
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
