From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: libmlx4 and libmlx5 git trees? Who is handling those?
Date: Mon, 28 Sep 2015 14:19:33 -0500
Message-ID: <560992C5.5080406@opengridcomputing.com>
References: <alpine.DEB.2.20.1509281036520.30603@east.gentwo.org>
 <56096033.8040000@redhat.com> <20150928171724.GF12415@obsidianresearch.com>
 <alpine.DEB.2.20.1509281220580.31260@east.gentwo.org>
 <9C6B67F36DCAFC479B1CF6A967258A8C7D250932@ORSMSX110.amr.corp.intel.com>
 <20150928173939.GA1623@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150928173939.GA1623-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/28/2015 12:39 PM, Jason Gunthorpe wrote:
> On Mon, Sep 28, 2015 at 05:28:20PM +0000, Woodruff, Robert J wrote:
>> On Mon, 28 Sep 2015, Christoph Lameter wrote:
>>
>>> Right. Its really nasty when you are trying to add features that require libibverbs and libmlx? changes. Plus it may depend on kernel changes.
>> On the other hand, combining everything into one package limits the
>> ability of the maintainer of the individual components to release
>> packages with simple bug fixes or enhancements that are component
>> specific and don't require kernel core or libibverbs changes. Thus,
>> they would have to wait till a new combined package gets released
>> and makes the maintainer of that package the bottleneck for getting
>> new code out.
> That is certainly the minority of work these days, by my observation.
>
> Nearly everything is being driven by kernel side changes now and
> requires cross-library work.
>
> Or it is maintenance activity, which is so hard now (I've done a few
> patches over the years) it isn't worth doing unless it is really
> important.
>
> Jason
>

I've released many libcxb4 releases that fixed bugs, and even added new 
device support w/o any libibverbs changes.  So I'm not sure I see the 
benefit of munging all the RDMA libraries into some uber-release...

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
