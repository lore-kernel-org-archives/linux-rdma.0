From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH mlx5-next] RDMA/mlx5: Don't use cached IRQ affinity mask
Date: Mon, 6 Aug 2018 14:20:37 -0500
Message-ID: <47178d4d-f730-6e59-5c19-58331cc3864a@opengridcomputing.com>
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
 <b0f6a58a-0078-05a2-a7f9-946b2ff21846@grimberg.me>
 <f1442839-ff32-ab80-9eab-6923456fe272@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <f1442839-ff32-ab80-9eab-6923456fe272@mellanox.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Max Gurtovoy <maxg@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, Jason Gunthorpe <jgg@mellanox.com>
Cc: 'Leon Romanovsky' <leon@kernel.org>, 'Doug Ledford' <dledford@redhat.com>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'Saeed Mahameed' <saeedm@mellanox.com>, 'linux-netdev' <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



On 8/1/2018 9:27 AM, Max Gurtovoy wrote:
>
>
> On 8/1/2018 8:12 AM, Sagi Grimberg wrote:
>> Hi Max,
>
> Hi,
>
>>
>>> Yes, since nvmf is the only user of this function.
>>> Still waiting for comments on the suggested patch :)
>>>
>>
>> Sorry for the late response (but I'm on vacation so I have
>> an excuse ;))
>
> NP :) currently the code works..
>
>>
>> I'm thinking that we should avoid trying to find an assignment
>> when stuff like irqbalance daemon is running and changing
>> the affinitization.
>
> but this is exactly what Steve complained and Leon try to fix (and
> break the connection establishment).
> If this is the case and we all agree then we're good without Leon's
> patch and without our suggestions.
>

I don't agree.  Currently setting certain affinity mappings breaks nvme
connectivity.  I don't think that is desirable.  And mlx5 is broken in
that it doesn't allow changing the affinity but silently ignores the
change, which misleads the admin or irqbalance...
 


>>
>> This extension was made to apply optimal affinity assignment
>> when the device irq affinity is lined up in a vector per
>> core.
>>
>> I'm thinking that when we identify this is not the case, we immediately
>> fallback to the default mapping.
>>
>> 1. when we get a mask, if its weight != 1, we fallback.
>> 2. if a queue was left unmapped, we fallback.
>>
>> Maybe something like the following:
>
> did you test it ? I think it will not work since you need to map all
> the queues and all the CPUs.
>
>> -- 
>> diff --git a/block/blk-mq-rdma.c b/block/blk-mq-rdma.c
>> index 996167f1de18..1ada6211c55e 100644
>> --- a/block/blk-mq-rdma.c
>> +++ b/block/blk-mq-rdma.c
>> @@ -35,17 +35,26 @@ int blk_mq_rdma_map_queues(struct blk_mq_tag_set
>> *set,
>>          const struct cpumask *mask;
>>          unsigned int queue, cpu;
>>
>> +       /* reset all CPUs mapping */
>> +       for_each_possible_cpu(cpu)
>> +               set->mq_map[cpu] = UINT_MAX;
>> +
>>          for (queue = 0; queue < set->nr_hw_queues; queue++) {
>>                  mask = ib_get_vector_affinity(dev, first_vec + queue);
>>                  if (!mask)
>>                          goto fallback;
>>
>> -               for_each_cpu(cpu, mask)
>> -                       set->mq_map[cpu] = queue;
>> +               if (cpumask_weight(mask) != 1)
>> +                       goto fallback;
>> +
>> +               cpu = cpumask_first(mask);
>> +               if (set->mq_map[cpu] != UINT_MAX)
>> +                       goto fallback;
>> +
>> +               set->mq_map[cpu] = queue;
>>          }
>>
>>          return 0;
>> -
>>   fallback:
>>          return blk_mq_map_queues(set);
>>   }
>> -- 
>
> see attached another algorithem that can improve the mapping (although
> it's not a short one)...
>
> it will try to map according to affinity mask, and also in case the
> mask weight > 1 it will try to be better than the naive mapping I
> suggest in the previous email.
>

Let me know if you want me to try this or any particular fix.

Steve.
