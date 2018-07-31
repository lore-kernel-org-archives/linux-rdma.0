From: Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [PATCH mlx5-next] RDMA/mlx5: Don't use cached IRQ affinity mask
Date: Tue, 31 Jul 2018 13:00:26 +0300
Message-ID: <0d157d91-2bf1-4585-f486-bd05a77e4cd8@mellanox.com>
References: <40d49fe1-c548-31ec-7daa-b19056215d69@mellanox.com>
 <243215dc-2b06-9c99-a0cb-8a45e0257077@opengridcomputing.com>
 <3f827784-3089-2375-9feb-b3c1701d7471@mellanox.com>
 <01cd01d41dce$992f4f30$cb8ded90$@opengridcomputing.com>
 <0834cae6-33d6-3526-7d85-f5cae18c5487@grimberg.me>
 <9a4d8d50-19b0-fcaa-d4a3-6cfa2318a973@mellanox.com>
 <02dc01d41ecd$9cc8a0b0$d659e210$@opengridcomputing.com>
 <c5362a12-4be6-9f17-7f06-a52aed69e3b6@mellanox.com>
 <a9c4a70d-d578-0581-09aa-a3a56f3b2c02@opengridcomputing.com>
 <f936d176-c56b-143e-3311-f6df48f633dd@mellanox.com>
 <20180723164910.GS31540@mellanox.com>
 <c079b7b4-bff8-8ffe-0be5-e470c86479b4@mellanox.com>
 <ec4ba167-d5a3-adac-3df9-c8b84b7fb821@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <ec4ba167-d5a3-adac-3df9-c8b84b7fb821@opengridcomputing.com>
Content-Language: he
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, 'Sagi Grimberg' <sagi@grimberg.me>
Cc: Jason Gunthorpe <jgg@mellanox.com>, 'Leon Romanovsky' <leon@kernel.org>, 'Doug Ledford' <dledford@redhat.com>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'Saeed Mahameed' <saeedm@mellanox.com>, 'linux-netdev' <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



On 7/30/2018 6:47 PM, Steve Wise wrote:
> 
> 
> On 7/23/2018 11:53 AM, Max Gurtovoy wrote:
>>
>>
>> On 7/23/2018 7:49 PM, Jason Gunthorpe wrote:
>>> On Fri, Jul 20, 2018 at 04:25:32AM +0300, Max Gurtovoy wrote:
>>>>
>>>>>>> [ 2032.194376] nvme nvme0: failed to connect queue: 9 ret=-18
>>>>>>
>>>>>> queue 9 is not mapped (overlap).
>>>>>> please try the bellow:
>>>>>>
>>>>>
>>>>> This seems to work.  Here are three mapping cases:  each vector on its
>>>>> own cpu, each vector on 1 cpu within the local numa node, and each
>>>>> vector having all cpus in its numa node.  The 2nd mapping looks kinda
>>>>> funny, but I think it achieved what you wanted?  And all the cases
>>>>> resulted in successful connections.
>>>>>
>>>>
>>>> Thanks for testing this.
>>>> I slightly improved the setting of the left CPUs and actually used
>>>> Sagi's
>>>> initial proposal.
>>>>
>>>> Sagi,
>>>> please review the attached patch and let me know if I should add your
>>>> signature on it.
>>>> I'll run some perf test early next week on it (meanwhile I run
>>>> login/logout
>>>> with different num_queues successfully and irq settings).
>>>>
>>>> Steve,
>>>> It will be great if you can apply the attached in your system and
>>>> send your
>>>> findings.
>>>>
>>>> Regards,
>>>> Max,
>>>
>>> So the conlusion to this thread is that Leon's mlx5 patch needs to wait
>>> until this block-mq patch is accepted?
>>
>> Yes, since nvmf is the only user of this function.
>> Still waiting for comments on the suggested patch :)
> 
> Hey Sagi, what do you think of Max's patch?
> 
> Max, should you resend this in a form suitable for merging?

Yes, we have already a small improvment of the naive step.
but first I want to see some feedback from other maintainers as well.

> 
> Thanks,
> 
> Steve.
> 
