From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [OPENSM] match functions to prototypes in header file
Date: Thu, 1 Oct 2009 12:30:35 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1912C86E88D1@orsmsx501.amr.corp.intel.com>
References: <3DE88517D38A4EB0B49A2E3AAF96D005@amr.corp.intel.com>
 <20091001183127.GX17846@me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091001183127.GX17846@me>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sasha Khapyorsky wrote:
<snip...>
>> @@ -1080,7 +1082,8 @@ void osm_dump_node_record(IN osm_log_t * p_log,
>>
>>  /**********************************************************************
>>
>> **********************************************************************/
>> -void osm_dump_path_record(IN osm_log_t * p_log, IN const
>> ib_path_rec_t * p_pr, +void osm_dump_path_record(IN osm_log_t *
>>                        const p_log, +                          IN const ib_path_rec_t * const p_pr, IN
>>  const osm_log_level_t log_level) {
>>      if (osm_log_is_active(p_log, log_level)) {
>> @@ -1106,9 +1109,9 @@ void osm_dump_path_record(IN osm_log_t *
>>                      p_log, IN const ib_path_rec_t * p_pr,
>>                      "\t\t\t\tresv2...................0x%X\n"
>>                      "\t\t\t\tresv3...................0x%X\n",
>> cl_ntoh64(p_pr->service_id), -                       inet_ntop(AF_INET6, p_pr->dgid.raw,
>> gid_str, +                   inet_ntop(AF_INET6, (void*)p_pr->dgid.raw, gid_str,
>
> And why is such casting(s) needed?

The '(void *)' on inet_ntop() was the only way I could get the MS compiler warnings about differing const types to go away;
(const void *) failed.
Since suppression of information is the preferred modus operandi, I'll see if I can figure out a way to suppress the warning.

>
> Also wouldn't it be simpler to remove 'const' in "type * const var"
> function parameter definitions? This restricts only value of a pointer
> (not structure content), and since function parameters are passed by
> values such restriction is only related to a function implementation
> and actually meanless in sense of API. Thoughts?

I'm just the messenger here, making the function match the prototype.
Fine by me if you choose to change both.

Stan.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
