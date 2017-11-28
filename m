From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 0/3] RDMA/hns: Bug fixes in hns RoCE driver
Date: Tue, 28 Nov 2017 12:33:11 -0700
Message-ID: <20171128193311.GB21325@ziepe.ca>
References: <1511750484-102395-1-git-send-email-xavier.huwei@huawei.com>
 <20171127183637.GA13966@ziepe.ca>
 <20171128061517.GO29104@mtr-leonro.local>
 <6e9c4251-8e56-54e2-b186-d3d5b1b85204@intel.com>
 <20171128183910.GA21325@ziepe.ca>
 <1511895042.28512.6.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1511895042.28512.6.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dennis.dalessandro@intel.com" <dennis.dalessandro@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "xavier_huwei@163.com" <xavier_huwei@163.com>, "linuxarm@huawei.com" <linuxarm@huawei.com>, "xavier.huwei@huawei.com" <xavier.huwei@huawei.com>, "xavier.huwei@tom.com" <xavier.huwei@tom.com>, "leon@kernel.org" <leon@kernel.org>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 28, 2017 at 06:50:44PM +0000, Bart Van Assche wrote:
> On Tue, 2017-11-28 at 11:39 -0700, Jason Gunthorpe wrote:
> > On Tue, Nov 28, 2017 at 08:20:09AM -0500, Dennis Dalessandro wrote:
> > > I could resubmit just the series, or you could just pick the 4 driver
> > > patches from patchworks whatever is easiest.
> > 
> > I marked them in patchworks, but can you review the commit messages
> > and make sure you think Linus will see them as rc material too?
> 
> My understanding is that the rc stage is intended primarily for fixes for
> bugs introduced during the merge window. For all patches that do not fix
> bugs introduced during the merge window it should be evaluated carefully
> whether or not these are important enough to be included in a rc pull request.

Oh? I thought it was more up to the maintainer discretion within some
limits. Eg I thought we were running rdma more with the 'if it is OK
for -stable, then it is OK -rc' kind of mentality?

eg -rc is for stablization and bugfixing only, and not restricted only
to bugs introduced in the latest merge window??

Have you seen Linus give hard guidance on this topic? I looked for a
bit and found nothing.

I will sync with Doug on this and confirm..

Jason
