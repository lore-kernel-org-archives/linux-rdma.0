From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 06/31] IB/ipoib: Avoid memory leak if neigh
 destination was changed
Date: Wed, 15 Nov 2017 08:39:46 -0700
Message-ID: <20171115153946.GP25894@ziepe.ca>
References: <20171114125218.20477-1-leon@kernel.org>
 <20171114125218.20477-7-leon@kernel.org>
 <20171115001510.GG25894@ziepe.ca>
 <CAAk-MO-QQj3_H2CZuCCOCU51tWwdCfkvhh-Q3LqrKM=Su2Q+Kg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAk-MO-QQj3_H2CZuCCOCU51tWwdCfkvhh-Q3LqrKM=Su2Q+Kg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 15, 2017 at 09:01:07AM +0200, Erez Shitrit wrote:
> >>       if (!IS_ERR_OR_NULL(ah)) {
> >> +             /* check there is no mismatch from the request */
> >> +             if (memcmp(pathrec->dgid.raw, path->pathrec.dgid.raw,
> >> +                        sizeof(union ib_gid))) {
> >> +                     pr_warn("%s got PathRec for gid %pI6 while asked for %pI6\n",
> >> +                             dev->name, pathrec->dgid.raw, path->pathrec.dgid.raw);
> >> +                     /* overwrite the response from the sm  before copy to the db */
> >> +                     memcpy(pathrec->dgid.raw, path->pathrec.dgid.raw,
> >> +                            sizeof(union ib_gid));
> >
> > This doesn't seem like it should be a warning, and replacing the
> > good DGID from the SA with local garbage seems really wrong.
> 
> IPoIB is L2 driver and should act as a pipe and cannot add its opinion
> about what is a good or a garbage GID.

Which is why ipoib should not override the result from the SA.

It needs to work in a way where it looks up a DGID from the LLADDR and
gets back a wire GRH and LRH which come from SA.

> If the host is asking for specific mac address, IPoIB should return
> the response for the original request/mac and should not decide what
> is good for the host.

No, it is up to the SA to return the GRH to put in the packets, it
should never be changed in any way by a ULP.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
