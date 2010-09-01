From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCHv10 02/12] ib_core: IBoE CMA device binding
Date: Wed, 1 Sep 2010 13:05:57 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25AB3D7AD7@orsmsx501.amr.corp.intel.com>
References: <20100826141723.GC8795@mtldesk30>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25AB26491D@orsmsx501.amr.corp.intel.com>
 <20100827054256.GA9755@mtldesk30> <adavd6w37lp.fsf@cisco.com>
 <20100829143914.GA14370@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100829143914.GA14370@mtldesk30>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The point is it cma_acquire_dev() may get called when
> dev_addr->transport has not yet been set so we can't rely on its value
> to retrieve the correct GID; for example when it gets called by
> rdma_bind_addr() it will only set the transport a few lines down the
> function when calling cma_attach_to_dev(). That's why I may have to
> look for the GID in the IBoE case.
> I agree that traversing the list twice does not look so good so how
> about this:

I dislike the idea of guessing where the GID is when trying to perform these matches.  Is there any chance of getting a false match?

Is there some other approach that anyone can think of for handling this?  Maybe register the netdev HW address with ib_addr or rdma_cm?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
