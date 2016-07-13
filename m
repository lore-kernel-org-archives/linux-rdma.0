From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 3/5] IB/srpt: Limit the number of SG elements per work
 request
Date: Wed, 13 Jul 2016 16:39:41 +0700
Message-ID: <8764b153-266f-4537-95e8-841164634438@sandisk.com>
References: <c9a58bf1-b230-5990-a2b3-4e6aa729cd8f@sandisk.com>
 <908f9aa5-1afd-2eab-29d8-475626e0db49@sandisk.com>
 <5786098E.5020305@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5786098E.5020305-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/13/2016 04:27 PM, Sagi Grimberg wrote:
>> +	qp_init->cap.max_send_sge = min(attrs->max_sge, SRPT_MAX_SG_PER_WQE);
>
> Why are you limiting the max_sge with SRPT_MAX_SG_PER_WQE? what is the
> motivation?

Hello Sagi,

The reason that I want to use a lower value than max_sge is to avoid QP 
allocation failures. During my tests with mlx4 adapters I had noticed 
that the buffers that are allocated with kmalloc() during QP creation 
with max_send_sge = max_sge are so large that QP allocation often fails. 
Hence min(..., SRPT_MAX_SGE_PER_WQE).

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
