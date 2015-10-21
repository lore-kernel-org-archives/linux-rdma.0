From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 for-next 1/7] IB/core: Extend ib_uverbs_create_qp
Date: Wed, 21 Oct 2015 21:15:08 +0300
Message-ID: <CAJ3xEMgWcpKbKL3jhiK2RP=H6_iY0eriirAXn1TJaSG7u8frAA@mail.gmail.com>
References: <1444909482-17113-1-git-send-email-eranbe@mellanox.com>
	<1444909482-17113-2-git-send-email-eranbe@mellanox.com>
	<56276095.6020803@dev.mellanox.co.il>
	<56276336.7000704@mellanox.com>
	<56279CA4.8040201@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56279CA4.8040201-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 21, 2015 at 5:09 PM, Sagi Grimberg  wrote:
> On 10/21/2015 1:04 PM, Or Gerlitz wrote:
>> On 10/21/2015 12:53 PM, Sagi Grimberg wrote:
>>> On 10/15/2015 2:44 PM, Eran Ben Elisha wrote:

>>>> +struct ib_uverbs_ex_create_qp {
>>>> +    __u64 user_handle;
>>>> +    __u32 pd_handle;
>>>> +    __u32 send_cq_handle;
>>>> +    __u32 recv_cq_handle;
>>>> +    __u32 srq_handle;
>>>> +    __u32 max_send_wr;
>>>> +    __u32 max_recv_wr;
>>>> +    __u32 max_send_sge;
>>>> +    __u32 max_recv_sge;
>>>> +    __u32 max_inline_data;
>>>> +    __u8  sq_sig_all;
>>>> +    __u8  qp_type;
>>>> +    __u8  is_srq;
>>>> +    __u8 reserved;
>>>> +    __u32 comp_mask;
>>>> +    __u32 create_flags;
>>>
>>>
>>> Can we please make create_flags u64 to begin with?

>> In the kernel we used 4-5 flags over 10 years, why worry?

> I don't see why we should assume that we won't occupy enough bits in a
> long time just for saving extra 4 bytes. But if you are strongly against
> it then I won't persist here.

Again, the kernel stack consuming rate here was < 1 bit a year when
averaging over time since this was introduced. So we should be doing
well for the coming ~10-20 years with this 32 bit field, and we can
easily extend it later, I verified that with Haggai, so yes, don't
want 64 bits now.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
