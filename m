From: Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH/opensm] Decode the SAPKeyTableRecord block number
 properly, and don't segv
Date: Fri, 25 Feb 2011 13:25:15 +0200
Message-ID: <20110225112514.GC8537@calypso.voltaire.com>
References: <20110211221206.GA8532@obsidianresearch.com>
 <20110223172019.GA8537@calypso.voltaire.com>
 <AANLkTinm5Uh-9h+WMh6O8dLsPr8wpdt0BJmOu3+Dt8vj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinm5Uh-9h+WMh6O8dLsPr8wpdt0BJmOu3+Dt8vj-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 14:01 Wed 23 Feb     , Hal Rosenstock wrote:
> On Wed, Feb 23, 2011 at 12:20 PM, Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org> wr=
ote:
> > Hi Jason,
> >
> > On 15:12 Fri 11 Feb =A0 =A0 , Jason Gunthorpe wrote:
> >> * Properly byteswap block_num before using it
> >> * Properly check bounds of the block number before de-referencing =
it.
> >>
> >> This fixes a remotely triggered null pointer dereference.
> >> ---
> >> =A0opensm/include/iba/ib_types.h =A0 =A0 =A0| =A0 =A02 +-
> >> =A0opensm/opensm/osm_sa_pkey_record.c | =A0 16 ++++++++++++----
> >> =A02 files changed, 13 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/opensm/include/iba/ib_types.h b/opensm/include/iba/ib=
_types.h
> >> index e1bc102..24f5662 100644
> >> --- a/opensm/include/iba/ib_types.h
> >> +++ b/opensm/include/iba/ib_types.h
> >> @@ -6724,7 +6724,7 @@ typedef struct _ib_pkey_table {
> >> =A0#include <complib/cl_packon.h>
> >> =A0typedef struct _ib_pkey_table_record {
> >> =A0 =A0 =A0 ib_net16_t lid; =A0 =A0 =A0 =A0 // for CA: lid of port=
, for switch lid of port 0
> >> - =A0 =A0 uint16_t block_num;
> >> + =A0 =A0 ib_net16_t block_num;
> >> =A0 =A0 =A0 uint8_t port_num; =A0 =A0 =A0 // for switch: port numb=
er, for CA: reserved
> >> =A0 =A0 =A0 uint8_t reserved1;
> >> =A0 =A0 =A0 uint16_t reserved2;
> >
> > I guess reserved2 could also be changed to ib_net16_t, right?
> >
> >> diff --git a/opensm/opensm/osm_sa_pkey_record.c b/opensm/opensm/os=
m_sa_pkey_record.c
> >> index e4930d0..cf50430 100644
> >> --- a/opensm/opensm/osm_sa_pkey_record.c
> >> +++ b/opensm/opensm/osm_sa_pkey_record.c
> >> @@ -71,6 +71,7 @@ static void sa_pkey_create(IN osm_sa_t * sa, IN =
osm_physp_t * p_physp,
> >> =A0 =A0 =A0 osm_pkey_item_t *p_rec_item;
> >> =A0 =A0 =A0 uint16_t lid;
> >> =A0 =A0 =A0 ib_api_status_t status =3D IB_SUCCESS;
> >> + =A0 =A0 ib_pkey_table_t *tbl;
> >>
> >> =A0 =A0 =A0 OSM_LOG_ENTER(sa->p_log);
> >>
> >> @@ -98,8 +99,15 @@ static void sa_pkey_create(IN osm_sa_t * sa, IN=
 osm_physp_t * p_physp,
> >> =A0 =A0 =A0 p_rec_item->rec.lid =3D lid;
> >> =A0 =A0 =A0 p_rec_item->rec.block_num =3D block;
> >> =A0 =A0 =A0 p_rec_item->rec.port_num =3D osm_physp_get_port_num(p_=
physp);
> >> - =A0 =A0 p_rec_item->rec.pkey_tbl =3D
> >> - =A0 =A0 =A0 =A0 *(osm_pkey_tbl_block_get(osm_physp_get_pkey_tbl(=
p_physp), block));
> >> + =A0 =A0 /* FIXME: There are ninf.PartitionCap or swinf.Partition=
EnforcementCap
> >> + =A0 =A0 =A0 =A0pkey entries so everything in that range is a val=
id block number
> >> + =A0 =A0 =A0 =A0even if opensm is not using it. Return 0. However=
 things outside
> >> + =A0 =A0 =A0 =A0that range should return no entries.. Not sure ho=
w to figure that
> >> + =A0 =A0 =A0 =A0here? The range of pkey_tbl can be less than the =
cap, so
> >> + =A0 =A0 =A0 =A0this falsely triggers. */
> >> + =A0 =A0 tbl =3D osm_pkey_tbl_block_get(osm_physp_get_pkey_tbl(p_=
physp), block);
> >> + =A0 =A0 if (tbl)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 p_rec_item->rec.pkey_tbl =3D *tbl;
> >>
> >> =A0 =A0 =A0 cl_qlist_insert_tail(p_ctxt->p_list, &p_rec_item->list=
_item);
> >
> > What is the expected behaviour when IB PKey table block is empty?
> > rec.pkey_tbl might be uninitialized here.
> > Shouldn't SubnAdmGetResp contain ERR_NO_RECORDS in such case?
>=20
> It depends on the method used in the SA query. GetTable never returns
> ERR_NO_RECORDS whereas a Get can.
>=20

In case when IB PKey table block is empty, p_rec_item->rec.pkey_tbl wou=
ld be uninitialized.

> -- Hal
>=20
> >>
> >> @@ -269,14 +277,14 @@ void osm_pkey_rec_rcv_process(IN void *ctx, =
IN void *data)
> >> =A0 =A0 =A0 context.p_list =3D &rec_list;
> >> =A0 =A0 =A0 context.comp_mask =3D p_rcvd_mad->comp_mask;
> >> =A0 =A0 =A0 context.sa =3D sa;
> >> - =A0 =A0 context.block_num =3D p_rcvd_rec->block_num;
> >> + =A0 =A0 context.block_num =3D cl_ntoh16(p_rcvd_rec->block_num);
> >> =A0 =A0 =A0 context.p_req_physp =3D p_req_physp;
> >>
> >> =A0 =A0 =A0 OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Got Query Lid:%u(%02X), Block:0x%02X(=
%02X), Port:0x%02X(%02X)\n",
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cl_ntoh16(p_rcvd_rec->lid),
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 (comp_mask & IB_PKEY_COMPMASK_LID) !=3D=
 0, p_rcvd_rec->port_num,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 (comp_mask & IB_PKEY_COMPMASK_PORT) !=3D=
 0, p_rcvd_rec->block_num,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 (comp_mask & IB_PKEY_COMPMASK_PORT) !=3D=
 0, context.block_num,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 (comp_mask & IB_PKEY_COMPMASK_BLOCK) !=
=3D 0);
> >>
> >> =A0 =A0 =A0 cl_plock_acquire(sa->p_lock);
> >> --
> >> 1.7.1
> >>
> >
> > Alex
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdm=
a" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
