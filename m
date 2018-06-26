From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH for-rc 0/3]
Date: Tue, 26 Jun 2018 11:20:12 -0400
Message-ID: <98d77608-5b8d-3a2f-7721-9c3e176d4f0e@intel.com>
References: <20180620162612.13582.28777.stgit@scvm10.sc.intel.com>
 <20180620184323.GD27445@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180620184323.GD27445@ziepe.ca>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: dledford@redhat.com, Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, stable@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Dan Carpenter <dan.carpenter@oracle.com>, Kamenee Arumugam <kamenee.arumugam@intel.com>
List-Id: linux-rdma@vger.kernel.org

On 6/20/2018 2:43 PM, Jason Gunthorpe wrote:
> On Wed, Jun 20, 2018 at 09:28:39AM -0700, Dennis Dalessandro wrote:
>> Hi Doug and Jason,
>>
>> Here are a couple patches that we'd like to get into 4.18 rc cycle. These fix
>> bugs and aren't too complex. One of them is an issue that Dan Carpenter just
>> reported recently and is marked for stable.
> 
> All of these need Fixes lines for-rc and other than the last one the
> commit messages are not good enough - talk about what user visible
> effect this bug has.

I talked to Mike and we are good with pushing the first two off till 
for-next. We'll make some commit message improvements and send a v2 for 
those.

The last one we still want for -rc. I replied to the patch with a fixes 
line, I think patchworks will append it for you won't it?

-Denny
