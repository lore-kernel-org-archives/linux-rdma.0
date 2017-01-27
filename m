From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rdma-core 12 breaks libibverbs ABI
Date: Fri, 27 Jan 2017 01:17:21 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0E1609@ORSMSX109.amr.corp.intel.com>
References: <1485446147.4194.4.camel@profitbricks.com>
 <20170126171325.GA16562@obsidianresearch.com>
 <20170126173548.GA15006@infradead.org>
 <20170126180926.GB20330@obsidianresearch.com>
 <20170126181113.GA8679@infradead.org>
 <20170126202330.GX6005@mtr-leonro.local>
 <1828884A29C6694DAF28B7E6B8A82373AB0E15AD@ORSMSX109.amr.corp.intel.com>
 <20170127010452.GA7826@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170127010452.GA7826-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> - Ship libibverbs.rpm with the updated driver and matched libibverbs
>   This is pretty easy, I probably would recommend this.

This has issues if there are multiple providers present.  Maybe that doesn't happen in non-testing environments.  I wonder if the distros would agree with this approach.

> - QA the driver with the libibverbs in the various targetted distro
>   releases, as you suggested
> - Ship their fix to the distro and have the distro push the update
> 
> It isn't really any different from the problem a vendor would face
> getting the kernel driver updated..

I agree.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
