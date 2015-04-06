From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 02/19] IB/core: Cache device attributes for use by upper level drivers
Date: Mon, 6 Apr 2015 18:10:44 -0400
Message-ID: <20150406221044.GA433@phlsvsds.ph.intel.com>
References: <1423092585-26692-1-git-send-email-ira.weiny@intel.com> <1423092585-26692-3-git-send-email-ira.weiny@intel.com> <1828884A29C6694DAF28B7E6B8A82373A8FBD574@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FBD574-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Apr 03, 2015 at 02:43:46PM -0600, Hefty, Sean wrote:
> > diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > index 0d74f1d..0116e4b 100644
> > --- a/include/rdma/ib_verbs.h
> > +++ b/include/rdma/ib_verbs.h
> > @@ -1675,6 +1675,7 @@ struct ib_device {
> >  	u32			     local_dma_lkey;
> >  	u8                           node_type;
> >  	u8                           phys_port_cnt;
> > +	struct ib_device_attr        cached_dev_attrs;
> >  };
> 
> Looking at the device attributes, I think all of the values are static for a given device.
>

Yes

> If this is indeed the case, then I would just remove the word 'cached' from the field name.  Cached makes me think of the values dynamically changing, and if that's the case, then this patch isn't sufficient.
> 

I understand your point and I originally called this "attributes" but it was
suggested to call it cached_dev_attrs.

https://www.mail-archive.com/linux-rdma%40vger.kernel.org/msg22486.html

I can change it back if we are all agreed.


Roland?


> Alternatively, if there's only a few values that ULPs need, maybe just store those.

This patch was suggested because there are too many of the flags needed by
ULPs.

A quote from Or:

"I find it very annoying that upper level drivers replicate in different ways
elements from the IB device attributes returned by ib_query_device. I met that
in multiple drivers and upcoming designs for which I do code review. Are you up
to come up with a patch that caches the device attributes on the device
structure? if not, I can do that.. and have your code to see it."

https://www.mail-archive.com/linux-rdma%40vger.kernel.org/msg22011.html

Roland is having such a patch even acceptable or would you prefer to have a
query_device call by each ULP?

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
