From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Fix device managed flow steering support test
Date: Fri, 3 Jun 2016 09:10:45 -0700
Message-ID: <5584ab64-9f57-d5c7-cb5a-3e0644faa2aa@sandisk.com>
References: <33c3370d-3568-a9aa-906f-683b0e1b1a5f@sandisk.com>
 <009f01d1bdab$ce6f6840$6b4e38c0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <009f01d1bdab$ce6f6840$6b4e38c0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 06/03/2016 08:22 AM, Steve Wise wrote:
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Bart Van Assche
>> Sent: Friday, June 03, 2016 9:59 AM
>> To: Doug Ledford
>> Cc: Sagi Grimberg; Yishai Hadas; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: [PATCH] IB/mlx4: Fix device managed flow steering support test
>>
>> Perform the test for device managed flow steering support even if
>> memory windows are not supported. I noticed this because smatch
>> reported inconsistent indentation for the device managed flow
>> steering support test.
>>
>> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>> Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
>> Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Is there a commit you can reference with a Fixes line?

Hello Steve,

I'm not sure it's worth to add that information. A quote from an e-mail 
that was posted yesterday on this mailing list: "It looks like an
unharmful issue with the code, because we had support for memory window
feature literally forever."

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
