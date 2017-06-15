From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] rdma: copy the saddr if it is already resolved
Date: Thu, 15 Jun 2017 15:46:10 -0400
Message-ID: <1497555970.7171.298.camel@redhat.com>
References: <20170609104925.28927-1-rajur@chelsio.com>
         <1497468245.7171.260.camel@redhat.com>
         <CAANLjFo=VOhUSb494rskZ38fHn=xSUYPi+XL4Vuu0R1Y0czmSQ@mail.gmail.com>
         <1497485577.7171.273.camel@redhat.com>
         <CAANLjFo2GXw8kTXDO87k9oaER5PxXZTb0JAV3qHqRz8aHxA7FA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFo2GXw8kTXDO87k9oaER5PxXZTb0JAV3qHqRz8aHxA7FA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-06-15 at 09:20 -0600, Robert LeBlanc wrote:
> On Wed, Jun 14, 2017 at 6:12 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> wrote:
> > 
> > On Wed, 2017-06-14 at 16:28 -0600, Robert LeBlanc wrote:
> > > 
> > > Doug,
> > > 
> > > I've run into this with 4.9.30. The aforementioned patch fixes it
> > > in
> > > the 4.9 series, but also requires 24b43c996 as well. Can we get
> > > this
> > > fix into stable. If needed you can add me as tested-by.
> > > 
> > > Tested-by: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
> > 
> > While I don't doubt that this fixed the problem, the patch from
> > Roland
> > Drier looks more correct to me.  As I've already taken Roland's
> > patch,
> > and it is Cc:ed for stable, it should be resolved already.  I just
> > need
> > Raju to confirm this for me.
> 
> Sorry, I meant to say that I tested Roland's patch and it fixes the
> issue for us. Thanks for getting this sent to stable.

I've added a git notes entry for your testing.  Thanks.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
