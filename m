From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v3] nvmet-rdma: Correctly handle RDMA device hot removal
Date: Mon, 1 Aug 2016 08:09:59 -0700
Message-ID: <c4aafeaf-0988-239d-e072-96b231f4d23f@sandisk.com>
References: <1469967347-20466-1-git-send-email-sagi@grimberg.me>
 <20160801111530.GB16474@lst.de>
 <7b8cc595-a33c-99e6-8490-161f83c2c489@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7b8cc595-a33c-99e6-8490-161f83c2c489-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/01/16 07:44, Bart Van Assche wrote:
> On 08/01/16 04:15, Christoph Hellwig wrote:
>> This looks reasonable to me, but a little question below:
>>
>>> @@ -1442,7 +1491,8 @@ static void nvmet_rdma_remove_port(struct
>>> nvmet_port *port)
>>>  {
>>>      struct rdma_cm_id *cm_id = port->priv;
>>>
>>> -    rdma_destroy_id(cm_id);
>>> +    if (cm_id)
>>> +        rdma_destroy_id(cm_id);
>>>  }
>>
>> How is ->remove_port synchronized vs the RDMA/CM event handler?
>
> rdma_destroy_id() waits until active RDMA/CM callbacks have finished. Is
> that sufficient or is further synchronization needed?

(replying to my own e-mail)

Please ignore my e-mail. I just realized that Christoph's question was 
about synchronization of nvmet_rdma_remove_port() versus the RDMA/CM 
event handler instead of just rdma_destroy_id().

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
