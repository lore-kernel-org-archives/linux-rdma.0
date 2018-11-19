From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFCv3 PATCH 1/6] uacce: Add documents for WarpDrive/uacce
Date: Mon, 19 Nov 2018 13:11:56 -0700
Message-ID: <20181119201156.GG4890@ziepe.ca>
References: <20181119091405.GE157308@Turing-Arch-b>
 <20181119091910.GF157308@Turing-Arch-b>
 <20181119104801.GF8268@mtr-leonro.mtl.com>
 <20181119164853.GA4593@redhat.com>
 <20181119182752.GA4890@ziepe.ca>
 <20181119184215.GB4593@redhat.com>
 <20181119185333.GC4890@ziepe.ca>
 <20181119191721.GC4593@redhat.com>
 <20181119192702.GD4890@ziepe.ca>
 <20181119194631.GE4593@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181119194631.GE4593@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jerome Glisse <jglisse@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>, Kenneth Lee <liguozhu@hisilicon.com>, Tim Sell <timothy.sell@unisys.com>, linux-doc@vger.kernel.org, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Zaibo Xu <xuzaibo@huawei.com>, zhangfei.gao@foxmail.com, linuxarm@huawei.com, haojian.zhuang@linaro.org, Christoph Lameter <cl@linux.com>, Hao Fang <fanghao11@huawei.com>, Gavin Schenk <g.schenk@eckelmann.de>, RDMA mailing list <linux-rdma@vger.kernel.org>, Zhou Wang <wangzhou1@hisilicon.com>, Doug Ledford <dledford@redhat.com>, Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, David Kershner <david.kershner@unisys.com>, Kenneth Lee <nek.in.cn@gmail.com>, Johan Hovold <johan@kernel.org>, Cyrille Pitchen <cyrille.pitchen@free-electrons.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 19, 2018 at 02:46:32PM -0500, Jerome Glisse wrote:

> > ?? How can O_DIRECT be fine but RDMA not? They use exactly the same
> > get_user_pages flow, right? Can we do what O_DIRECT does in RDMA and
> > be fine too?
> > 
> > AFAIK the only difference is the length of the race window. You'd have
> > to fork and fault during the shorter time O_DIRECT has get_user_pages
> > open.
> 
> Well in O_DIRECT case there is only one page table, the CPU
> page table and it gets updated during fork() so there is an
> ordering there and the race window is small.

Not really, in O_DIRECT case there is another 'page table', we just
call it a DMA scatter/gather list and it is sent directly to the block
device's DMA HW. The sgl plays exactly the same role as the various HW
page list data structures that underly RDMA MRs.

It is not a page table that matters here, it is if the DMA address of
the page is active for DMA on HW.

Like you say, the only difference is that the race is hopefully small
with O_DIRECT (though that is not really small, NVMeof for instance
has windows as large as connection timeouts, if you try hard enough)

So we probably can trigger this trouble with O_DIRECT and fork(), and
I would call it a bug :(

> > Why? Keep track in each mm if there are any active get_user_pages
> > FOLL_WRITE pages in the mm, if yes then sweep the VMAs and fix the
> > issue for the FOLL_WRITE pages.
> 
> This has a cost and you don't want to do it for O_DIRECT. I am pretty
> sure that any such patch to modify fork() code path would be rejected.
> At least i would not like it and vote against.

I was thinking the incremental cost on top of what John is already
doing would be very small in the common case and only be triggered in
cases that matter (which apps should avoid anyhow).

Jason
