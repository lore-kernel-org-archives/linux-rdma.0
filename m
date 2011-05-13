From: Eli Dorfman <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_pkey_mgr: clean partition enforcement on
 inter-switch links
Date: Fri, 13 May 2011 10:44:04 +0300
Message-ID: <BANLkTinxwQMCdh3iEL5q+LLmn65SB7=qfA@mail.gmail.com>
References: <4DBFB67F.2090400@dev.mellanox.co.il>
	<20110503154847.GA2303@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110503154847.GA2303-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Eli Dorfman <elido-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 3, 2011 at 6:48 PM, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Hi Eli,
>
> On 11:02 Tue 03 May =C2=A0 =C2=A0 , Eli Dorfman wrote:
>> clean partition enforcement on inter-switch links
>>
>> after connectivity change from switch-host to switch-switch the
>> partition enforcement bits were not cleared on the port.
>> since the pkey table is not set on inter-switch links,
>> packets with pkey other than default are dropped.
>>
>> Signed-off-by: Eli Dorfman <elido-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>> =C2=A0opensm/osm_pkey_mgr.c | =C2=A0 24 ++++++++++++++++++++++++
>> =C2=A01 files changed, 24 insertions(+), 0 deletions(-)
>>
>> diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
>> index f6bc9d1..b135cf9 100644
>> --- a/opensm/osm_pkey_mgr.c
>> +++ b/opensm/osm_pkey_mgr.c
>> @@ -507,6 +507,10 @@ int osm_pkey_mgr_process(IN osm_opensm_t * p_os=
m)
>> =C2=A0 =C2=A0 =C2=A0 cl_map_item_t *p_next;
>> =C2=A0 =C2=A0 =C2=A0 osm_prtn_t *p_prtn;
>> =C2=A0 =C2=A0 =C2=A0 osm_port_t *p_port;
>> + =C2=A0 =C2=A0 osm_switch_t *p_sw;
>> + =C2=A0 =C2=A0 osm_physp_t *p_physp;
>> + =C2=A0 =C2=A0 osm_node_t *p_remote_node;
>> + =C2=A0 =C2=A0 uint8_t i;
>> =C2=A0 =C2=A0 =C2=A0 int ret =3D 0;
>>
>> =C2=A0 =C2=A0 =C2=A0 CL_ASSERT(p_osm);
>> @@ -550,6 +554,26 @@ int osm_pkey_mgr_process(IN osm_opensm_t * p_os=
m)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ret =3D -1;
>> =C2=A0 =C2=A0 =C2=A0 }
>>
>> + =C2=A0 =C2=A0 /* clear partition enforcement on inter-switch links=
 */
>> + =C2=A0 =C2=A0 p_tbl =3D &p_osm->subn.sw_guid_tbl;
>> + =C2=A0 =C2=A0 p_next =3D cl_qmap_head(p_tbl);
>> + =C2=A0 =C2=A0 while (p_next !=3D cl_qmap_end(p_tbl)) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_sw =3D (osm_switch_t *=
 *) p_next;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_next =3D cl_qmap_next(=
p_next);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (i =3D 1; i < p_sw->=
num_ports; i++) {
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 p_physp =3D osm_node_get_physp_ptr(p_sw->p_node, i);
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (p_physp && p_physp->p_remote_physp)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_remote_node =3D p_physp->p_remote_phy=
sp->p_node;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 else
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (osm_node_get_type(p_remote_node) !=3D IB_NODE_TYPE_SWITCH)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;
>> +
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /* clear partition enforcement */
>
> Don't you want limit the pkey_mgr_enforce_partition() only on ports t=
hat have
> these bits enable in portinfo?
> Something like:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0if(! p_physp->p_remote_physp->port_info.vl_enforce && 0xc=
 )
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0continue;
>
Yes, this is a good optimization but it should check the local physp
since we're running on all switches.
                         if(! p_physp->port_info.vl_enforce && 0xc )
                                continue;

-- Eli
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (pkey_mgr_enforce_partition(&p_osm->log, &p_osm->sm, p_physp, FA=
LSE))
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D -1;
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> + =C2=A0 =C2=A0 }
>> =C2=A0_err:
>> =C2=A0 =C2=A0 =C2=A0 CL_PLOCK_RELEASE(&p_osm->lock);
>> =C2=A0 =C2=A0 =C2=A0 OSM_LOG_EXIT(&p_osm->log);
>> --
>> 1.7.4.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
> --
>
> -- Alex
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
