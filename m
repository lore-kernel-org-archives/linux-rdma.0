From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH] IB/core: Don't drain the receive queue for srq attached
 queue-pair
Date: Tue, 26 Apr 2016 22:11:07 +0300
Message-ID: <571FBD4B.2030102@grimberg.me>
References: <1461682538-19647-1-git-send-email-sagi@grimberg.me>
 <571F8D48.4020503@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <571F8D48.4020503-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> SRQ attached QPs will fail receive work posts does not
>> have a receive queue that needs to be drained, the receive
>> queue is shared.
>
> The patch itself looks fine to me but the description of this patch is
> very confusing.

Sorry for the poor change log :) I was in a hurry (just now got back)
and quickly wrote description and sent out the patch without giving the
phrasing any thought.

> How about explaining that either an SRQ or an RQ is
> attached to a QP and hence that if an SRQ has been attached that there
> is no RQ attached and hence that it should not be drained?

I'll send out a better description, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
