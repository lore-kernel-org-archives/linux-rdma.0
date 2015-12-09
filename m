From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/37] Add rdma verbs transport library
Date: Wed, 9 Dec 2015 12:11:01 -0500
Message-ID: <20151209171100.GA13915@phlsvsds.ph.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com> <CAG9sBKPYwG3ug+CEOV--tLXcaa-M_1k5W6+LUeO7RciiRmeh7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKPYwG3ug+CEOV--tLXcaa-M_1k5W6+LUeO7RciiRmeh7Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 09, 2015 at 02:21:54PM +0200, Moni Shoua wrote:
>On Mon, Dec 7, 2015 at 10:42 PM, Dennis Dalessandro
><dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> The following series implements rdmavt. This is the rdma verbs transport
>> software library which will help to solve the problem of code duplication
>> between hardware drivers when it comes to a verbs implementation.
>>
>> Rdmavt is basically just another verbs provider and lives in the Infiniband tree
>> in a new sw directory. It provides a software implementation of the Infiniband
>> verbs API. More details can be found in the following threads:
>>
>> http://www.spinics.net/lists/linux-rdma/msg29064.html
>> http://www.spinics.net/lists/linux-rdma/msg29922.html
>>
>> This patch series is based on 4.4-rc3.
>>
>> ---
>Hi Denny
>
>Can you tell how you see the end of this project?
>Wouldn't it be right to start with goals and design RFC with more
>details than the one you have in the links above, like target drivers
>and interfaces?

Our main goal here is to get hfi1 out of staging. *The* blocker for that is 
the code duplication. Naturally, the target drivers are qib and hfi1. We 
realize it can and should also be used for soft-roce, which is why we are 
keeping the development in the open. The design is pretty simple, take 
qib/hfi1 common code and move it to a common location with some glue to make 
it all work.

As to the interfaces, I don't think we need anything set in stone. In 
general you want to avoid changing APIs. However, even if we do have to 
change the interface later to accommodate soft-roce or something else we 
haven't even thought of yet, that is not a huge deal.

>But since you've already posted this, can we at least have this
>discussion now before you proceed so we can all have a chance to
>influence the final result?
>
>To be more specific, I always imagined the send path like this
>[1] Application -> [2] ib_core -> [3] rdmavt -> [4] rvt-backend
>The interfaces from [1] to [3] are like the ones we have today and IMO
>the one from [3] t0 [4] should look like
>
>int qib_verbs_send(struct qib_qp *qp, struct qib_ib_header *hdr,
>                   u32 hdrwords, struct qib_sge_state *ss, u32 len);

The send path is but one interface. I will try and get a patch out for 
comment on that very soon. Although that's probably pretty close. Perhaps 
you are concerned about rdmavt doing more than it should? We have very 
specific ways of sending packets with our PIO and SDMA engines for instance.  
However that sort of detail is hardware specific (is not even the same 
between qib and hfi1) and doesn't belong in rdmavt. Thus the interface to 
the driver will be a pretty generic one, like what you have shown.

>With what I see now, what RDMAVT does is to forward the call to to the
>rvt-backend  as is. I'm sure that you are not going to keep it this
>way or the goal for removing code duplication won't be achieved.
>However, I still would like to know about the plans for being there.

Correct. This way we always have a 100% functional driver. For parts which 
rdmavt does not yet implement it just passes through, so to speak. Although 
technically the call just bypasses rdmavt, it doesn't really "forward" 
anything. This lets us do the development incrementally.

>Also, you  you've out yourself as the maintainer of this project. You
>deserve it technically of course but since RDMA_VT is not going to
>serve just Intel's backends, wouldn't it be right if we add other
>co-maintainers that have an interest on this project?

Who do you have in mind? Adding a co-maintainer is something that I think 
would come eventually and am not against it at all. Perhaps once soft-roce 
has been added and is supported in rdmavt. Of course this is also all under 
the purview of the subsystem maintainer, Doug.

>To conclude, RDMA_VT is a project with importance for more than one
>vendor and as such it needs to be developed in cooperation or else it
>would not serve its purpose.

I think we have all agreed that this is the case. The code has been on 
GitHub and we have had a couple of short threads on the mailing list. We 
have accepted input from other vendors, and have even included patches
contributed by Kamal in this submission. As has already been seen, posting 
to the list has gotten us much more participation in the form of a number of 
comments, which is what we want. However our top priority as I said above is 
to get the TODO item done for hfi1.

We will _not_ do anything in rdmavt which makes it impossible or overly hard 
to add soft-roce support. That is why you are seeing the development as it 
progresses. If you see anything which you believe to be contrary to that 
please raise the issue. Is there anything in this patchset that should be 
called out?

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
