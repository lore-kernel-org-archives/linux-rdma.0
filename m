From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_log.h: osm_log_is_active should return true
	for syslog
Date: Tue, 11 May 2010 21:20:54 +0300
Message-ID: <4BE9A006.8030707@dev.mellanox.co.il>
References: <4BE91DF9.4020902@dev.mellanox.co.il>
	<20100511162148.GD28549@me>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100511162148.GD28549@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11-May-10 7:21 PM, Sasha Khapyorsky wrote:
> On 12:06 Tue 11 May     , Yevgeny Kliteynik wrote:
>>
>> osm_log() always logs messages that came with OSM_LOG_SYS level,
>> so osm_log_is_active() should concur with this.
>> As a by-product of this fix, OSM_LOG_SYS messages can now be
>> printed with OSM_LOG macro, instead of using osm_log() directly.
>>
>> Signed-off-by: Yevgeny Kliteynik<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>> ---
>>   opensm/include/opensm/osm_log.h |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/opensm/include/opensm/osm_log.h b/opensm/include/opensm/osm_log.h
>> index b2f105a..a494bc3 100644
>> --- a/opensm/include/opensm/osm_log.h
>> +++ b/opensm/include/opensm/osm_log.h
>> @@ -355,7 +355,7 @@ static inline void osm_log_set_level(IN osm_log_t * p_log,
>>   static inline boolean_t osm_log_is_active(IN const osm_log_t * p_log,
>>   					  IN osm_log_level_t level)
>>   {
>> -	return ((p_log->level&  level) != 0);
>> +	return (((OSM_LOG_SYS | p_log->level)&  level) != 0);
>>   }
>
> What about to set OSM_LOG_SYS bits in p_log->level at stage of
> initialization and to remove all subsequent explicit checks? Like this
> (against master):
>
> diff --git a/opensm/opensm/osm_log.c b/opensm/opensm/osm_log.c
> index 54c2f36..bd4a200 100644
> --- a/opensm/opensm/osm_log.c
> +++ b/opensm/opensm/osm_log.c
> @@ -119,7 +119,7 @@ void osm_log(IN osm_log_t * p_log, IN osm_log_level_t verbosity,
>   #endif				/* __WIN__ */
>
>   	/* If this is a call to syslog - always print it */
> -	if (!(verbosity&  (OSM_LOG_SYS | p_log->level)))
> +	if (!(verbosity&  p_log->level))
>   		return;
>
>   	va_start(args, p_str);
> @@ -306,7 +306,7 @@ ib_api_status_t osm_log_init_v2(IN osm_log_t * p_log, IN boolean_t flush,
>   				IN unsigned long max_size,
>   				IN boolean_t accum_log_file)
>   {
> -	p_log->level = log_flags;
> +	p_log->level = log_flags | OSM_LOG_SYS;

Sure, that should do the trick too.
Want me to send a patch, or will you do it?

-- Yevgeny

>   	p_log->flush = flush;
>   	p_log->count = 0;
>   	p_log->max_size = max_size<<  20; /* convert size in MB to bytes */
>
>
> Sasha
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
