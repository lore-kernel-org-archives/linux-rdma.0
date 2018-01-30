From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v7 0/8] RDMA resource tracking
Date: Tue, 30 Jan 2018 14:40:42 -0700
Message-ID: <20180130214042.GL17053@ziepe.ca>
References: <034101d399de$01183730$0348a590$@opengridcomputing.com>
 <20180130155643.GC17053@ziepe.ca>
 <035a01d399e5$9ed499d0$dc7dcd70$@opengridcomputing.com>
 <20180130163330.GE17053@ziepe.ca>
 <1517339252.2589.34.camel@wdc.com>
 <20180130194639.GJ17053@ziepe.ca>
 <1517344962.2589.39.camel@wdc.com>
 <20180130204840.GK17053@ziepe.ca>
 <1517347322.2589.58.camel@wdc.com>
 <1517347999.15224.2.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1517347999.15224.2.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 30, 2018 at 04:33:19PM -0500, Laurence Oberman wrote:
> > > Since you didn't report the ib_alloc_mr() print it can't be the
> > > other
> > > ENOMEM case?
> > > 
> > > Hard to see how that interesects with resource tracking.. Are you
> > > thinking memory corruption?
> > 
> > Hello Jason,
> > 
> > I don't see any reason to suspect memory corruption. kmemleak isn't
> > reporting
> > any memory leaks. Maybe memory fragmentation has increased?
> > 
> > Thanks,
> > 
> > Bart
> 
> Hi Bart,
>
> Can I take your tree and see if this fails for me too,
> Your last tree was fine, so did not have this latest stuff.
> Can I just pull to what I have

Try what we are about to send as a PR:

git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git
branch wip/for-linus-merged
https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git/log/?h=wip/for-linus-merged

No guess why a kzalloc will fail. How much is it asking for anyhow?
Did the size get out of control for some reason?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
