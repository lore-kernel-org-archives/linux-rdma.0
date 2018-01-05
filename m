From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH, resend 4/4] IB/srp: Add RDMA/CM support
Date: Fri, 5 Jan 2018 10:55:51 -0700
Message-ID: <20180105175551.GZ11348@ziepe.ca>
References: <20180104222842.26756-1-bart.vanassche@wdc.com>
 <20180104222842.26756-5-bart.vanassche@wdc.com>
 <1515172870.3403.11.camel@redhat.com>
 <20180105173448.GY11348@ziepe.ca>
 <1515174677.3254.11.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515174677.3254.11.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 05, 2018 at 05:51:18PM +0000, Bart Van Assche wrote:

> > If yes, then the networking information should be relative to the
> > namespace of the thing that wrote to the sysfs file..
> 
> Login occurs by writing into a sysfs file created by the SRP initiator. How
> about using the networking namespace of the process that writes into that
> sysfs file?

Sounds right to me.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
