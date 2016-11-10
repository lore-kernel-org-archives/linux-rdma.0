From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/7] libhns: Add initial main frame
Date: Thu, 10 Nov 2016 10:30:29 -0700
Message-ID: <20161110173029.GA29687@obsidianresearch.com>
References: <1477487048-62256-2-git-send-email-oulijun@huawei.com>
 <20161026162053.GE24898@obsidianresearch.com>
 <5811776F.20908@huawei.com>
 <20161027145139.GD6818@obsidianresearch.com>
 <58130573.4010902@huawei.com>
 <20161028164030.GA17289@obsidianresearch.com>
 <5813F869.7010606@huawei.com>
 <20161107231532.GB7002@obsidianresearch.com>
 <20161108125441.GB27883@leon.nu>
 <58232047.4060709@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <58232047.4060709-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 09, 2016 at 09:10:31PM +0800, oulijun wrote:
> ??? 2016/11/8 20:54, Leon Romanovsky ??????:
> > On Mon, Nov 07, 2016 at 04:15:32PM -0700, Jason Gunthorpe wrote:
> >> On Sat, Oct 29, 2016 at 09:16:25AM +0800, oulijun wrote:
> >>
> >>> We hope that the only one userspace library file named
> >>> libhns-rdmav2.so will be used for the different hardware
> >>> version(hip06, hip07, ...), because there are only little change
> >>> between their userspace drivers. So we need to distinguish hardware
> >>> version.
> >>
> >> I guess that makes sense, but you still need to be able to parse dt
> >> compatible strings that are lists.
> > 
> > IMHO, it can be easily done as follow up patches.
> > 
> Hi, Leon & Jason
>    We hope that the only one userspace library file named libhns-rdmav2.so will be used for the different hardware version(hip06, hip07, ...),
> because there are only little change between their userspace drivers. So we need to distinguish hardware version.
> We can't distinguish them if only matching driver name "hns_roce".

That is fine..

> 	if (ibv_read_sysfs_file(uverbs_sys_path, "device/of_node/compatible",
> 				value, sizeof(value)) > 0)
> 		for (i = 0; i < sizeof(dt_table) / sizeof(dt_table[0]); ++i)
> 			if (!strcmp(value, dt_table[i].compatible)) {

This isn't right, compatible can be a list, if I recall it is a null
separated list of names, you need to parse the list.

Again, it would much better to just parse modalias directly, and
better still to add some core libiverbs code to do that for all
drivers.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
