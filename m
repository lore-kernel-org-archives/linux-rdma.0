From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] i40iw: Add missing NULL check for MPA private data
Date: Tue, 23 Aug 2016 14:10:21 -0500
Message-ID: <20160823191021.GB76544@ssaleem-MOBL4.amr.corp.intel.com>
References: <1471907797-81772-1-git-send-email-shiraz.saleem@intel.com>
 <a4f9a872-74a1-7cf9-93a0-808f4b820fa7@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a4f9a872-74a1-7cf9-93a0-808f4b820fa7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 23, 2016 at 12:47:35PM -0400, Doug Ledford wrote:
> On 8/22/2016 7:16 PM, Shiraz Saleem wrote:
> > Add NULL check for pdata and pdata->addr before the memcpy in
> > i40iw_form_cm_frame(). This fixes a NULL pointer de-reference
> > which occurs when the MPA private data pointer is NULL. Also
> > only copy pdata->size bytes in the memcpy to prevent reading
> > past the length of the private data buffer provided by upper layer.
> > 
> > Fixes: f27b4746f378 ("i40iw: add connection management code")
> > 
> > Reported-by: Stefan Assmann <sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/i40iw/i40iw_cm.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> > index 5026dc7..6434398 100644
> > --- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
> > +++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
> > @@ -535,8 +535,8 @@ static struct i40iw_puda_buf *i40iw_form_cm_frame(struct i40iw_cm_node *cm_node,
> >  		buf += hdr_len;
> >  	}
> >  
> > -	if (pd_len)
> > -		memcpy(buf, pdata->addr, pd_len);
> > +	if (pdata && pdata->addr)
> > +		memcpy(buf, pdata->addr, pdata->size);
> 
> Is there a guarantee that pdata->size is always less than pd_len?  Do
> you need a check here?
> 

pd_len is 'always' greater than or equal to pdata->size. In i40iw_form_cm_frame(), 
pd_len starts out as pdata->size and then may be incremented by 4.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
