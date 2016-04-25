From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Further thoughts on uAPI
Date: Mon, 25 Apr 2016 18:51:59 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB045460@ORSMSX109.amr.corp.intel.com>
References: <20160420012526.GA25508@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0453F5@ORSMSX109.amr.corp.intel.com>
 <20160425183243.GD7675@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160425183243.GD7675-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: OFVWG <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> API wise, yes it is an event channel, however, there must always be an
> FD, so if you want to do something to an event channel, it should be
> done via ioctl on that fd, not through the common fd. So 'get_fd' is
> another form of 'create_object' except that the returned object_handle
> is a fd number not an object id.
> 
> Perhaps 'create_fd_object' instead ?

I think we're pretty much in agreement, just differences in details.

I was thinking that create event channel would return an fd and implicitly define its ioctl format.  Create_fd_object is more generic, but how were you thinking of defining the ioctl format?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
