From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH RFC v2 2/3] rdma_cm: add rdma_consumer_reject() helper
 function
Date: Sat, 22 Oct 2016 00:45:33 +0300
Message-ID: <a649dc62-3005-f6fd-7d00-d4ddd77c8816@grimberg.me>
References: <cover.1477003235.git.swise@opengridcomputing.com>
 <cb135696be86c21c144ef35a4d6f7f71394a3627.1477003235.git.swise@opengridcomputing.com>
 <20161021121428.GB17028@lst.de>
 <005f01d22ba4$aeadeab0$0c09c010$@opengridcomputing.com>
 <CAG53R5Xyp+n7KYj6zZF6PFuXke3XtqaMgaGTRmgd_uGXTFNDtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG53R5Xyp+n7KYj6zZF6PFuXke3XtqaMgaGTRmgd_uGXTFNDtw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>>> Yes.  Also I'd just inline the ib_consumer_reject and iw_consumer_reject
>>> helpers here.
>>>
>>> Aso wouldn't it be better named rdma_consumer_is_reject or similar
>>> given that we don't reject anything here, but check if the request
>>> has been rejected?
>>
>> How about rdma_rejected_by_consumer()?
>>
> How about rdma_reject_by_ulp()?
> We have ulp directory holding iser, srp etc.

I like consumer better.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
