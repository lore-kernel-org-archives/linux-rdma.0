From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/5] IB/core: Add max_sge argument to rdma_rw_ctx_init()
Date: Tue, 28 Jun 2016 18:12:45 +0200
Message-ID: <5562901c-92f0-b548-a1f8-685d230472a9@sandisk.com>
References: <419391ba-0c39-11ce-f249-84b428dc73d5@sandisk.com>
 <ce96b1f4-e9b9-31e2-f9d2-77e71f8bbcd1@sandisk.com>
 <20160628115206.GB28113@lst.de>
 <7fbd81ae-4b0d-4f8b-18ac-7efcf0dd4d61@sandisk.com>
 <20160628154235.GA2843@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160628154235.GA2843-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/28/2016 05:42 PM, Christoph Hellwig wrote:
> On Tue, Jun 28, 2016 at 02:37:29PM +0200, Bart Van Assche wrote:
>> The memory needed for QP buffers strongly depends on max_send_sge and
>> max_recv_sge. Using a large value for max_send_sge and/or max_recv_sge for
>> all drivers would increase the memory consumption for drivers that only
>> submit RDMA requests with a low number of SG elements. Using a small value
>> for max_send_sge and/or max_recv_sge would result in a performance decrease
>> for drivers that benefit from large max_send_sge and/or max_recv_sge
>> values. This is why I think that drivers should have the freedom to chose
>> the max_send_sge and max_recv_sge values.
>
> No problem with that - but please configure it on the QP as part of the
> qp_init_attr structure instead of passing it to every RDMA READ/WRITE call.

That sounds like a good idea to me. I will make this change, retest and 
repost this patch series.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
