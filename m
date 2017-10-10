From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/7] IB/srpt: Change default behavior from using SRQ to
 not using SRQ
Date: Tue, 10 Oct 2017 11:04:29 -0600
Message-ID: <20171010170429.GA21288@obsidianresearch.com>
References: <20171006214243.11296-4-bart.vanassche@wdc.com>
 <20171008100317.GR25829@mtr-leonro.local>
 <1507568205.46071.46.camel@redhat.com>
 <1507568492.2674.11.camel@wdc.com>
 <20171010041423.GJ1252@mtr-leonro.local>
 <9443ec1f-0acd-9fa3-4621-a29085d2c606@redhat.com>
 <20171010150018.GC2106@mtr-leonro.local>
 <1507648402.46071.53.camel@redhat.com>
 <20171010154439.GE2106@mtr-leonro.local>
 <1507651473.2815.20.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1507651473.2815.20.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 10, 2017 at 04:04:34PM +0000, Bart Van Assche wrote:
> On Tue, 2017-10-10 at 18:44 +0300, Leon Romanovsky wrote:
> > Bart clearly mentioned disadvantages of XRQ and left me wonder why user
> > needs to enable it anyway. This is what I'm asking and this is what I'm
> > hoping to see in the commit message.
> 
> I assume that you meant SRQ instead of XRQ? For HCA's that support SRQ a
> choice has to be made between the lower memory usage of SRQ or the higher
> performance of RC. I think only the user can make that choice. Hence the
> new kernel module parameter.

considering our general dislike of module parameters, could you
achieve this via some communicationfrom srp_daemon instead?

Perhaps even on a per target basis?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
