From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH/opensm] Decode the SAPKeyTableRecord block number
 properly, and don't segv
Date: Wed, 23 Feb 2011 14:01:39 -0500
Message-ID: <AANLkTinm5Uh-9h+WMh6O8dLsPr8wpdt0BJmOu3+Dt8vj@mail.gmail.com>
References: <20110211221206.GA8532@obsidianresearch.com>
	<20110223172019.GA8537@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110223172019.GA8537-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 23, 2011 at 12:20 PM, Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrot=
e:
> Hi Jason,
>
> On 15:12 Fri 11 Feb =C2=A0 =C2=A0 , Jason Gunthorpe wrote:
>> * Properly byteswap block_num before using it
>> * Properly check bounds of the block number before de-referencing it=
=2E
>>
>> This fixes a remotely triggered null pointer dereference.
>> ---
>> =C2=A0opensm/include/iba/ib_types.h =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=
=A02 +-
>> =C2=A0opensm/opensm/osm_sa_pkey_record.c | =C2=A0 16 ++++++++++++---=
-
>> =C2=A02 files changed, 13 insertions(+), 5 deletions(-)
>>
>> diff --git a/opensm/include/iba/ib_types.h b/opensm/include/iba/ib_t=
ypes.h
>> index e1bc102..24f5662 100644
>> --- a/opensm/include/iba/ib_types.h
>> +++ b/opensm/include/iba/ib_types.h
>> @@ -6724,7 +6724,7 @@ typedef struct _ib_pkey_table {
>> =C2=A0#include <complib/cl_packon.h>
>> =C2=A0typedef struct _ib_pkey_table_record {
>> =C2=A0 =C2=A0 =C2=A0 ib_net16_t lid; =C2=A0 =C2=A0 =C2=A0 =C2=A0 // =
for CA: lid of port, for switch lid of port 0
>> - =C2=A0 =C2=A0 uint16_t block_num;
>> + =C2=A0 =C2=A0 ib_net16_t block_num;
>> =C2=A0 =C2=A0 =C2=A0 uint8_t port_num; =C2=A0 =C2=A0 =C2=A0 // for s=
witch: port number, for CA: reserved
>> =C2=A0 =C2=A0 =C2=A0 uint8_t reserved1;
>> =C2=A0 =C2=A0 =C2=A0 uint16_t reserved2;
>
> I guess reserved2 could also be changed to ib_net16_t, right?
>
>> diff --git a/opensm/opensm/osm_sa_pkey_record.c b/opensm/opensm/osm_=
sa_pkey_record.c
>> index e4930d0..cf50430 100644
>> --- a/opensm/opensm/osm_sa_pkey_record.c
>> +++ b/opensm/opensm/osm_sa_pkey_record.c
>> @@ -71,6 +71,7 @@ static void sa_pkey_create(IN osm_sa_t * sa, IN os=
m_physp_t * p_physp,
>> =C2=A0 =C2=A0 =C2=A0 osm_pkey_item_t *p_rec_item;
>> =C2=A0 =C2=A0 =C2=A0 uint16_t lid;
>> =C2=A0 =C2=A0 =C2=A0 ib_api_status_t status =3D IB_SUCCESS;
>> + =C2=A0 =C2=A0 ib_pkey_table_t *tbl;
>>
>> =C2=A0 =C2=A0 =C2=A0 OSM_LOG_ENTER(sa->p_log);
>>
>> @@ -98,8 +99,15 @@ static void sa_pkey_create(IN osm_sa_t * sa, IN o=
sm_physp_t * p_physp,
>> =C2=A0 =C2=A0 =C2=A0 p_rec_item->rec.lid =3D lid;
>> =C2=A0 =C2=A0 =C2=A0 p_rec_item->rec.block_num =3D block;
>> =C2=A0 =C2=A0 =C2=A0 p_rec_item->rec.port_num =3D osm_physp_get_port=
_num(p_physp);
>> - =C2=A0 =C2=A0 p_rec_item->rec.pkey_tbl =3D
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 *(osm_pkey_tbl_block_get(osm_physp_get=
_pkey_tbl(p_physp), block));
>> + =C2=A0 =C2=A0 /* FIXME: There are ninf.PartitionCap or swinf.Parti=
tionEnforcementCap
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0pkey entries so everything in that rang=
e is a valid block number
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0even if opensm is not using it. Return =
0. However things outside
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0that range should return no entries.. N=
ot sure how to figure that
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0here? The range of pkey_tbl can be less=
 than the cap, so
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0this falsely triggers. */
>> + =C2=A0 =C2=A0 tbl =3D osm_pkey_tbl_block_get(osm_physp_get_pkey_tb=
l(p_physp), block);
>> + =C2=A0 =C2=A0 if (tbl)
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 p_rec_item->rec.pkey_tbl=
 =3D *tbl;
>>
>> =C2=A0 =C2=A0 =C2=A0 cl_qlist_insert_tail(p_ctxt->p_list, &p_rec_ite=
m->list_item);
>
> What is the expected behaviour when IB PKey table block is empty?
> rec.pkey_tbl might be uninitialized here.
> Shouldn't SubnAdmGetResp contain ERR_NO_RECORDS in such case?

It depends on the method used in the SA query. GetTable never returns
ERR_NO_RECORDS whereas a Get can.

-- Hal

>>
>> @@ -269,14 +277,14 @@ void osm_pkey_rec_rcv_process(IN void *ctx, IN=
 void *data)
>> =C2=A0 =C2=A0 =C2=A0 context.p_list =3D &rec_list;
>> =C2=A0 =C2=A0 =C2=A0 context.comp_mask =3D p_rcvd_mad->comp_mask;
>> =C2=A0 =C2=A0 =C2=A0 context.sa =3D sa;
>> - =C2=A0 =C2=A0 context.block_num =3D p_rcvd_rec->block_num;
>> + =C2=A0 =C2=A0 context.block_num =3D cl_ntoh16(p_rcvd_rec->block_nu=
m);
>> =C2=A0 =C2=A0 =C2=A0 context.p_req_physp =3D p_req_physp;
>>
>> =C2=A0 =C2=A0 =C2=A0 OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 "Got Query Lid:%u(%=
02X), Block:0x%02X(%02X), Port:0x%02X(%02X)\n",
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cl_ntoh16(p_rcvd_re=
c->lid),
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (comp_mask & IB_PKE=
Y_COMPMASK_LID) !=3D 0, p_rcvd_rec->port_num,
>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (comp_mask & IB_PKEY_COM=
PMASK_PORT) !=3D 0, p_rcvd_rec->block_num,
>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (comp_mask & IB_PKEY_COM=
PMASK_PORT) !=3D 0, context.block_num,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (comp_mask & IB_PKE=
Y_COMPMASK_BLOCK) !=3D 0);
>>
>> =C2=A0 =C2=A0 =C2=A0 cl_plock_acquire(sa->p_lock);
>> --
>> 1.7.1
>>
>
> Alex
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
