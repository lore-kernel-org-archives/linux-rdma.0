From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: vmw_pvrdma: Add SRQ support - broke rdma-core
Date: Fri, 17 Nov 2017 16:37:21 -0700
Message-ID: <20171117233721.GV4276@ziepe.ca>
References: <20171114085143.GS18825@mtr-leonro.local>
 <20171114182720.GC18825@mtr-leonro.local>
 <20171114190029.GI18825@mtr-leonro.local>
 <20171114192510.GA6083@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171114192858.GM4263@ziepe.ca>
 <20171115024924.GA23574@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171115031526.GJ25894@ziepe.ca>
 <20171115221052.GA16946@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171116052119.GF18825@mtr-leonro.local>
 <20171116185450.GB16946@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171116185450.GB16946-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 16, 2017 at 10:54:51AM -0800, Bryan Tan wrote:

> I've updated the PR after taking in Jason's suggestion of swapping the
> order of the patches that I missed, and ran travis builds on both
> commits. The travis build on the PR is failing, but it looks like the
> top of tree travis build is failing as well.

Please move the test update to the prior patch, I left a note on
github to be clear.

Travis should be fixed right away.

Please force push the change and we should be able to merge it!

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
