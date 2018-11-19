From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [RFCv3 PATCH 1/6] uacce: Add documents for WarpDrive/uacce
Date: Mon, 19 Nov 2018 13:42:16 -0500
Message-ID: <20181119184215.GB4593@redhat.com>
References: <20181113002354.GO3695@mtr-leonro.mtl.com>
 <95310df4-b32c-42f0-c750-3ad5eb89b3dd@gmail.com>
 <20181114160017.GI3759@mtr-leonro.mtl.com>
 <20181115085109.GD157308@Turing-Arch-b>
 <20181115145455.GN3759@mtr-leonro.mtl.com>
 <20181119091405.GE157308@Turing-Arch-b>
 <20181119091910.GF157308@Turing-Arch-b>
 <20181119104801.GF8268@mtr-leonro.mtl.com>
 <20181119164853.GA4593@redhat.com>
 <20181119182752.GA4890@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181119182752.GA4890@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, Kenneth Lee <liguozhu@hisilicon.com>, Tim Sell <timothy.sell@unisys.com>, linux-doc@vger.kernel.org, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Zaibo Xu <xuzaibo@huawei.com>, zhangfei.gao@foxmail.com, linuxarm@huawei.com, haojian.zhuang@linaro.org, Christoph Lameter <cl@linux.com>, Hao Fang <fanghao11@huawei.com>, Gavin Schenk <g.schenk@eckelmann.de>, RDMA mailing list <linux-rdma@vger.kernel.org>, Zhou Wang <wangzhou1@hisilicon.com>, Doug Ledford <dledford@redhat.com>, Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>, David Kershner <david.kershner@unisys.com>, Kenneth Lee <nek.in.cn@gmail.com>, Johan Hovold <johan@kernel.org>, Cyrille Pitchen <cyrille.pitchen@free-electrons.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 19, 2018 at 11:27:52AM -0700, Jason Gunthorpe wrote:
> On Mon, Nov 19, 2018 at 11:48:54AM -0500, Jerome Glisse wrote:
> 
> > Just to comment on this, any infiniband driver which use umem and do
> > not have ODP (here ODP for me means listening to mmu notifier so all
> > infiniband driver except mlx5) will be affected by same issue AFAICT.
> > 
> > AFAICT there is no special thing happening after fork() inside any of
> > those driver. So if parent create a umem mr before fork() and program
> > hardware with it then after fork() the parent might start using new
> > page for the umem range while the old memory is use by the child. The
> > reverse is also true (parent using old memory and child new memory)
> > bottom line you can not predict which memory the child or the parent
> > will use for the range after fork().
> > 
> > So no matter what you consider the child or the parent, what the hw
> > will use for the mr is unlikely to match what the CPU use for the
> > same virtual address. In other word:
> > 
> > Before fork:
> >     CPU parent: virtual addr ptr1 -> physical address = 0xCAFE
> >     HARDWARE:   virtual addr ptr1 -> physical address = 0xCAFE
> > 
> > Case 1:
> >     CPU parent: virtual addr ptr1 -> physical address = 0xCAFE
> >     CPU child:  virtual addr ptr1 -> physical address = 0xDEAD
> >     HARDWARE:   virtual addr ptr1 -> physical address = 0xCAFE
> > 
> > Case 2:
> >     CPU parent: virtual addr ptr1 -> physical address = 0xBEEF
> >     CPU child:  virtual addr ptr1 -> physical address = 0xCAFE
> >     HARDWARE:   virtual addr ptr1 -> physical address = 0xCAFE
> 
> IIRC this is solved in IB by automatically calling
> madvise(MADV_DONTFORK) before creating the MR.
> 
> MADV_DONTFORK
>   .. This is useful to prevent copy-on-write semantics from changing the
>   physical location of a page if the parent writes to it after a
>   fork(2) ..

This would work around the issue but this is not transparent ie
range marked with DONTFORK no longer behave as expected from the
application point of view.

Also it relies on userspace doing the right thing (which is not
something i usualy trust :)).

Cheers,
Jérôme
