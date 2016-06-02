From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/core: Fix bit curruption in ib_device_cap_flags
 structure
Date: Thu, 2 Jun 2016 11:48:02 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1606021139040.11781@east.gentwo.org>
References: <1464859685-18666-1-git-send-email-maxg@mellanox.com> <20160602162426.GC26699@kroah.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160602162426.GC26699-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leon-2ukJVAZIZ/Y@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2 Jun 2016, Greg KH wrote:

> > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > index 432bed5..c97357b 100644
> > --- a/include/rdma/ib_verbs.h
> > +++ b/include/rdma/ib_verbs.h
> > @@ -217,7 +217,7 @@ enum ib_device_cap_flags {
> >  	IB_DEVICE_CROSS_CHANNEL		= (1 << 27),
> >  	IB_DEVICE_MANAGED_FLOW_STEERING		= (1 << 29),
> >  	IB_DEVICE_SIGNATURE_HANDOVER		= (1 << 30),
> > -	IB_DEVICE_ON_DEMAND_PAGING		= (1 << 31),
> > +	IB_DEVICE_ON_DEMAND_PAGING		= (1ULL << 31),
> >  	IB_DEVICE_SG_GAPS_REG			= (1ULL << 32),
> >  	IB_DEVICE_VIRTUAL_FUNCTION		= ((u64)1 << 33),
> >  	IB_DEVICE_RAW_SCATTER_FCS		= ((u64)1 << 34),
>
> Why not just use the BIT() and BIT_ULL() macros instead of "open coding"
> these?

This whole enum approach for powers of two also looks not that good. Do an
unsigned long long or u64 please? Use enum to define the individual
bits and not for the bitmask? Could add _MASK for that if you really want
it.

unsigned long long ib_device_cap_flags;

enum ib_dev_caps = { IB_DEVICE_CROSS_CHANNEL, IB_DEVICE_SG_GAPS_REG, ....
NR_IB_DEV_CAPS };

Then use

BIT_ULL(IB_DEVICE_CROSS_CHANNEL) in the code?


Or just specify the bitmasks using hex constants?

from sched.h:

#define SD_LOAD_BALANCE         0x0001  /* Do load balancing on this domain. */
#define SD_BALANCE_NEWIDLE      0x0002  /* Balance when about to become idle */
#define SD_BALANCE_EXEC         0x0004  /* Balance on exec */
#define SD_BALANCE_FORK         0x0008  /* Balance on fork, clone */
#define SD_BALANCE_WAKE         0x0010  /* Balance on wakeup */
#define SD_WAKE_AFFINE          0x0020  /* Wake task to waking CPU */
#define SD_SHARE_CPUCAPACITY    0x0080  /* Domain members share cpu power */
#define SD_SHARE_POWERDOMAIN    0x0100  /* Domain members share power domain */
#define SD_SHARE_PKG_RESOURCES  0x0200  /* Domain members share cpu pkg resources */
#define SD_SERIALIZE            0x0400  /* Only a single load balancing instance */
#define SD_ASYM_PACKING         0x0800  /* Place busy groups earlier in the domain */
#define SD_PREFER_SIBLING       0x1000  /* Prefer to place tasks in a sibling domain */
#define SD_OVERLAP              0x2000  /* sched_domains of this level overlap */
#define SD_NUMA                 0x4000  /* cross-node balancing */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
