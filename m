From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [rdma-next v2 18/23] IB/mlx4: Remove redundant attribute in
 mlx4_ib_create_qp_rss struct
Date: Thu, 24 Aug 2017 15:40:30 -0400
Message-ID: <1503603630.78641.36.camel@redhat.com>
References: <20170815085452.3546-1-leon@kernel.org>
         <20170815085452.3546-19-leon@kernel.org>
         <1503432590.78641.10.camel@redhat.com>
         <20170823044354.GJ1724@mtr-leonro.local>
         <20170824092228.GF1724@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170824092228.GF1724-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-08-24 at 12:22 +0300, Leon Romanovsky wrote:
> On Wed, Aug 23, 2017 at 07:43:54AM +0300, Leon Romanovsky wrote:
> > On Tue, Aug 22, 2017 at 04:09:50PM -0400, Doug Ledford wrote:
> > > On Tue, 2017-08-15 at 11:54 +0300, Leon Romanovsky wrote:
> > > > From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > 
> > > > rss_key_len is not in use and need to be removed.
> > > > 
> > > > Fixes: 3078f5f1bd8b ("IB/mlx4: Add support for RSS QP")
> > > > Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > > ---
> > > >  include/uapi/rdma/mlx4-abi.h | 3 +--
> > > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > > > 
> > > > diff --git a/include/uapi/rdma/mlx4-abi.h
> > > > b/include/uapi/rdma/mlx4-
> > > > abi.h
> > > > index 0e10102861b5..c55f60e05f86 100644
> > > > --- a/include/uapi/rdma/mlx4-abi.h
> > > > +++ b/include/uapi/rdma/mlx4-abi.h
> > > > @@ -98,8 +98,7 @@ struct mlx4_ib_create_srq_resp {
> > > >  struct mlx4_ib_create_qp_rss {
> > > >  	__u64   rx_hash_fields_mask;
> > > >  	__u8    rx_hash_function;
> > > > -	__u8    rx_key_len;
> > > > -	__u8    reserved[6];
> > > > +	__u8    reserved[7];
> > > 
> > > I believe Yuval's point, which has not been fixed, was not that
> > > you
> > > could remove the variable without increasing the reserved
> > > size.  That
> > > makes sense.  He was referring to the fact that you reference
> > > rss_key_len in the commit message, but what you removed was
> > > rx_key_len
> > > instead.
> > 
> > Ahh, I didn't understand it from his comment back then.
> > 
> > How do you want me to proceed here? Do you want me to resend all
> > patches?
> > Do you want me to resend this patch only? Do you prefer to fix it
> > by yourself?
> 
> 
> Doug?

I'll fix it up when I pull the patch in.

> > 
> > It looks like we can declare working with pull-requests in RDMA as
> > a failed
> > experiment.
> > 
> > > 
> > > >  	__u8    rx_hash_key[40];
> > > >  	__u32   comp_mask;
> > > >  	__u32   reserved1;
> > > 
> > > --
> > > Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > >     GPG KeyID: B826A3330E572FDD
> > >     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333
> > > 0E57 2FDD
> > > 
> 
> 
-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
