From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH/opensm] Decode the SAPKeyTableRecord block number
 properly, and don't segv
Date: Wed, 23 Feb 2011 11:13:37 -0700
Message-ID: <20110223181337.GA31715@obsidianresearch.com>
References: <20110211221206.GA8532@obsidianresearch.com>
 <20110223172019.GA8537@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110223172019.GA8537-iQai9MGU/dyyaiaB+Ve85laTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 23, 2011 at 07:20:19PM +0200, Alex Netes wrote:

> I guess reserved2 could also be changed to ib_net16_t, right?

Sure, but unrelated, might be lots more too?
 
> > diff --git a/opensm/opensm/osm_sa_pkey_record.c b/opensm/opensm/osm_sa_pkey_record.c
> > index e4930d0..cf50430 100644
> > +++ b/opensm/opensm/osm_sa_pkey_record.c
> > @@ -71,6 +71,7 @@ static void sa_pkey_create(IN osm_sa_t * sa, IN osm_physp_t * p_physp,
> >  	osm_pkey_item_t *p_rec_item;
> >  	uint16_t lid;
> >  	ib_api_status_t status = IB_SUCCESS;
> > +	ib_pkey_table_t *tbl;
> >  
> >  	OSM_LOG_ENTER(sa->p_log);
> >  
> > @@ -98,8 +99,15 @@ static void sa_pkey_create(IN osm_sa_t * sa, IN osm_physp_t * p_physp,
> >  	p_rec_item->rec.lid = lid;
> >  	p_rec_item->rec.block_num = block;
> >  	p_rec_item->rec.port_num = osm_physp_get_port_num(p_physp);
> > -	p_rec_item->rec.pkey_tbl =
> > -	    *(osm_pkey_tbl_block_get(osm_physp_get_pkey_tbl(p_physp), block));
> > +	/* FIXME: There are ninf.PartitionCap or swinf.PartitionEnforcementCap
> > +	   pkey entries so everything in that range is a valid block number
> > +	   even if opensm is not using it. Return 0. However things outside
> > +	   that range should return no entries.. Not sure how to figure that
> > +	   here? The range of pkey_tbl can be less than the cap, so
> > +	   this falsely triggers. */
> > +	tbl = osm_pkey_tbl_block_get(osm_physp_get_pkey_tbl(p_physp), block);
> > +	if (tbl)
> > +		p_rec_item->rec.pkey_tbl = *tbl;
> >  
> >  	cl_qlist_insert_tail(p_ctxt->p_list, &p_rec_item->list_item);
>
> What is the expected behaviour when IB PKey table block is empty?

IBA is unclear in this case. In my view, direct queries for SA records
should return the same result as a direct SMP for the same data, so
returning a wack of 0 is appropriate. Another view would be that the
SA data is 'empty' so ERR_NO_RECORDS is OK, which matches what
GetTable would return.

> rec.pkey_tbl might be uninitialized here.

All of p_rec_item is memset to 0.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
