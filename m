From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for v4.7] IB/srpt: Reduce QP buffer size
Date: Thu, 30 Jun 2016 01:08:36 +0300
Message-ID: <5096f501-6210-269b-15cc-996cf39ae100@mellanox.com>
References: <20160623073548.9883-1-bart.vanassche@sandisk.com>
 <CAG53R5X_J+ygz_Hrt8w44rQ1EPH55KLLGj0t3apXcFeHLf=M8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG53R5X_J+ygz_Hrt8w44rQ1EPH55KLLGj0t3apXcFeHLf=M8w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 6/24/2016 6:58 AM, Parav Pandit wrote:
> Hi Bart,
>
> On Thu, Jun 23, 2016 at 1:05 PM, Bart Van Assche
> <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
>> -       qp_init->cap.max_send_sge = max(sdev->device->attrs.max_sge_rd,
>> -                                       sdev->device->attrs.max_sge);
>> +       qp_init->cap.max_send_sge = SRPT_DEF_SG_PER_WQE;
>>         qp_init->port_num = ch->sport->port;
>
> Instead of static value, you might want to do
>
> max_send_sge = min(max_sge_rd, max_sge, SRPT_DEF_SG_PER_WQE)

I like Parav fix,

Reviewed-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


>
> So that it can still remain functional (if not as high performance)
> for hw and software devices with SGE of 8 or 12 also?
> Otherwise QP creation itself might fail for values lower than 16.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
