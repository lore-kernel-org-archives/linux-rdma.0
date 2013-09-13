From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Make queue size configurable
Date: Fri, 13 Sep 2013 11:24:12 +0200
Message-ID: <5232D9BC.7090808@acm.org>
References: <521363EA.8080906@acm.org> <52136609.3090406@acm.org>  <1378782080.3794.6.camel@feather.ornl.gov> <522F5A81.8040101@acm.org> <1378937796.6649.5.camel@haswell.thedillows.org> <5231E8CE.5060105@gmail.com> <5231EC1A.7030902@acm.org> <5232C76B.4010704@gmail.com> <5232CF86.20507@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5232CF86.20507-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, David Dillow <dad-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Konrad Grzybowski <konradg-XLFqaoR9dsI@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/13/13 10:40, Bart Van Assche wrote:
> On 09/13/13 10:06, Jack Wang wrote:
>> On 09/12/2013 06:30 PM, Bart Van Assche wrote:
>>> On 09/12/13 18:16, Jack Wang wrote:
>>>> On 09/12/2013 12:16 AM, David Dillow wrote:
>>>>> On Tue, 2013-09-10 at 19:44 +0200, Bart Van Assche wrote:
>>>>>> If this name was not yet in use in any interface that is visible in
>>>>>> user
>>>>>> space, I would agree that we should come up with a better name.
>>>>>> However,
>>>>>> the SCSI mid-layer already uses that name today to export the queue
>>>>>> size. To me this looks like a good reason to use the name
>>>>>> "can_queue" ?
>>>>>> An example:
>>>>>>
>>>>>> $ cat /sys/class/scsi_host/host93/can_queue
>>>>>> 62
>>>>>
>>>>> Yes, I know it has been used before, but I'm torn between not
>>>>> furthering
>>>>> a bad naming choice and consistency. Foolish consistency and all
>>>>> that...
>>>>>
>>>>> I really don't like "can_queue", but I'll not complain if Roland
>>>>> decides
>>>>> to take it as-is.
>>>>
>>>> What the allow range for this queue size?
>>>> Default cmd_per_lun and can_queue with same value makes no sense to me.
>>>> Could we bump can_queue to bigger value like 512?
>>>
>>> Increasing the default value is only necessary when using a hard disk
>>> array at the target side. When using a single hard disk or an SSD at the
>>> target side the default value is fine.
>>
>> Agree, from another side increasing default can_queue value is harmless
>> for single harddisk/SSD, but will boot performance for multiple LUN
>> attached to same host, so why not?
>
> Increasing that parameter increases memory consumption for each path
> between initiator and target. In a setup where both the initiator and
> the target have multiple IB ports the number of paths can be large even
> when only a single LUN is exported by the target. That's why I'm not
> enthusiast about increasing the default value of the queue size.

(replying to my own e-mail)

Note: with the srp_daemon implementation available on github it's 
possible to set the can_queue parameter for all logins initiated by 
srp_daemon by adding something like the following at the end of 
/etc/srp_daemon.conf:

a can_queue=512

See also http://github.com/bvanassche/srptools.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
