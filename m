From: "shahar.salzman" <shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Unexpected issues with 2 NVME initiators using the same target
Date: Thu, 9 Mar 2017 14:18:28 +0200
Message-ID: <b81bb611-533a-1715-841b-f7615b55048f@gmail.com>
References: <08131a05-1f56-ef61-990a-7fff04eea095@gmail.com>
 <de1a559a-bf24-0d73-5fc7-148d6cd4d4e0@grimberg.me>
 <1848296658.37025722.1487782361271.JavaMail.zimbra@redhat.com>
 <1554c1d1-6bf4-9ca2-12d4-a0125d8c5715@gmail.com>
 <DE927C68B458BE418D582EC97927A92854655137@ORSMSX112.amr.corp.intel.com>
 <3eb5814f-14cb-2b94-adf8-335d4b2eb7e9@grimberg.me>
 <26912d0c-578f-26e9-490d-94fc95bdf259@mellanox.com>
 <16c4bd86-fd63-f230-40bc-f52cb106e11b@grimberg.me>
 <fbd647dd-3a16-8155-107d-f98e8326cc63@mellanox.com>
 <c5a6f55b-a633-53ca-4378-7a7eaf7f77bd@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c5a6f55b-a633-53ca-4378-7a7eaf7f77bd-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Riches Jr, Robert M" <robert.m.riches.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, Vladimir Neyelov <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Sorry for the delay, I have been OOO for the past few days.

Indeed the underlying transport is Ethernet, and we have found that flow 
control is disabled on the switch side.
I still do not have access to the system for re-tests with the flow 
control, and 4.10. But I am working on assembling another system.

A little off-topic, but something that may help me get the other system 
up faster, can I use a dual CX4 card as initiator and target (i.e. one 
port going up to the switch, and the other coming back into the system) 
without the kernel looping back? I have a spare CX4, so if possible, I 
will use it to build a mini system for recreates of this sort.

Thanks,
Shahar


On 03/07/2017 03:41 PM, Sagi Grimberg wrote:
>
>> Hi,
>>
>> Shahar/Joseph, what is your link layer conf (IB/Eth) ?
>> In eth case, have you configured some PFC ? if not, can you try it ?
>> I suspect that this is the root cause
>
> The root cause is that the device fails frwr in retransmission
> flow, if PFC is not on, it will happen almost immediately, if not
> it will happen at some point...
>
>> and it might help you avoiding
>> this case, meanwhile we're looking for for the best solution.
>>
>> Adding Vladimir that will run iSER on his performance setup with the new
>> fencing patch (not an NVMEoF related issue).
>> We can run also NVMEoF later on if needed.
>
> Thanks.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
