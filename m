From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: vmw_pvrdma: Add SRQ support - broke rdma-core
Date: Tue, 14 Nov 2017 20:15:26 -0700
Message-ID: <20171115031526.GJ25894@ziepe.ca>
References: <20171114085143.GS18825@mtr-leonro.local>
 <20171114182720.GC18825@mtr-leonro.local>
 <20171114190029.GI18825@mtr-leonro.local>
 <20171114192510.GA6083@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
 <20171114192858.GM4263@ziepe.ca>
 <20171115024924.GA23574@bryantan-devbox.prom.eng.vmware.com.prom.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171115024924.GA23574-qXbCdz4EeRo1jLI2hToXVI42T8aCTgcwy4vvyvUx+exJXi8ZT2ovy+oDBWuYMCC/JZORHMmSJCU@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 06:49:25PM -0800, Bryan Tan wrote:

> Thanks for your suggestion, Jason. I've opened up a new pull request
> that includes the original commit for SRQ support that has been
> reverted, along with the one line change you suggested. Let me know if
> you prefer something different. I've run the travis build on kernels
> both with and without the new ABI header as well.

You should swap the order of the two patches and move the change of
buildlib/fixup-include/rdma-vmw_pvrdma-abi.h to the other patch.

Then the description of the abi.h patch would just be:

'Update rdma-core to the latest kernel pvrdma-abi.h header'

Then everything is more self contained.

You can do this and force push a update to your PR.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
