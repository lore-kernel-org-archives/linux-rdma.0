From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v5 0/6] nvme-rdma device removal fixes
Date: Mon, 12 Sep 2016 17:58:09 +0300
Message-ID: <f492116d-72ad-0217-9e8f-56e890324c45@grimberg.me>
References: <cover.1472833420.git.swise@opengridcomputing.com>
 <89eb2382-9a2f-48d1-c9fd-0c018e07cd9f@grimberg.me>
 <00ee01d20d04$df3e2d70$9dba8850$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00ee01d20d04$df3e2d70$9dba8850$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>>> Doug/Sagi, the first 2 iw_cxgb4 patches are included here because they're
>>> needed for the testing.  While I've also submitted them to linux-rdma,
>>> perhaps Sagi can merge them in nvmf-4.8-rc?  If that is acceptable
>>> with everyone.
>>
>> Fine with me,
>>
>> Queued for the next round of rc fixes.
>>
>> Thanks Steve!
>
> Hey Sagi, Will these make 4.8-rc7?

I planned to send them out tomorrow.

I'll also apply a patch that clears the flags
when creating the queue.

Cheers,
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
