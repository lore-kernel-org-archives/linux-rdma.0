From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH] IB/core: Fix bit curruption in ib_device_cap_flags
 structure
Date: Thu, 2 Jun 2016 09:52:26 -0700
Message-ID: <20160602165226.GA30960@kroah.com>
References: <1464859685-18666-1-git-send-email-maxg@mellanox.com>
 <20160602162426.GC26699@kroah.com>
 <c72fac21-0a3d-fc40-ec82-e156f29c2fab@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c72fac21-0a3d-fc40-ec82-e156f29c2fab-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-2ukJVAZIZ/Y@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 02, 2016 at 09:41:03AM -0700, Bart Van Assche wrote:
> On 06/02/2016 09:24 AM, Greg KH wrote:
> > On Thu, Jun 02, 2016 at 12:28:05PM +0300, Max Gurtovoy wrote:
> > > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > > index 432bed5..c97357b 100644
> > > --- a/include/rdma/ib_verbs.h
> > > +++ b/include/rdma/ib_verbs.h
> > > @@ -217,7 +217,7 @@ enum ib_device_cap_flags {
> > >  	IB_DEVICE_CROSS_CHANNEL		= (1 << 27),
> > >  	IB_DEVICE_MANAGED_FLOW_STEERING		= (1 << 29),
> > >  	IB_DEVICE_SIGNATURE_HANDOVER		= (1 << 30),
> > > -	IB_DEVICE_ON_DEMAND_PAGING		= (1 << 31),
> > > +	IB_DEVICE_ON_DEMAND_PAGING		= (1ULL << 31),
> > >  	IB_DEVICE_SG_GAPS_REG			= (1ULL << 32),
> > >  	IB_DEVICE_VIRTUAL_FUNCTION		= ((u64)1 << 33),
> > >  	IB_DEVICE_RAW_SCATTER_FCS		= ((u64)1 << 34),
> > 
> > Why not just use the BIT() and BIT_ULL() macros instead of "open coding"
> > these?
> 
> Hi Greg,
> 
> Are you sure that these macros are useful?

Yes.

> My personal opinion is that these macros makes code harder to read
> instead of easier. I'd like to see these macros disappear.

Sorry but we are converting the whole kernel to use them, I suggest you
get used to them :)

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
