From: Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: Re: ocrdma failure in 4.4.0-rc5
Date: Thu, 24 Dec 2015 00:23:25 +0530
Message-ID: <CANjDDBibF9eR-uumY3rzckeDfDE6CfBQsAAdkZVWAitdviW2FQ@mail.gmail.com>
References: <5675BA00.5060101@redhat.com> <CANjDDBiJAyfS7wFr9yYs7fAnn1-h9t1JH9s1LDf-Q8RYk=Ayyw@mail.gmail.com>
 <567AE0E8.70107@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <567AE0E8.70107-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Dough,

I was all set to send you an update in my morning tomorrow. Let me
give you a brief update here

The deadlock is caused being caused due to following two facts:
A. be2net is sending open/close event to ocrdma holding
device_list_mutex. Nic Open/close hooks are called under rtnl lock
from user-space.
B. As per ocrdma intialization logic ib_register_device() is called
under device_list_mutex. On the other hand inside
ib_register_device(), GID table initialization logic tries to acquire
rtln-lock to fill some of the table attributes.

My patch series to fix this issue is already under testing. After 1
round of internal reivew I should be able to post the series in a day
or two.

-Regards
Devesh


On Wed, Dec 23, 2015 at 11:29 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 12/20/2015 11:29 PM, Devesh Sharma wrote:
>> Hi Dough,
>>
>> Thanks for your note.
>>
>> We will root cause the issue asap and get back to you with the fix.
>
> Ping.  Any update?
>
>> -Regards
>> Devesh
>>
>> On Sun, Dec 20, 2015 at 1:41 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> Hi Devesh,
>>>
>>> Testing 4.4.0-rc5, the ocrdma driver is failing for me (100% reliably).
>>>  If you have vlans off of the main device, this is what I get from the
>>> Fedora rawhide 4.4.0-rc5 kernel:
>>>
>>>
>>> --
>>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>>               GPG KeyID: 0E572FDD
>>>
>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
