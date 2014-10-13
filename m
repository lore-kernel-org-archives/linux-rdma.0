From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RFC 1/2] IB/core: Introduce Fast Indirect Memory Registration
 verbs API
Date: Mon, 13 Oct 2014 11:10:54 +0300
Message-ID: <543B890E.9040509@mellanox.com>
References: <CAJ3xEMjdnNNbhRC0T_=hmRedwJFvSR9r-JccLZ2m0zaece5OQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjdnNNbhRC0T_=hmRedwJFvSR9r-JccLZ2m0zaece5OQQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/9/2014 11:13 PM, Or Gerlitz wrote:
> On Tue, Oct 7, 2014, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> [...]
>>   enum ib_signature_prot_cap {
>> @@ -182,6 +183,7 @@ struct ib_device_attr {
>>          int                     max_srq_wr;
>>          int                     max_srq_sge;
>>          unsigned int            max_fast_reg_page_list_len;
>> +       unsigned int            max_indir_reg_mr_list_len;
>
> The indirection registration list is basically made of  struct ib_sge
> objects which are posted on a send-like work-request, any reason  to
> have a dedicated dev cap attribute for that and not use the already
> existing one (max_sge)?
>

Hi Or,

max_send_sge capability is how many ib_sge's the device can handle in a
single send work request which takes into consideration element such as
wqe control segment size and sq reservations. This is different from how
many ib_sge's the device can register to a single indirect memory key
which is free of such limitations.

So given these are different capabilities I prefer to expose them in
different attributes.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
