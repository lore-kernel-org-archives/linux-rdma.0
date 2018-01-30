From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next v7 0/8] RDMA resource tracking
Date: Tue, 30 Jan 2018 12:46:39 -0700
Message-ID: <20180130194639.GJ17053@ziepe.ca>
References: <20180128091725.13103-1-leon@kernel.org>
 <20180128210520.GK23869@ziepe.ca>
 <1517256713.27592.241.camel@redhat.com>
 <20180130033436.GA17053@ziepe.ca>
 <20180130091654.GD2055@mtr-leonro.local>
 <034101d399de$01183730$0348a590$@opengridcomputing.com>
 <20180130155643.GC17053@ziepe.ca>
 <035a01d399e5$9ed499d0$dc7dcd70$@opengridcomputing.com>
 <20180130163330.GE17053@ziepe.ca>
 <1517339252.2589.34.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1517339252.2589.34.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 30, 2018 at 07:07:35PM +0000, Bart Van Assche wrote:
> On Tue, 2018-01-30 at 09:33 -0700, Jason Gunthorpe wrote:
> > On Tue, Jan 30, 2018 at 10:16:01AM -0600, Steve Wise wrote:
> > 
> > > What is this a merge of exactly? I don't see the restrack stuff, for
> > > instance.
> > 
> > Yesterday's for-next. You could merge it with the latest for-next..
> > 
> > I updated it.
> > 
> > I think we are done now, so for-next is what will be sent as the
> > pull-request and for-next-merged is the conflict resolution.
> 
> Hello Jason,
> 
> Although I have not yet tried to root-cause this, I want to let you know
> that with your for-linus-merged branch the following error message is
> reported if I try to run the srp-test software against the rdma_rxe driver:
> 
> id_ext=0x505400fffe4a0b7b,ioc_guid=0x505400fffe4a0b7b,dest=192.168.122.76:5555,t
> arget_can_queue=1,queue_size=32,max_cmd_per_lun=32,max_sect=131072 >/sys/class/i
> nfiniband_srp/srp-rxe0-1/add_target failed: Cannot allocate memory
> 
> In the kernel log I found the following:
> 
> Jan 30 10:55:50 ubuntu-vm kernel: scsi host4: ib_srp: FR pool allocation failed (-12)
> 
> With your for-next branch from a few days ago the same test ran fine.

I don't have a guess for you..

The difference between for-next and merged is only the inclusion of
v4.15? Could some v4.15 non-rdma code be causing issue here?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
