From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_vendor_ibumad: Use OSM_UMAD_MAX_AGENTS rather
	than UMAD_CA_MAX_AGENTS
Date: Thu, 22 Oct 2009 08:49:21 -0400
Message-ID: <f0e08f230910220549g1035441dj3b89e543c44efd3a@mail.gmail.com>
References: <20091019153846.GA22111@comcast.net> <20091022122108.GE20210@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091022122108.GE20210@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

On Thu, Oct 22, 2009 at 8:21 AM, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>=
 wrote:
> Hi Hal,
>
> Could you add commit message to your patches (this and another)?

I thought the subject was sufficient and seems to be included in the
commits. Is that true ? What are you looking for here that is not
being done ?

> On 11:38 Mon 19 Oct =C2=A0 =C2=A0 , Hal Rosenstock wrote:
>>
>> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> diff --git a/opensm/include/vendor/osm_vendor_ibumad.h b/opensm/incl=
ude/vendor/osm_vendor_ibumad.h
>> index e346a2e..f3a48e5 100644
>> --- a/opensm/include/vendor/osm_vendor_ibumad.h
>> +++ b/opensm/include/vendor/osm_vendor_ibumad.h
>> @@ -66,6 +66,8 @@ BEGIN_C_DECLS
>> =C2=A0#define OSM_DEFAULT_RETRY_COUNT 3
>> =C2=A0#define OSM_UMAD_MAX_CAS =C2=A0 =C2=A0 32
>> =C2=A0#define OSM_UMAD_MAX_PORTS_PER_CA =C2=A0 =C2=A02
>> +#define OSM_UMAD_MAX_AGENTS =C2=A032
>> +
>> =C2=A0/****s* OpenSM: Vendor UMAD/osm_ca_info_t
>> =C2=A0* NAME
>> =C2=A0* =C2=A0 osm_ca_info_t
>> @@ -154,7 +156,7 @@ typedef struct _osm_vendor {
>> =C2=A0 =C2=A0 =C2=A0 osm_ca_info_t *p_ca_info;
>> =C2=A0 =C2=A0 =C2=A0 uint32_t timeout;
>> =C2=A0 =C2=A0 =C2=A0 int max_retries;
>> - =C2=A0 =C2=A0 osm_bind_handle_t agents[UMAD_CA_MAX_AGENTS];
>> + =C2=A0 =C2=A0 osm_bind_handle_t agents[OSM_UMAD_MAX_AGENTS];
>
> Any reason?

To make the umad vendor layer "stand on its own". This was discussed
in the Windows porting issues. See thread which ends
http://lists.openfabrics.org/pipermail/ofw/2009-October/005819.html

-- Hal

> Sasha
>
>> =C2=A0 =C2=A0 =C2=A0 char ca_names[OSM_UMAD_MAX_CAS][UMAD_CA_NAME_LE=
N];
>> =C2=A0 =C2=A0 =C2=A0 vendor_match_tbl_t mtbl;
>> =C2=A0 =C2=A0 =C2=A0 umad_port_t umad_port;
>> diff --git a/opensm/libvendor/osm_vendor_ibumad.c b/opensm/libvendor=
/osm_vendor_ibumad.c
>> index 8d3c680..b221335 100644
>> --- a/opensm/libvendor/osm_vendor_ibumad.c
>> +++ b/opensm/libvendor/osm_vendor_ibumad.c
>> @@ -288,7 +288,7 @@ static void *umad_receiver(void *p_ptr)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 }
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>>
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mad_agent >=3D UMAD_=
CA_MAX_AGENTS ||
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (mad_agent >=3D OSM_U=
MAD_MAX_AGENTS ||
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 !(p_b=
ind =3D p_vend->agents[mad_agent])) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 OSM_LOG(p_ur->p_log, OSM_LOG_ERROR, "ERR 5407: "
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "invalid mad agent %d - dropping\n"=
, mad_agent);
>> @@ -738,7 +738,7 @@ static void osm_vendor_close_port(osm_vendor_t *=
 const p_vend)
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> =C2=A0 =C2=A0 =C2=A0 if (p_vend->umad_port_id >=3D 0) {
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < UMAD_C=
A_MAX_AGENTS; i++)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < OSM_UM=
AD_MAX_AGENTS; i++)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 if (p_vend->agents[i])
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 umad_unregister(p_vend->umad_port_i=
d, i);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 umad_close_port(p_v=
end->umad_port_id);
>> @@ -862,7 +862,7 @@ osm_vendor_bind(IN osm_vendor_t * const p_vend,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto Exit;
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> - =C2=A0 =C2=A0 if (p_bind->agent_id >=3D UMAD_CA_MAX_AGENTS ||
>> + =C2=A0 =C2=A0 if (p_bind->agent_id >=3D OSM_UMAD_MAX_AGENTS ||
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_vend->agents[p_bind->agent_id])=
 {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OSM_LOG(p_vend->p_l=
og, OSM_LOG_ERROR, "ERR 5427: "
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 "bad agent id %u or duplicate agent for class %u vers %u\n",
>> @@ -890,7 +890,7 @@ osm_vendor_bind(IN osm_vendor_t * const p_vend,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 goto Exit;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>>
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (p_bind->agent_id1 >=3D=
 UMAD_CA_MAX_AGENTS ||
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (p_bind->agent_id1 >=3D=
 OSM_UMAD_MAX_AGENTS ||
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_ven=
d->agents[p_bind->agent_id1]) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 OSM_LOG(p_vend->p_log, OSM_LOG_ERROR, "ERR 5429: "
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "bad agent id %u or duplicate agent=
 for class 1 vers %u\n",
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
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
