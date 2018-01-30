From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v7 0/8] RDMA resource tracking
Date: Tue, 30 Jan 2018 14:42:27 -0700
Message-ID: <20180130214227.GM17053@ziepe.ca>
References: <20180130155643.GC17053@ziepe.ca>
 <035a01d399e5$9ed499d0$dc7dcd70$@opengridcomputing.com>
 <20180130163330.GE17053@ziepe.ca>
 <1517339252.2589.34.camel@wdc.com>
 <20180130194639.GJ17053@ziepe.ca>
 <1517344962.2589.39.camel@wdc.com>
 <20180130204840.GK17053@ziepe.ca>
 <1517347322.2589.58.camel@wdc.com>
 <1517347999.15224.2.camel@redhat.com>
 <1517348412.2589.60.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1517348412.2589.60.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 30, 2018 at 09:40:14PM +0000, Bart Van Assche wrote:
> On Tue, 2018-01-30 at 16:33 -0500, Laurence Oberman wrote:
> > Can I take your tree and see if this fails for me too,
> > Your last tree was fine, so did not have this latest stuff.
> > Can I just pull to what I have
> 
> Hello Laurence,
> 
> So far I have seen this behavior only inside a VM but not yet on a system
> with more memory than the VM. This issue may be specific to the memory size
> of the VM. I think we should try to isolate furhter what caused this before
> trying to reproduce it on more setups.

Did you get an oops print related a kalloc failure?

Or am I wrong and the ENOMEM is coming from someplace else?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
