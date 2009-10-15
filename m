From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_ucast_cache.c: Cosmetic change to log message
	for consistency
Date: Thu, 15 Oct 2009 15:43:12 -0400
Message-ID: <f0e08f230910151243o12ec4fffv70f6a278667f55e@mail.gmail.com>
References: <20091015133639.GB8041@comcast.net> <20091015192647.GF20210@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091015192647.GF20210@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 15, 2009 at 3:26 PM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> On 09:36 Thu 15 Oct =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> diff --git a/opensm/opensm/osm_ucast_cache.c b/opensm/opensm/osm_uca=
st_cache.c
>> index 31a5333..8db9df2 100644
>> --- a/opensm/opensm/osm_ucast_cache.c
>> +++ b/opensm/opensm/osm_ucast_cache.c
>> @@ -876,7 +876,7 @@ void osm_ucast_cache_add_link(osm_ucast_mgr_t * =
p_mgr,
>> =C2=A0 =C2=A0 =C2=A0 if (osm_node_get_type(p_node_1) !=3D IB_NODE_TY=
PE_SWITCH &&
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 osm_node_get_type(p_node_2) !=3D =
IB_NODE_TYPE_SWITCH) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(p_mgr->p_lo=
g, OSM_LOG_INFO,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 "Dropping CA-2-CA link - cache invalid\n");
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 "Dropping CA/RTR-2-CA/RTR link - cache invalid\n");
>
> IMHO it looks more confusing after the change.

It's more accurate and consistent; There's another log message which
says "CA/RTR-2-CA/RTR" rather than "CA-2-CA".

-- Hal

> BTW why should OSM_LOG_INFO level be used here?
>
> Sasha
>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 osm_ucast_cache_inv=
alidate(p_mgr);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto Exit;
>> =C2=A0 =C2=A0 =C2=A0 }
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
