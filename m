From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 2/2] IB/core: Align casting method of
 ib_device_cap_flags enumerations to ULL
Date: Mon, 6 Jun 2016 10:15:43 -0700
Message-ID: <20160606171543.GA14882@kroah.com>
References: <1465230880-25953-1-git-send-email-maxg@mellanox.com>
 <1465230880-25953-3-git-send-email-maxg@mellanox.com>
 <20160606170413.GB28622@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160606170413.GB28622-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-2ukJVAZIZ/Y@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 06, 2016 at 10:04:13AM -0700, Christoph Hellwig wrote:
> On Mon, Jun 06, 2016 at 07:34:40PM +0300, Max Gurtovoy wrote:
> > Replace u64 casting to ULL.
> > 
> > Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > ---
> >  include/rdma/ib_verbs.h |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > index c97357b..7e440d4 100644
> > --- a/include/rdma/ib_verbs.h
> > +++ b/include/rdma/ib_verbs.h
> > @@ -219,8 +219,8 @@ enum ib_device_cap_flags {
> >  	IB_DEVICE_SIGNATURE_HANDOVER		= (1 << 30),
> >  	IB_DEVICE_ON_DEMAND_PAGING		= (1ULL << 31),
> >  	IB_DEVICE_SG_GAPS_REG			= (1ULL << 32),
> > -	IB_DEVICE_VIRTUAL_FUNCTION		= ((u64)1 << 33),
> > -	IB_DEVICE_RAW_SCATTER_FCS		= ((u64)1 << 34),
> > +	IB_DEVICE_VIRTUAL_FUNCTION		= (1ULL << 33),
> > +	IB_DEVICE_RAW_SCATTER_FCS		= (1ULL << 34),
> 
> Looks good, but can you also convert the whole enum to this
> style?

If this "convert the whole thing" is going to happen, can you use the
BIT() for this please?  I asked that last time this patch came by...

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
