From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] IB/core: Don't drain the receive queue for srq attached
 queue-pair
Date: Tue, 26 Apr 2016 08:46:16 -0700
Message-ID: <571F8D48.4020503@sandisk.com>
References: <1461682538-19647-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461682538-19647-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/26/2016 07:55 AM, Sagi Grimberg wrote:
> SRQ attached QPs will fail receive work posts does not
> have a receive queue that needs to be drained, the receive
> queue is shared.

The patch itself looks fine to me but the description of this patch is 
very confusing. How about explaining that either an SRQ or an RQ is 
attached to a QP and hence that if an SRQ has been attached that there 
is no RQ attached and hence that it should not be drained?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
