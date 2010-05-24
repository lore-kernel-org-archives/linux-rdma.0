From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/qos.c: Revert port ranges for calls to
	sl2vl_update_table().
Date: Mon, 24 May 2010 14:03:01 -0400
Message-ID: <AANLkTimzCMA8sdpT7W7bpBnb0fqdEhA5I3j-6Vqc7S2L@mail.gmail.com>
References: <1851_1274473140_o4LKDZ3n001852_1274473115-3153-1-git-send-email-jaschut@sandia.gov>
	 <1274473795.4773.43.camel@sale659.sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1274473795.4773.43.camel-mgfCWIlwujvg4c9jKm7R2O1ftBKYq+Ku@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org" <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jim,

On Fri, May 21, 2010 at 4:29 PM, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org> wrote:
>
> Sorry, I somehow got this wrong.
>
> Corrected patch below.
>
> -- Jim
>
> On Fri, 2010-05-21 at 14:18 -0600, Jim Schutt wrote:
>> Before commit 051a1dd5 (opensm/osm_qos.c: split switch external and =
end
>> ports setup), osm_qos_setup() would end up calling sl2vl_update_tabl=
e()
>> for output ports 1-N, and inport ports 0-N.
>>
>> Commit 051a1dd5 changed this around to be output ports 0-N, and inpu=
t
>> ports 1-N, and an InfiniScale IV based fabric would log lots of erro=
rs
>> like these:
>>
>> =C2=A0 log_rcv_cb_error: ERR 3111: Received MAD with error status =3D=
 0x1C
>> =C2=A0 SubnGetResp(SLtoVLMappingTable), attr_mod 0x2300, TID 0xad069
>> =C2=A0 Initial path: 0,1,1,4,13 Return path: 0,25,1,7,10
>>
>> The attr_mod in every such message has 0x00 in the least significant
>> byte.

This is the output port.

>> With the port ranges restored to their old values, the above log mes=
sages
>> stop.

Is this with base or enhanced port 0 ? I'm assuming base. See comment b=
elow.

Also, what firmware version is in use ?

>> Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
>> ---
>> =C2=A0opensm/opensm/osm_qos.c | =C2=A0 =C2=A08 ++++----
>> =C2=A01 files changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
>> index 6bbbfa2..b8c3111 100644
>> --- a/opensm/opensm/osm_qos.c
>> +++ b/opensm/opensm/osm_qos.c
>> @@ -230,12 +230,12 @@ static int qos_extports_setup(osm_sm_t * sm, o=
sm_node_t *node,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
&qcfg->sl2vl);
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> - =C2=A0 =C2=A0 for (i =3D 1; i < num_ports; i++) {
>> + =C2=A0 =C2=A0 for (i =3D 0; i < num_ports; i++) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p =3D osm_node_get_=
physp_ptr(node, i);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 force_update =3D p-=
>need_update || sm->p_subn->need_update;
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (j =3D 0; j < num_po=
rts; j++)
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (sl2vl_update_table(sm, p, i, i << 8 | j,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0force_update, &qcfg->sl2vl))
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (j =3D 1; j < num_po=
rts; j++)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (sl2vl_update_table(sm, p, i, j, force_update,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0&qcfg->sl2vl))
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D -1;
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>
> diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
> index 6bbbfa2..7d76c75 100644
> @@ -230,10 +230,10 @@ static int qos_extports_setup(osm_sm_t * sm, os=
m_node_t *node,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0&qcfg->sl2vl);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> - =C2=A0 =C2=A0 =C2=A0 for (i =3D 1; i < num_ports; i++) {
> + =C2=A0 =C2=A0 =C2=A0 for (i =3D 0; i < num_ports; i++) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0p =3D osm_node=
_get_physp_ptr(node, i);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0force_update =3D=
 p->need_update || sm->p_subn->need_update;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (j =3D 0; j < =
num_ports; j++)
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (j =3D 1; j < =
num_ports; j++)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0if (sl2vl_update_table(sm, p, i, i << 8 | j,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 force_update, &qcfg->sl2vl))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D -1;
>

I think the start for j depends on whether it is base or enhanced port
0. Start should be 0 for enhanced and 1 for base.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
