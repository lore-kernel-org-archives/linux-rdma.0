From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH 0/3] RDMA/hns: Bug fixes in hns RoCE driver
Date: Tue, 28 Nov 2017 08:20:09 -0500
Message-ID: <6e9c4251-8e56-54e2-b186-d3d5b1b85204@intel.com>
References: <1511750484-102395-1-git-send-email-xavier.huwei@huawei.com>
 <20171127183637.GA13966@ziepe.ca> <20171128061517.GO29104@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171128061517.GO29104@mtr-leonro.local>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>, dledford@redhat.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, xavier.huwei@tom.com, xavier_huwei@163.com, linuxarm@huawei.com
List-Id: linux-rdma@vger.kernel.org

On 11/28/2017 1:15 AM, Leon Romanovsky wrote:
> On Mon, Nov 27, 2017 at 11:36:37AM -0700, Jason Gunthorpe wrote:
>> On Mon, Nov 27, 2017 at 10:41:21AM +0800, Wei Hu (Xavier) wrote:
>>> This patch-set introduces three patches to fix about the memory
>>> related issues.
>>
>> If these patches are for-rc can you revise the commit message to more
>> clearly explain what the bug is, and supply Fixes lines?
>>
>> Otherwise these will go to 4.16
> 
> Jason,
> 
> If you treat all unmarked patches (without mentioning in cover letter or
> subject title) as targeted to for-next, it will make your life much more
> easier than trying to pick each patch alone. As an outcome, it will make
> the patch flow more predictable for us.
> 
> Thanks
> 

Agree with Leon here. Unless otherwise stated, I would think for-next 
should always be the default target. I try to tag my subject with 
for-next or for-rc to make it clear.

Now of course that being said here is an exception. I sent a series 2 
weeks ago that didn't make Doug's pull request for 4.15. I'd like to see 
some of that stuff land in the rc if there are no objections. The driver 
changes at least, the CM/SA can probably push off to for-next.

I could resubmit just the series, or you could just pick the 4 driver 
patches from patchworks whatever is easiest.

-Denny
