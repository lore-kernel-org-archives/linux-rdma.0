From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] rdma\hfi1 - coding style issues cleanup
Date: Fri, 13 May 2016 10:21:48 -0400
Message-ID: <20160513142148.GA12909@phlsvsds.ph.intel.com>
References: <1461830300-2851-1-git-send-email-omer.dagan@tandemg.com> <20160428124127.GB9685@phlsvsds.ph.intel.com> <f7fb16c7-7d5b-6b77-7879-1f16bdf76665@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f7fb16c7-7d5b-6b77-7879-1f16bdf76665-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, May 12, 2016 at 04:25:38PM -0400, Doug Ledford wrote:
>On 04/28/2016 08:41 AM, Dennis Dalessandro wrote:
>> On Thu, Apr 28, 2016 at 10:58:20AM +0300, omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org wrote:
>>> From: Omer Dagan <omer.dagan-CtGflUZwD1xBDgjK7y7TUQ@public.gmane.org>
>> 
>>> diff --git a/drivers/staging/rdma/hfi1/aspm.h
>>> b/drivers/staging/rdma/hfi1/aspm.h
>>> index 0d58fe3..384df0a 100644
>>> --- a/drivers/staging/rdma/hfi1/aspm.h
>>> +++ b/drivers/staging/rdma/hfi1/aspm.h
>>> @@ -234,7 +234,7 @@ static inline void aspm_disable_all(struct
>>> hfi1_devdata *dd)
>>> {
>>>     struct hfi1_ctxtdata *rcd;
>>>     unsigned long flags;
>>> -    unsigned i;
>>> +    unsigned int i;
>> 
>> Can you please explain the value in doing "unsigned int" vs "unsigned"?
>> None of the static checkers like checkpatch, sparse, or coccinelle seem
>> to mind.
>
>I'm not a big fan of all this churn for something that means next to
>nothing.  The C language specifies that unsigned means unsigned int,
>adding int is actually redundant and makes code lines longer to read.

I completely agree with Doug. This is a lot of churn for something that 
doesn't really add much value.

To be fair though, I do want to correct my statement above, apparently 
checkpatch *does* indeed throw a warning for this, was just checked in a few 
weeks back:

a1ce18e4f941("checkpatch: warn on bare unsigned or signed declarations 
without int")

Since the hfi1 driver is in staging, it's probably a big target for stuff 
like this. The git log for the above checkpatch commit just says kernel 
style prefers it this way.  I don't see any justification for why and I fail 
to see the benefit so I would prefer we drop this part of the patch.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
