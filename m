From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 0/3] RDMA/hns: Bug fixes in hns RoCE driver
Date: Tue, 28 Nov 2017 11:39:10 -0700
Message-ID: <20171128183910.GA21325@ziepe.ca>
References: <1511750484-102395-1-git-send-email-xavier.huwei@huawei.com>
 <20171127183637.GA13966@ziepe.ca>
 <20171128061517.GO29104@mtr-leonro.local>
 <6e9c4251-8e56-54e2-b186-d3d5b1b85204@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6e9c4251-8e56-54e2-b186-d3d5b1b85204@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: Leon Romanovsky <leon@kernel.org>, "Wei Hu (Xavier)" <xavier.huwei@huawei.com>, dledford@redhat.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, xavier.huwei@tom.com, xavier_huwei@163.com, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 28, 2017 at 08:20:09AM -0500, Dennis Dalessandro wrote:
> >
> >If you treat all unmarked patches (without mentioning in cover letter or
> >subject title) as targeted to for-next, it will make your life much more
> >easier than trying to pick each patch alone. As an outcome, it will make
> >the patch flow more predictable for us.

> 
> Agree with Leon here. Unless otherwise stated, I would think for-next should
> always be the default target. I try to tag my subject with for-next or
> for-rc to make it clear.

For Leon and Dennis I know they mark things, but other people seem to
be sending bug fixes that are rc material without any firm indication
one way or the other. I read the patches and that is my main question.

Of course if they do not come in RC acceptable format then they wait
in patchworks until -next is opened.

> Now of course that being said here is an exception. I sent a series 2 weeks
> ago that didn't make Doug's pull request for 4.15. I'd like to see some of
> that stuff land in the rc if there are no objections. The driver changes at
> least, the CM/SA can probably push off to for-next.
 
> I could resubmit just the series, or you could just pick the 4 driver
> patches from patchworks whatever is easiest.

I marked them in patchworks, but can you review the commit messages
and make sure you think Linus will see them as rc material too?

Thanks,
Jason
