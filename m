From: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] opensm: Modify connect_roots to allow connectivity
 between all switches
Date: Tue, 15 Jun 2010 12:37:47 +0300
Message-ID: <4C1749EB.9020707@gmail.com>
References: <4C14E3D3.4070601@gmail.com> <4C14F4C8.1090102@gmail.com> <4C1646C0.1080201@dev.mellanox.co.il> <4C172710.9000708@gmail.com> <4C172520.5010904@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C172520.5010904-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yiftah Shahar <yiftahs-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Yevgeny Kliteynik wrote:
> On 15-Jun-10 10:09 AM, Eli Dorfman (Voltaire) wrote:
>> Yevgeny Kliteynik wrote:
>>> Eli,
>>>
>>> On 13-Jun-10 6:10 PM, Eli Dorfman (Voltaire) wrote:
>>>> After a second thought and in order not to break current configuration,
>>>> I send this modified patch that does not change connect_roots option
>>>> but
>>>> changes its functionality in up-down (I think that in fat-tree it is
>>>> already implemented)
>>>>
>>>> Modify connect_roots option to allow connectivity between
>>>> all switches in up-down routing algorithm and in this way be
>>>> fully IBA compliant
>>>>
>>>> Signed-off-by: Eli Dorfman<elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>
>>>> ---
>>>>    opensm/man/opensm.8.in         |    2 +-
>>>>    opensm/opensm/main.c           |    2 +-
>>>>    opensm/opensm/osm_ucast_updn.c |    4 +---
>>>>    3 files changed, 3 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/opensm/man/opensm.8.in b/opensm/man/opensm.8.in
>>>> index 9053611..c67126e 100644
>>>> --- a/opensm/man/opensm.8.in
>>>> +++ b/opensm/man/opensm.8.in
>>>> @@ -174,7 +174,7 @@ the host comes back online.
>>>>    .TP
>>>>    \fB\-z\fR, \fB\-\-connect_roots\fR
>>>>    This option enforces routing engines (up/down and
>>>> -fat-tree) to make connectivity between root switches and in
>>>> +fat-tree) to make connectivity between all switches and in
>>>>    this way to be fully IBA complaint. In many cases this can
>>>>    violate "pure" deadlock free algorithm, so use it carefully.
>>>>    .TP
>>>> diff --git a/opensm/opensm/main.c b/opensm/opensm/main.c
>>>> index 0093aa7..82ca78f 100644
>>>> --- a/opensm/opensm/main.c
>>>> +++ b/opensm/opensm/main.c
>>>> @@ -187,7 +187,7 @@ static void show_usage(void)
>>>>               "          Sets the SL to use to communicate with the
>>>> SM/SA. Defaults to 0.\n\n");
>>>>        printf("--connect_roots, -z\n"
>>>>               "          This option enforces routing engines (up/down
>>>> and \n"
>>>> -           "          fat-tree) to make connectivity between root
>>>> switches\n"
>>>> +           "          fat-tree) to make connectivity between all
>>>> switches\n"
>>>>               "          and in this way be IBA compliant. In many
>>>> cases,\n"
>>>>               "          this can violate \"pure\" deadlock free
>>>> algorithm, so\n"
>>>>               "          use it carefully.\n\n");
>>>> diff --git a/opensm/opensm/osm_ucast_updn.c
>>>> b/opensm/opensm/osm_ucast_updn.c
>>>> index 164c6f4..f44ca24 100644
>>>> --- a/opensm/opensm/osm_ucast_updn.c
>>>> +++ b/opensm/opensm/osm_ucast_updn.c
>>>> @@ -314,9 +314,7 @@ static int updn_set_min_hop_table(IN updn_t *
>>>> p_updn)
>>>>             item = cl_qmap_next(item)) {
>>>>            p_sw = (osm_switch_t *)item;
>>>>            /* Clear Min Hop Table */
>>>> -        if (p_subn->opt.connect_roots)
>>>> -            updn_clear_non_root_hops(p_updn, p_sw);
>>>> -        else
>>>> +        if (!p_subn->opt.connect_roots)
>>>>                osm_switch_clear_hops(p_sw);
>>>>        }
>>>>
>>>
>>> What kind of testing was done for this?
>>> I have a strong feeling that it will break up/down.
>>> If the connect_roots option is on, you will not clear
>>> the lid matrix at all, and it will contain also the
>>> down/up routes.
>>
>> that is the idea.
>> instead of leaving only up/dpwn routes we want to keep routes between
>> all switches.
>> the routes between host nodes will still be up/down.
> 
> Lid matrix might contain down/up routes between many
> kinds of switches, not only between roots. This means
> that you might have down/up paths between leaf switches,
> even though you could have found up/down path for them.
> This also means that you might end up with down/up routes
> between HCAs that are connected to these leafs.

ok I'll check this again.

Thanks,
Eli

> 
> -- Yevgeny
> 
>> Eli
>>
>>>
>>> -- Yevgeny
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
