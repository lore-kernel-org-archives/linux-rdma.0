From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: Launchpad linux-rdma group and rdma-core daily builds
Date: Tue, 7 Nov 2017 08:58:38 -0700
Message-ID: <20171107155838.GE21466@ziepe.ca>
References: <1510062606.32330.13.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510062606.32330.13.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 07, 2017 at 02:50:06PM +0100, Benjamin Drung wrote:

> The package was built successfully for Ubuntu 16.04 (xenial) and newer.
> The build fails for Ubuntu 14.04 (trusty) due to the missing
> libsystemd-dev package.

Yes, to build on trusty a patch to the control file would be needed..

IIRC libsystemd-dev is called something else on trusty.

I am fine not building on trusty.

What can be done if developers join the launchpad group?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
