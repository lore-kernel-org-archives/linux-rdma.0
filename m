From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/3] IB: new common API for draining queues
Date: Thu, 11 Feb 2016 15:15:48 -0800
Message-ID: <56BD1624.4090309@sandisk.com>
References: <cover.1455230646.git.swise@chelsio.com>
 <3e7261d1436d33320223d365974ff38945f0d558.1455230646.git.swise@chelsio.com>
 <56BD1248.80805@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56BD1248.80805-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 02/11/2016 02:59 PM, Bart Van Assche wrote:
> On 02/05/2016 01:13 PM, Steve Wise wrote:
>> +static void wait_for_drain(struct ib_cq *cq, struct completion *c)
>> +{
>> +    if (cq->poll_ctx == IB_POLL_DIRECT)
>> +        do
>> +            ib_process_cq_direct(cq, 1024);
>> +        while (!wait_for_completion_timeout(c, msecs_to_jiffies(100)));
>> +    else
>> +        wait_for_completion(c);
>> +}
>
> Hello Steve,
>
> Have you verified this patch with checkpatch ? I expect that checkpatch
> will report that six braces are missing from this function.

(replying to my own e-mail)

BTW, this patch series does not call wait_for_drain() for any queue that 
uses IB_POLL_DIRECT. This means that the "if (cq->poll_ctx == 
IB_POLL_DIRECT)" part is untested. Please do propose untested code for 
upstream inclusion.

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
