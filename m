From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 3/8] IB/IPoIB: Increase local_lid to 32 bits
Date: Thu, 11 May 2017 11:49:09 +0300
Message-ID: <20170511084909.GG3011@yuval-lap>
References: <1494458576-6816-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1494458576-6816-4-git-send-email-dasaratharaman.chandramouli@intel.com>
 <20170511084126.GF3011@yuval-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170511084126.GF3011@yuval-lap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 11, 2017 at 11:41:26AM +0300, Yuval Shaia wrote:
> On Wed, May 10, 2017 at 07:22:51PM -0400, Dasaratharaman Chandramouli wrote:
> > IPoIB contains local_lid field which is 16 bits in
> > length, increase it to 32 bits.
> 
> Is it IPoIB thing only? i see it also in struct ib_wc

Sorry, please ignore this question.

Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>


> 
> > 
> > Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/infiniband/ulp/ipoib/ipoib.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
> > index ff50a7b..9e73810 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib.h
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib.h
> > @@ -366,7 +366,7 @@ struct ipoib_dev_priv {
> >  	u32		  qkey;
> >  
> >  	union ib_gid local_gid;
> > -	u16	     local_lid;
> > +	u32	     local_lid;
> >  
> >  	unsigned int admin_mtu;
> >  	unsigned int mcast_mtu;
> > -- 
> > 1.8.3.1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
