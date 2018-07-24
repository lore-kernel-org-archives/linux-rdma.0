From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH mlx5-next] RDMA/mlx5: Don't use cached IRQ affinity mask
Date: Tue, 24 Jul 2018 10:24:03 -0500
Message-ID: <e32726b5-fbe5-178c-719e-8a71517977b0@opengridcomputing.com>
References: <20180716083012.15410-1-leon@kernel.org>
 <0cf29652-9034-6283-ef36-95de4588980f@grimberg.me>
 <20180716103046.GJ3152@mtr-leonro.mtl.com>
 <1cb63259-9fb6-59b0-3a34-0659973228ea@mellanox.com>
 <d8f375d7-8a1f-39f5-5fd6-0bdc781f1465@grimberg.me>
 <40d49fe1-c548-31ec-7daa-b19056215d69@mellanox.com>
 <243215dc-2b06-9c99-a0cb-8a45e0257077@opengridcomputing.com>
 <3f827784-3089-2375-9feb-b3c1701d7471@mellanox.com>
 <01cd01d41dce$992f4f30$cb8ded90$@opengridcomputing.com>
 <0834cae6-33d6-3526-7d85-f5cae18c5487@grimberg.me>
 <9a4d8d50-19b0-fcaa-d4a3-6cfa2318a973@mellanox.com>
 <02dc01d41ecd$9cc8a0b0$d659e210$@opengridcomputing.com>
 <c5362a12-4be6-9f17-7f06-a52aed69e3b6@mellanox.com>
 <a9c4a70d-d578-0581-09aa-a3a56f3b2c02@opengridcomputing.com>
 <f936d176-c56b-143e-3311-f6df48f633dd@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <f936d176-c56b-143e-3311-f6df48f633dd@mellanox.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Max Gurtovoy <maxg@mellanox.com>, 'Sagi Grimberg' <sagi@grimberg.me>, 'Leon Romanovsky' <leon@kernel.org>
Cc: 'Doug Ledford' <dledford@redhat.com>, 'Jason Gunthorpe' <jgg@mellanox.com>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'Saeed Mahameed' <saeedm@mellanox.com>, 'linux-netdev' <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



On 7/19/2018 8:25 PM, Max Gurtovoy wrote:
>
>>>> [ 2032.194376] nvme nvme0: failed to connect queue: 9 ret=-18
>>>
>>> queue 9 is not mapped (overlap).
>>> please try the bellow:
>>>
>>
>> This seems to work.  Here are three mapping cases:  each vector on its
>> own cpu, each vector on 1 cpu within the local numa node, and each
>> vector having all cpus in its numa node.  The 2nd mapping looks kinda
>> funny, but I think it achieved what you wanted?  And all the cases
>> resulted in successful connections.
>>
>
> Thanks for testing this.
> I slightly improved the setting of the left CPUs and actually used
> Sagi's initial proposal.
>
> Sagi,
> please review the attached patch and let me know if I should add your
> signature on it.
> I'll run some perf test early next week on it (meanwhile I run
> login/logout with different num_queues successfully and irq settings).
>
> Steve,
> It will be great if you can apply the attached in your system and send
> your findings.

Sorry, I got side tracked.  I'll try and test this today and report back.

Steve.
