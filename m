From: Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH/opensm] Decode the SAPKeyTableRecord block number
 properly, and don't segv
Date: Sat, 26 Feb 2011 00:02:59 +0200
Message-ID: <20110225220259.GA7222@calypso.voltaire.com>
References: <20110211221206.GA8532@obsidianresearch.com>
 <20110223172019.GA8537@calypso.voltaire.com>
 <AANLkTinm5Uh-9h+WMh6O8dLsPr8wpdt0BJmOu3+Dt8vj@mail.gmail.com>
 <20110225112514.GC8537@calypso.voltaire.com>
 <20110225193509.GA9157@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110225193509.GA9157-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12:35 Fri 25 Feb     , Jason Gunthorpe wrote:
> On Fri, Feb 25, 2011 at 01:25:15PM +0200, Alex Netes wrote:
> 
> > > > What is the expected behaviour when IB PKey table block is empty?
> > > > rec.pkey_tbl might be uninitialized here.
> > > > Shouldn't SubnAdmGetResp contain ERR_NO_RECORDS in such case?
> > > 
> > > It depends on the method used in the SA query. GetTable never returns
> > > ERR_NO_RECORDS whereas a Get can.
> > 
> > In case when IB PKey table block is empty, p_rec_item->rec.pkey_tbl would be uninitialized.
> 
> No, it isn't, it is zero.
> 
>         memset(p_rec_item, 0, sizeof(*p_rec_item));
> 
>         p_rec_item->rec.lid = lid;
>         p_rec_item->rec.block_num = block;
>         p_rec_item->rec.port_num = osm_physp_get_port_num(p_physp);
>         p_rec_item->rec.pkey_tbl =
>             *(osm_pkey_tbl_block_get(osm_physp_get_pkey_tbl(p_physp),
> 	    block));
> 
> 
> Jason

Sorry. Missed that.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
