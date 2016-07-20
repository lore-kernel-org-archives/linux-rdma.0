From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI V2 2/8] RDMA/core: Refactor IDR to be per-device
Date: Wed, 20 Jul 2016 11:08:46 -0600
Message-ID: <20160720170846.GF21460@obsidianresearch.com>
References: <1468941812-32286-1-git-send-email-matanb@mellanox.com>
 <1468941812-32286-3-git-send-email-matanb@mellanox.com>
 <alpine.DEB.2.20.1607192014010.5828@east.gentwo.org>
 <20160720032037.GR20674@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160720032037.GR20674-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 20, 2016 at 06:20:37AM +0300, Leon Romanovsky wrote:
> > > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > > index 432bed5..14bfe3b 100644
> > > +++ b/include/rdma/ib_verbs.h
> > > @@ -1706,6 +1706,10 @@ struct ib_device {
> > >
> > >  	struct iw_cm_verbs	     *iwcm;
> > >
> > > +	struct idr		idr;
> > > +	/* Global lock in use to safely release device IDR */
> > > +	spinlock_t		idr_lock;
> > 
> > Global? In what sense? This is a lock for the idrs for the particular
> > device right? The comment is a bit confusing. Maybe better remove it?
> 
> I'll fix it and will remove "global" word from the comment.
> It should be /* Lock in use to safety release device IDR */. I
> prefer to

That doesn't seem to be the right comment either.

+	spin_lock(&uobj->context->device->idr_lock);
+	ret = idr_alloc(&uobj->context->device->idr, uobj, 0, 0, GFP_NOWAIT);
+	spin_unlock(&uobj->context->device->idr_lock);

idr_lock appears to just be the standard spinlock protecting an IDR.

If it being re-used for something about device removal then that is
probably wrong....

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
