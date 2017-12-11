From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH 6/8] verbs: Fill in the libibverbs.map file
Date: Mon, 11 Dec 2017 13:25:38 -0700
Message-ID: <20171211202538.GE27709@ziepe.ca>
References: <20171205231721.19410-1-jgg@ziepe.ca>
 <20171205231721.19410-7-jgg@ziepe.ca>
 <38cbce8e-d177-b4eb-efec-c54951b1cb29@dev.mellanox.co.il>
 <20171211154811.GA6162@ziepe.ca>
 <56bb7926-5179-376d-a353-3d02fbd3b463@dev.mellanox.co.il>
 <20171211162714.GB27709@ziepe.ca>
 <a72997ae-4516-9819-c3a0-c042f8baa9da@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a72997ae-4516-9819-c3a0-c042f8baa9da-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 11, 2017 at 07:59:43PM +0200, Yishai Hadas wrote:
> On 12/11/2017 6:27 PM, Jason Gunthorpe wrote:
> >On Mon, Dec 11, 2017 at 06:22:37PM +0200, Yishai Hadas wrote:
> >>On 12/11/2017 5:48 PM, Jason Gunthorpe wrote:
> >>You have added the extra symbols under 'IBVERBS_1.1', but this section
> >>already includes 'IBVERBS_1.0' at part of its definition in the map
> >>file.
> >
> >Each section only defines the smybols for a single symbol version.
> >
> >>For example 'ibv_destroy_srq' now appears twice in both 1.0 and 1.1.
> >
> >Correct - ibv_destroy_srq has two symbols and must appear twice in the
> >map file:
> >
> >debian/libibverbs1.symbols: ibv_destroy_srq@IBVERBS_1.0 1.1.6
> >debian/libibverbs1.symbols: ibv_destroy_srq@IBVERBS_1.1 1.1.6
> >
> >libibverbs/compat-1_0.c:COMPAT_SYMVER_FUNC(ibv_destroy_srq, 1_0, "IBVERBS_1.0",
> >libibverbs/verbs.c:LATEST_SYMVER_FUNC(ibv_destroy_srq, 1_1, "IBVERBS_1.1",
> >
> >>Why current map file is not well-defined without this patch ?
> >
> >Every stanza should list every symobl defined for the varsion.
> >
> 
> Agree, so this patch comes to improve/fix the original patch [1] from 2007
> which introduced 'IBVERBS_1.1' and relied on the linker with the symvers
> mechanism, correct ?
> commit fd448acccecab2740b7f35f1fadc64fae6d6b9d3

Yes.. that commit has a mixture of doing some right (eg
ibv_get_device_list) and doing some wrong (eg ibv_attach_mcast)

However this isn't a Fixes for that, since it fixes a whole range of
commits changing the export list..

Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
