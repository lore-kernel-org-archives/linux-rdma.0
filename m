From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: Re: [PATCH] RDMA/nldev: Fix multiple potential NULL pointer
 dereferences
Date: Mon, 12 Feb 2018 16:30:42 -0600
Message-ID: <4790a8b3-1626-fadd-1721-9c1c361b01ea@embeddedor.com>
References: <20180209063702.GA28685@embeddedgus>
 <20180209122549.GK2197@mtr-leonro.local>
 <20180209073649.Horde.OueGLKMtzpLyz4w36quXUca@gator4166.hostgator.com>
 <20180209143541.GN2197@mtr-leonro.local>
 <20180209095600.Horde.e7EqwCs_5bRLfE3Nnkfl3L3@gator4166.hostgator.com>
 <20180209164918.GP2197@mtr-leonro.local>
 <20180209113640.Horde.xafidJ_CTj9RROQxEbXk8Qi@gator4166.hostgator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180209113640.Horde.xafidJ_CTj9RROQxEbXk8Qi@gator4166.hostgator.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Leon,

On 02/09/2018 11:36 AM, Gustavo A. R. Silva wrote:
> 
> Quoting Leon Romanovsky <leon@kernel.org>:
> 
>> On Fri, Feb 09, 2018 at 09:56:00AM -0600, Gustavo A. R. Silva wrote:
>>>
>>> Quoting Leon Romanovsky <leon@kernel.org>:
>>>
>>> > On Fri, Feb 09, 2018 at 07:36:49AM -0600, Gustavo A. R. Silva wrote:
>>> > > Hi Leon,
>>> > >
>>> > > Quoting Leon Romanovsky <leon@kernel.org>:
>>> > >
>>> > > > On Fri, Feb 09, 2018 at 12:37:02AM -0600, Gustavo A. R. Silva 
>>> wrote:
>>> > > > > In case the message header and payload cannot be stored, 
>>> function
>>> > > > > nlmsg_put returns null.
>>> > > > >
>>> > > > > Fix this by adding multiple sanity checks and avoid a potential
>>> > > > > null dereference on _nlh_ when calling nlmsg_end.
>>> > > > >
>>> > > > > Addresses-Coverity-ID: 1454215 ("Dereference null return value")
>>> > > > > Addresses-Coverity-ID: 1454223 ("Dereference null return value")
>>> > > > > Addresses-Coverity-ID: 1454224 ("Dereference null return value")
>>> > > > > Addresses-Coverity-ID: 1464669 ("Dereference null return value")
>>> > > > > Addresses-Coverity-ID: 1464670 ("Dereference null return value")
>>> > > > > Addresses-Coverity-ID: 1464672 ("Dereference null return value")
>>> > > > > Fixes: e5c9469efcb1 ("RDMA/netlink: Add nldev device doit
>>> > > implementation")
>>> > > > > Fixes: c3f66f7b0052 ("RDMA/netlink: Implement nldev port doit 
>>> callback")
>>> > > > > Fixes: 7d02f605f0dc ("RDMA/netlink: Add nldev port dumpit
>>> > > implementation")
>>> > > > > Fixes: b5fa635aab8f ("RDMA/nldev: Provide detailed QP 
>>> information")
>>> > > > > Fixes: bf3c5a93c523 ("RDMA/nldev: Provide global resource 
>>> utilization")
>>> > > > > Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>>> > > > > ---
>>> > > > >  drivers/infiniband/core/nldev.c | 26 +++++++++++++++++++++++++-
>>> > > > >  1 file changed, 25 insertions(+), 1 deletion(-)
>>> > > > >
>>> > > >
>>> > > > It will be much better to fix the tool instead of fixing ghost 
>>> case.
>>> > > > This scenario is impossible for all those flows.
>>> > > > We can receive the skv/msg in two ways:
>>> > > >  * First by allocating new message with NLMSG_DEFAULT_SIZE, 
>>> which has
>>> > > > more room
>>> > > >    than nlmsg_total_size(payload), payload is 0.
>>> > > >  * Second by getting from netlink.c and it will be at least 
>>> "struct
>>> > > > nlmsghdr" too.
>>> > > >
>>> > > > Can you please add this info to the commit message?
>>> > > >
>>> > >
>>> > > Actually, I was planing to send a new version of this patch. This 
>>> time using
>>> > > the unlikely macro for all the null checks on nlh.
>>> > >
>>> > > What do you think?
>>> >
>>> > It is not datapath, so "unlikely" is not needed. Let's assume that 
>>> smart
>>> > enough
>>> > compiler will optimize such flow anyway, because nlmsg_put returns 
>>> NULL
>>> > in unlikely scenario, so this check will be unlikely automatically 
>>> too.
>>> >
>>>
>>> I'm curious about why the return value of nlmsg_put is null checked 
>>> 118 out
>>> of 129 times (based on Coverity reports) in the last linux-next tree.
>>>
>>> So based on what you mention, do you think all those checks are actually
>>> unnecessary and, maybe they should be removed?
>>
>> I honestly don't know about all cases, but if message is allocated with
>> NLMSG_DEFAULT_SIZE and payload is 0, this check won't be needed.
>>
> 
> I got it.
> 
>> So go ahead, add check if (!...) in all places, but be cautious with
>> "potential null dereference" claims, it is not always true.
>>
> 

I've finally decided to document all these cases as False Positives in 
the Coverity platform.

I think it is better to do that than adding unnecessary code. I will 
also add a link to this conversation to the Coverity database.

Thanks a lot for your feedback.
--
Gustavo
