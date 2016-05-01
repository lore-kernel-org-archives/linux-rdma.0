From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: iSER multi-queue configuration
Date: Sun, 1 May 2016 05:53:42 +0300
Message-ID: <57256FB6.7030607@grimberg.me>
References: <CAF1ivSa24Y114s0f0g74jgmP8MuPfrfU_uAA7AAVR8Tsz=+avg@mail.gmail.com>
 <1461996836.4373.5.camel@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461996836.4373.5.camel-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Hi Sagi,

Hi Ming,

> I'm looking at why there is only 1 HW queue for iser.
>
> 2185 int scsi_mq_setup_tags(struct Scsi_Host *shost)
> 2186 {
> ...
> 2199         shost->tag_set.nr_hw_queues = shost->nr_hw_queues ? : 1;
>
>
> It seems because iser code does not set shost->nr_hw_queues at all.
>
> Why?

The iscsi driver has not yet been converted to scsi_mq and iser as
an iscsi transport still does not use multi-queue.

In iscsi, a hw queue maps to an iscsi session. In order to support
multi-queue we need to have iscsi open multiple sessions and map
a session to a queue.

I had some preliminary works on this (joint with Mike Christie) but I
didn't have time thus far to implement a full conversion to scsi-mq.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
