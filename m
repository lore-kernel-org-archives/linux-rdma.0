From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: Can someone help me understand the reason for this code in ib_isert.c?
Date: Sun, 26 Oct 2014 13:57:33 +0100
Message-ID: <544CEFBD.2090405@acm.org>
References: <462EF229174FDB4D92ACE4656EA5610051E2EEF9@CMEXMB1.ad.emulex.com> <CAJ3xEMjmmt1guJO8rF6ChnTq-ZQbt9dpb_hwsNQCR65C79waRQ@mail.gmail.com> <20141023074347.GA25406@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141023074347.GA25406@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Chris Moore <Chris.Moore-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/23/14 09:43, Eli Cohen wrote:
> On Tue, Oct 21, 2014 at 12:13:22AM +0300, Or Gerlitz wrote:
>> On Mon, Oct 20, 2014 at 6:29 PM, Chris Moore <Chris.Moore-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org> wrote:
>>> The following code is in isert_conn_setup_qp() in ib_isert.c:
>>>
>>>           /*
>>>             * FIXME: Use devattr.max_sge - 2 for max_send_sge as
>>>             * work-around for RDMA_READ..
>>>             */
>>>           attr.cap.max_send_sge = device->dev_attr.max_sge - 2;
>>>
>>> It's not clear from the comment what this is a work-around for, and I wasn't able
>>> to figure it out from looking at logs.
>>
>> I believe this refers to some IBTA spec corner case which comes into
>> play with the max_sges advertized by mlx4, Eli, can you shed some
>> light (IBTA pointer) on that? is this the case (i.e dev_attr.max_sge
>> isn't always achievable) with mlx5 too?
>
> I don't think it has to do anything with some corner case. If you look
> at the spec you will find that is not guarnteed that whenever you
> create a QP with device->dev_attr.max_sge it will succeed. The
> consumer should try smaller values if it cannot create a QP with max
> sge. This is from IB spec 1.2.1.
>
> 11.2.1.2 QUERY HCA
> Description:
> Returns the attributes for the specified HCA.  The maximum values
> defined in this section are guaranteed not-to-exceed values. It is
> possible for an implementation to allocate some HCA resources from the
> same space. In that case, the maximum values returned are not
> guaranteed for all of those resources simultaneously.

Hello Eli,

Applications really need a way to query what the maximum supported 
number of scatter/gather entries per work request is. The current 
approach, namely using "dev_attr.max_sge - <magic value>" is cumbersome 
since this approach doesn't work if the value of max_sge reported by the 
HCA is small. I see two possible solutions: either modify the max_sge 
value reported by the mlx4 and mlx5 drivers or introduce a new parameter 
in struct ib_device_attr.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
