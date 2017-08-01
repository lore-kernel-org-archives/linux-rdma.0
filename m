From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: BUG: NULL pointer dereference at ib_uverbs_comp_handler+0x20
Date: Tue, 1 Aug 2017 13:39:48 -0600
Message-ID: <0049cf5e-b2cc-0f55-438d-80e407edbbd8@deltatee.com>
References: <216b770e-fc08-68a6-c1bf-be96d52e325e@deltatee.com>
 <CAAKD3BDFcFDVvYYsimAqqWM9w-qv0Nc4U5Y54eGNhOATSkg0tA@mail.gmail.com>
 <5866fa2e-d3d9-cdaf-bcb4-806f938aef83@deltatee.com>
 <20170801192907.GB31205@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170801192907.GB31205@obsidianresearch.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Matan Barak <matanb@dev.mellanox.co.il>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Stephen Bates <sbates@raithlin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Potnuri Bharat Teja <bharat@chelsio.com>
List-Id: linux-rdma@vger.kernel.org


On 01/08/17 01:29 PM, Jason Gunthorpe wrote:
> On Tue, Aug 01, 2017 at 12:32:57PM -0600, Logan Gunthorpe wrote:
>>  Couldn't create rdma QP - Invalid argument
>> Unable to create QP.
>> Failed to create QP.
> 
> Failing to create a QP makes me wonder if you have have this patch?
> 
>  Subject: [PATCH v2 1/2] RDMA/uverbs: Fix the check for port number
> 
>  The port number is only valid if IB_QP_PORT is set in the mask.
>  So only check port number if it is valid to prevent modify_qp from
>  failing due to an invalid port number.
> 
>  Fixes: 5ecce4c9b17b("Check port number supplied by user verbs cmds")
>  Cc: <stable@vger.kernel.org> # v2.6.14+
>  Reviewed-by: Steve Wise <swise@opengridcomputing.com>
>  Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>

Oh, oops, I forgot about that. I mentioned the fix for that in my
original email and it seems I wasn't testing apples to apples for my
testing today. During my testing today, the branch with the reverted
commits had the fix for that commit while the branch with Bharat's patch
didn't.

I just did a test with both Bharat's patch and 5a7a88f1b4, and
everything is working correctly again.

So that's great, we just need these patches to be picked up by the
stable kernels.

Thanks,

Logan
