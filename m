From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH for-next 00/13] IB/hfi1,core: Driver updates for 4.17
Date: Wed, 4 Apr 2018 23:33:02 -0400
Message-ID: <080bb43b-86bc-6943-81a2-93c8808b41a0@intel.com>
References: <20180405025915.18766.41569.stgit@scvm10.sc.intel.com>
 <20180405030916.GD29229@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180405030916.GD29229@ziepe.ca>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: dledford@redhat.com, Mike Mariciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, Mitko Haralanov <mitko.haralanov@intel.com>, Brian Welty <brian.welty@intel.com>, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org, Ashutosh Dixit <ashutosh.dixit@intel.com>, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Harish Chegondi <harish.chegondi@intel.com>, Don Hiatt <don.hiatt@intel.com>, Sebastian Sanchez <sebastian.sanchez@intel.com>, Prathap Kumar Valsan <prathap.kumar.valsan@intel.com>
List-Id: linux-rdma@vger.kernel.org

On 4/4/2018 11:09 PM, Jason Gunthorpe wrote:
> On Wed, Apr 04, 2018 at 08:01:11PM -0700, Dennis Dalessandro wrote:
>> Hi Jason and Doug,
>>
>> Here are most of our updates for 4.17. I will follow this up with a small
>> 16B series then I still have a few more patches that are waiting on
>> some more thorough testing. Should be able to get them on the list tomrrow or
>> Friday at the latest, wanted to get these out now. I don't think anything
>> is really that scary in here.
> 
> Probably not going to happen for 4.17.
> 
> As a general rule series that are not on the list before the merge
> window opens are not going to be make it. Linus discourages doing
> things at the last minute as it encourages bad behavior that reduces
> release quality.

I think that's a fine policy, and usually try to stick to that myself, 
but got behind this time by a couple days. To be fair though, I wouldn't 
call this last minute. There is still a week and a half of merge window. 
I do realize there is unfortunate timing with OFA falling in the middle 
of the merge window though.

> In this specific case, Doug and I are both going to be at OFA next
> week so I'm not anticipating a 2nd pull request. I expect the only PR
> will go out on Friday.

I'll be there in Boulder as well so I'll see you guys then.

> If any of these are super important for 4.17 (eg would go to -rc) then
> let me now and I can look at only those, and they need really
> good rc worthy commit messages.

That's fair, I can live with that. I'll sync up with my folks tomorrow 
but at this point I don't think any of this merit the -rc. The patches 
that are marked stable aren't really -rc material since we've lived with 
those issues for a while now. The core fix is in the same boat.

The 16B series can wait till 4.18. I do have one other series that fixes 
a pretty severe performance issue, I will post it when it's ready, but 
it's a bit more scary and I imagine will have to push off till 4.18 as well.

-Denny
