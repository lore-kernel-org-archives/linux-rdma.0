From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v2 0/3] Fix request completion holes
Date: Mon, 20 Nov 2017 10:33:11 +0200
Message-ID: <37edfd7b-2de3-ba30-8770-8a14266d7cdd@grimberg.me>
References: <20171108100616.26605-1-sagi@grimberg.me>
 <1510611044.3735.49.camel@redhat.com>
 <e89f72c6-12ce-c149-c81e-f3adb43a8e9e@grimberg.me>
 <20171120073755.GA2236@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171120073755.GA2236-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>>> Sagi, are you ready for me to take this series in?  It seemed like there
>>> was a question as to whether you might want to try atomics instead of
>>> spin locks, or do you want to stick with spinlocks?
>>
>> I still need a review for this, and I think we'll get it in through the
>> nvme tree (via the block tree). Thanks.
> 
> I've  done an initial review pass, but I'd really like to see someone
> who has more RDMA experience to take a look as well.

Perhaps Max can have a look?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
