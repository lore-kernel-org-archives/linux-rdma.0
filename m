From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1] IB/cma: Fix RDMA port validation for iWarp
Date: Thu, 14 Jan 2016 09:14:54 +0200
Message-ID: <56974AEE.6060201@mellanox.com>
References: <1452158369-2938-1-git-send-email-matanb@mellanox.com>
 <00d301d14d69$18257d70$48707850$@opengridcomputing.com>
 <CAAKD3BAWUfg6sVLCEtb-vBrC9kGtVYO784xg4_tGqiZaOVh-2Q@mail.gmail.com>
 <007b01d14e13$7fb5a190$7f20e4b0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <007b01d14e13$7fb5a190$7f20e4b0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Matan Barak' <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Hariprasad Shenai' <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/13/2016 5:03 PM, Steve Wise wrote:
>> -----Original Message-----
>> From: Matan Barak [mailto:matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
>> Sent: Wednesday, January 13, 2016 4:33 AM
>> To: Steve Wise
>> Cc: Matan Barak; Doug Ledford; linux-rdma; Or Gerlitz; Majd Dibbiny; Hariprasad Shenai
>> Subject: Re: [PATCH V1] IB/cma: Fix RDMA port validation for iWarp
>>
>> On Tue, Jan 12, 2016 at 8:43 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
>>> Hey Matan,
>>>
>>> Will you please submit this to 4.4-stable?
>>>
>>> Thanks,
>>>
>>> Steve.
>>>
>> You could only take it to 4.4-stable, once it's accepted to upstream.
> You could add this to the sign-off section of the patch and it will flow automagically...
>
> Cc:  <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 4.4.x-
>
> Doug, perhaps you could add this when you pull it in?

Steve,

We prefer that patches to our drivers and the IB core will swim for a 
while in upstream before they go to -stable.

I suggest we wait till 4.5-rc2 for that, Okay?

Or.



>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
