From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 4/4] IB/sa: Route SA pathrecord query through netlink
Date: Thu, 11 Jun 2015 16:08:05 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E1109B94A@CRSMSX101.amr.corp.intel.com>
References: <1433861837-26177-1-git-send-email-kaike.wan@intel.com>
 <1433861837-26177-5-git-send-email-kaike.wan@intel.com>
 <55787838.3020606@dev.mellanox.co.il>
 <20150610191026.GA28334@obsidianresearch.com>
 <5578955A.4070001@dev.mellanox.co.il>
 <2807E5FD2F6FDA4886F6618EAC48510E1109B14D@CRSMSX101.amr.corp.intel.com>
 <55797DF3.6050304@dev.mellanox.co.il>
 <3F128C9216C9B84BB6ED23EF16290AFB0CABD089@CRSMSX101.amr.corp.intel.com>
 <55798C31.5090600@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55798C31.5090600-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >> If user space PR capabilities (unicast, multicast, both) is
> >> supported, it affects the API.
> > How? If we can query SA for multicast PRs without joining the
> > multicast groups, what additional changes in netlink API do we need to
> support both?
> 
> Nothing to support both but if we wanted to disable one or other based on user
> space we would but it sounds like we don't need/want this but would use user
> space rejection/no data for this.
> 

Yes I think we should allow userspace to decide if this is supported or not.  That allows for more flexibility.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
