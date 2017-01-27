From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rdma-core 12 breaks libibverbs ABI
Date: Fri, 27 Jan 2017 21:16:35 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E3C63C48C@CRSMSX101.amr.corp.intel.com>
References: <1485446147.4194.4.camel@profitbricks.com>
 <20170126171325.GA16562@obsidianresearch.com>
 <20170126173548.GA15006@infradead.org>
 <20170126180926.GB20330@obsidianresearch.com>
 <20170126181113.GA8679@infradead.org>
 <20170126202330.GX6005@mtr-leonro.local>
 <1828884A29C6694DAF28B7E6B8A82373AB0E15AD@ORSMSX109.amr.corp.intel.com>
 <20170127010452.GA7826@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170127010452.GA7826-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> It isn't really any different from the problem a vendor would face getting the
> kernel driver updated..
> 

My concern is that OFA (and the vendors) have not exactly had a good track record of kernel updates in the past.  So I'm not sure that this statement give me a lot of comfort.

That said, I know that most vendors seem to be making a good effort at integrating upstream.  And there is still a mechanism which allows for an external provider.

So I'm not opposed to this.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
