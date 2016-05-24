From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC ABI 0/8] Netlink-based IOCTLs RDMA ABI
Date: Tue, 24 May 2016 21:16:24 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0501E2@ORSMSX109.amr.corp.intel.com>
References: <1464100526-31730-1-git-send-email-leonro@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373AB05004F@ORSMSX109.amr.corp.intel.com>
 <20160524210132.GB7950@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160524210132.GB7950-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Ioctl implementations I looked at treated the ioctl buffer as
> > input-output (except for read only or write only ioctl's).  Maybe
> > there's examples of redirecting the response to separate buffer(s)?
> 
> There are examples of this, eg SG_IO uses scatter/gather lists

I did come across a use of sgl's (don't recall where), but I found the documentation so convoluted that I gave up trying to make sense of what it was attempting to do.  :)

SGLs for input or output add complexity, so for myself, I would need to be convinced that adding it to a common framework makes sense.  (SGLs which are part of command data are a separate issue.)  Though to be fair, I find netlink based data to be convoluted...

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
