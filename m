From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V6 6/9] isert: Rename IO functions to more descriptive
 names
Date: Thu, 6 Aug 2015 18:37:39 +0300
Message-ID: <55C37F43.6080106@dev.mellanox.co.il>
References: <20150724161331.25617.8475.stgit@build2.ogc.int>
 <20150724161848.25617.26092.stgit@build2.ogc.int>
 <55B4B190.7070305@dev.mellanox.co.il>
 <55B5404F.5040404@opengridcomputing.com>
 <000001d0ce23$27048810$750d9830$@opengridcomputing.com>
 <55C0F5B7.4040100@dev.mellanox.co.il>
 <00b001d0cfc4$f83a14c0$e8ae3e40$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00b001d0cfc4$f83a14c0$e8ae3e40$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 8/6/2015 12:23 AM, Steve Wise wrote:
>
>>>
>>>> Hey Sagi, how is this coming along?  How can I help?
>>>>
>>>
>>> Hi Steve,
>>>
>>> This is taking longer than I expected, the changes needed seem
>>> pretty extensive throughout the IO path. I don't think it will be ready
>>> for 4.3
>>>
>>
>> Perhaps then we should go with my version that adds iwarp-only FRMR IO handlers for 4.3.  Then they can be phased out as the rework
>> matures.  Thoughts?
>>
>
> Shall I send out the series again for merging into 4.3?

Hi Steve,

Not sure about that.. I'm a bit reluctant in adding a code that
branches the isert code even more than it already is.

Nic, WDYT?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
