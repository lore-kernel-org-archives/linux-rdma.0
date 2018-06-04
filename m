From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] iw_cxgb4: add INFINIBAND_ADDR_TRANS dependency
Date: Mon, 4 Jun 2018 17:07:45 -0600
Message-ID: <20180604230745.GG24926@ziepe.ca>
References: <20180530215826.1343234-1-arnd@arndb.de>
 <20180530220405.GH30754@ziepe.ca>
 <0be4e0fb-8d8e-b337-fc8d-550c90829d8c@opengridcomputing.com>
 <20180530222520.GJ30754@ziepe.ca>
 <d2472443-3ae6-63f4-59ad-d6367b837038@opengridcomputing.com>
 <CAK8P3a3HZXTR60ua=cjBHnB5FWWKve9F-JqcNwn0ujks+=FsNg@mail.gmail.com>
 <20180530230136.GK30754@ziepe.ca>
 <CAHH2K0ZLDmsPNw=sOobL=+R54yRFrnG4syWcW43UEbwxsvFehw@mail.gmail.com>
 <d23e215a30f1277c941973043262cdfc60c71315.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d23e215a30f1277c941973043262cdfc60c71315.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Greg Thelen <gthelen@google.com>, Arnd Bergmann <arnd@arndb.de>, swise@opengridcomputing.com, swise@chelsio.com, yuval.shaia@oracle.com, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Tarick Bedeir <tarick@google.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 31, 2018 at 02:40:59PM -0400, Doug Ledford wrote:
> On Wed, 2018-05-30 at 21:03 -0700, Greg Thelen wrote:
> > On Wed, May 30, 2018 at 4:01 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > 
> > > On Thu, May 31, 2018 at 12:40:54AM +0200, Arnd Bergmann wrote:
> > > > > On 5/30/2018 5:25 PM, Jason Gunthorpe wrote:
> > > > > > On Wed, May 30, 2018 at 05:10:35PM -0500, Steve Wise wrote:
> > > > > > > 
> > > > > > > On 5/30/2018 5:04 PM, Jason Gunthorpe wrote:
> > > > > > > > On Wed, May 30, 2018 at 11:58:18PM +0200, Arnd Bergmann wrote:
> > > > > > > > > The newly added fill_res_ep_entry function fails to link if
> > > > > > > > > CONFIG_INFINIBAND_ADDR_TRANS is not set:
> > > > > > > > > 
> > > > > > > > > drivers/infiniband/hw/cxgb4/restrack.o: In function
> > 
> > `fill_res_ep_entry':
> > > > > > > > > restrack.c:(.text+0x3cc): undefined reference to `rdma_res_to_id'
> > > > > > > > > restrack.c:(.text+0x3d0): undefined reference to `rdma_iw_cm_id'
> > > > > > > > > 
> > > > > > > > > This adds a Kconfig dependency for the driver.
> > > > > > > > > 
> > > > > > > > > Fixes: 116aeb887371 ("iw_cxgb4: provide detailed
> > 
> > provider-specific CM_ID information")
> > > > > > > > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > > > > > > >  drivers/infiniband/hw/cxgb4/Kconfig | 1 +
> > > > > > > > >  1 file changed, 1 insertion(+)
> > > > > > > > 
> > > > > > > > Oh, I think we need to solve this with maybe a header fill null
> > 
> > stub
> > > > > > > > instead..
> > > > > > > > 
> > > > > > > > We don't want to disable drivers just because a user interface is
> > > > > > > > disabled.
> > > > > > > > 
> > > > > > > 
> > > > > > > Why does CONFIG_INFINIBAND_ADDR_TRANS disable building rdma_cm.ko?
> > 
> > That
> > > > > > > is not correct.
> > > > > > 
> > > > > > That seems like a reasonable thing to do..
> > > > > 
> > > > > rdma_ucm.ko is for usermode users, rdma_cm.ko is for kernel users, and
> > > > > is required for iwarp drivers.  It seems rdma_cm.ko is not being
> > > > > compiled if ADDR_TRANS is not set.
> > > I think the intention was to completely disable rdma-cm, including all
> > > support for rx'ing remote packets? Greg?
> > 
> > Yes.  That's my goal when INFINIBAND_ADDR_TRANS is unset.
> > 
> > > If this is required for iwarp then Arnd's patch is probably the right
> > > way to go..
> > > Jason
> > 
> > Agreed.
> > Acked-by: Greg Thelen <gthelen@google.com>
> 
> If that's the case, then there should be a NOTE: in the Kconfig that
> disabling the connection manager completely disables iWARP hardware.
> 
> I don't really think I like this approach though.  At a minimum if you
> are going to make iWARP totally dependent on rdmacm, then there is zero
> reason that iw_cm.o should be part of the obj-$(CONFIG_INFINIBAND)
> Makefile recipe when ADDR_TRANS is disabled.

This makes sense, Greg, can you send a followup patch with these
items? I know this series has been tough..

Thanks,
Jason
