From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] libmlx5: add support for the s390x platform
Date: Wed, 13 Sep 2017 12:19:30 -0600
Message-ID: <20170913181930.GC1536@obsidianresearch.com>
References: <20170906133620.58716-1-kmeesomp@linux.vnet.ibm.com>
 <20170906141500.GJ18084@mtr-leonro.local>
 <20170906152208.GB6262@obsidianresearch.com>
 <0c2d33a4-c9b1-a20d-b113-502288eae525@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0c2d33a4-c9b1-a20d-b113-502288eae525-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kittipon Meesompop <kmeesomp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 13, 2017 at 02:55:01PM +0200, Kittipon Meesompop wrote:

> Thanks for your info; we should have listened better to linux-rdma. That
> means my sent libmlx5 patch is not needed anymore. I now have run dapltest
> with your rdma-core provided libraries libmlx4.so,1.0.15 and
> libmlx5.so.1.2.15 on an IBM internally built driver for s390.
> libmlx5 results with and without vlan interfaces look good, libmlx4 results
> look good for non-vlan interfaces. Analysis of the libmlx4 failure for
> vlan-interfaces is ongoing; it might just be a driver issue.

Okay, thanks! That is good to hear.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
