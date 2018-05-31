From: Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH] iw_cxgb4: add INFINIBAND_ADDR_TRANS dependency
Date: Wed, 30 May 2018 21:03:41 -0700
Message-ID: <CAHH2K0ZLDmsPNw=sOobL=+R54yRFrnG4syWcW43UEbwxsvFehw@mail.gmail.com>
References: <20180530215826.1343234-1-arnd@arndb.de> <20180530220405.GH30754@ziepe.ca>
 <0be4e0fb-8d8e-b337-fc8d-550c90829d8c@opengridcomputing.com>
 <20180530222520.GJ30754@ziepe.ca> <d2472443-3ae6-63f4-59ad-d6367b837038@opengridcomputing.com>
 <CAK8P3a3HZXTR60ua=cjBHnB5FWWKve9F-JqcNwn0ujks+=FsNg@mail.gmail.com> <20180530230136.GK30754@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180530230136.GK30754@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Arnd Bergmann <arnd@arndb.de>, swise@opengridcomputing.com, swise@chelsio.com, Doug Ledford <dledford@redhat.com>, yuval.shaia@oracle.com, linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Tarick Bedeir <tarick@google.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 30, 2018 at 4:01 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Thu, May 31, 2018 at 12:40:54AM +0200, Arnd Bergmann wrote:
> > > On 5/30/2018 5:25 PM, Jason Gunthorpe wrote:
> > >> On Wed, May 30, 2018 at 05:10:35PM -0500, Steve Wise wrote:
> > >>>
> > >>> On 5/30/2018 5:04 PM, Jason Gunthorpe wrote:
> > >>>> On Wed, May 30, 2018 at 11:58:18PM +0200, Arnd Bergmann wrote:
> > >>>>> The newly added fill_res_ep_entry function fails to link if
> > >>>>> CONFIG_INFINIBAND_ADDR_TRANS is not set:
> > >>>>>
> > >>>>> drivers/infiniband/hw/cxgb4/restrack.o: In function
`fill_res_ep_entry':
> > >>>>> restrack.c:(.text+0x3cc): undefined reference to `rdma_res_to_id'
> > >>>>> restrack.c:(.text+0x3d0): undefined reference to `rdma_iw_cm_id'
> > >>>>>
> > >>>>> This adds a Kconfig dependency for the driver.
> > >>>>>
> > >>>>> Fixes: 116aeb887371 ("iw_cxgb4: provide detailed
provider-specific CM_ID information")
> > >>>>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > >>>>>  drivers/infiniband/hw/cxgb4/Kconfig | 1 +
> > >>>>>  1 file changed, 1 insertion(+)
> > >>>> Oh, I think we need to solve this with maybe a header fill null
stub
> > >>>> instead..
> > >>>>
> > >>>> We don't want to disable drivers just because a user interface is
> > >>>> disabled.
> > >>>>
> > >>> Why does CONFIG_INFINIBAND_ADDR_TRANS disable building rdma_cm.ko?
That
> > >>> is not correct.
> > >> That seems like a reasonable thing to do..
> > > rdma_ucm.ko is for usermode users, rdma_cm.ko is for kernel users, and
> > > is required for iwarp drivers.  It seems rdma_cm.ko is not being
> > > compiled if ADDR_TRANS is not set.

> I think the intention was to completely disable rdma-cm, including all
> support for rx'ing remote packets? Greg?

Yes.  That's my goal when INFINIBAND_ADDR_TRANS is unset.

> If this is required for iwarp then Arnd's patch is probably the right
> way to go..

> Jason

Agreed.
Acked-by: Greg Thelen <gthelen@google.com>
