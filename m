From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Can someone help me understand the reason for this code in ib_isert.c?
Date: Tue, 28 Oct 2014 12:06:06 +0200
Message-ID: <544F6A8E.9000400@mellanox.com>
References: <462EF229174FDB4D92ACE4656EA5610051E2EEF9@CMEXMB1.ad.emulex.com> <CAJ3xEMjmmt1guJO8rF6ChnTq-ZQbt9dpb_hwsNQCR65C79waRQ@mail.gmail.com> <20141023074347.GA25406@mtldesk30> <544CEFBD.2090405@acm.org> <20141026140808.GA742@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141026140808.GA742@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Chris Moore <Chris.Moore-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/26/2014 4:08 PM, Eli Cohen wrote:
> On Sun, Oct 26, 2014 at 01:57:33PM +0100, Bart Van Assche wrote:
>> Applications really need a way to query what the maximum supported
>> number of scatter/gather entries per work request is. The current
>> approach, namely using "dev_attr.max_sge - <magic value>" is
>> cumbersome since this approach doesn't work if the value of max_sge
>> reported by the HCA is small. I see two possible solutions: either
>> modify the max_sge value reported by the mlx4 and mlx5 drivers or
>> introduce a new parameter in struct ib_device_attr.
>>
> we already have reported max_sge value. Maybe what we need is another
> field, "guarnateed_num_sge" so applicatios providing this value can be
> sure it would succeed (or there is some other problem). Then they can
> either use this value or iterate from max_sge down to
> guarnateed_num_sge to find the highest possible value.
>
Eli, can we be a bit more restrictive and report something which would 
work?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
