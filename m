From: Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [PATCH mlx5-next] RDMA/mlx5: Don't use cached IRQ affinity mask
Date: Thu, 19 Jul 2018 17:50:40 +0300
Message-ID: <c5362a12-4be6-9f17-7f06-a52aed69e3b6@mellanox.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <02dc01d41ecd$9cc8a0b0$d659e210$@opengridcomputing.com>
Content-Language: he
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, 'Sagi Grimberg' <sagi@grimberg.me>, 'Leon Romanovsky' <leon@kernel.org>
Cc: 'Doug Ledford' <dledford@redhat.com>, 'Jason Gunthorpe' <jgg@mellanox.com>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'Saeed Mahameed' <saeedm@mellanox.com>, 'linux-netdev' <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



On 7/18/2018 10:29 PM, Steve Wise wrote:
> 
>>
>> On 7/18/2018 2:38 PM, Sagi Grimberg wrote:
>>>
>>>>> IMO we must fulfil the user wish to connect to N queues and not reduce
>>>>> it because of affinity overlaps. So in order to push Leon's patch we
>>>>> must also fix the blk_mq_rdma_map_queues to do a best effort
>> mapping
>>>>> according the affinity and map the rest in naive way (in that way we
>>>>> will *always* map all the queues).
>>>>
>>>> That is what I would expect also.   For example, in my node, where
>>>> there are
>>>> 16 cpus, and 2 numa nodes, I observe much better nvmf IOPS
>> performance by
>>>> setting up my 16 driver completion event queues such that each is
>>>> bound to a
>>>> node-local cpu.  So I end up with each nodel-local cpu having 2 queues
>>>> bound
>>>> to it.   W/O adding support in iw_cxgb4 for ib_get_vector_affinity(),
>>>> this
>>>> works fine.   I assumed adding ib_get_vector_affinity() would allow
>>>> this to
>>>> all "just work" by default, but I'm running into this connection failure
>>>> issue.
>>>>
>>>> I don't understand exactly what the blk_mq layer is trying to do, but I
>>>> assume it has ingress event queues and processing that it trying to align
>>>> with the drivers ingress cq event handling, so everybody stays on the
>>>> same
>>>> cpu (or at least node).   But something else is going on.  Is there
>>>> documentation on how this works somewhere?
>>>
>>> Does this (untested) patch help?
>>
>> I'm not sure (I'll test it tomorrow) because the issue is the unmapped
>> queues and not the cpus.
>> for example, if the affinity of q=6 and q=12 returned the same cpumask
>> than q=6 will not be mapped and will fail to connect.
>>
> 
> Attached is a patch that applies cleanly for me.  It has problems if vectors have affinity to more than 1 cpu:
> 
> [ 2031.988881] iw_cxgb4: comp_vector 0, irq 203 mask 0xff00
> [ 2031.994706] iw_cxgb4: comp_vector 1, irq 204 mask 0xff00
> [ 2032.000348] iw_cxgb4: comp_vector 2, irq 205 mask 0xff00
> [ 2032.005992] iw_cxgb4: comp_vector 3, irq 206 mask 0xff00
> [ 2032.011629] iw_cxgb4: comp_vector 4, irq 207 mask 0xff00
> [ 2032.017271] iw_cxgb4: comp_vector 5, irq 208 mask 0xff00
> [ 2032.022901] iw_cxgb4: comp_vector 6, irq 209 mask 0xff00
> [ 2032.028514] iw_cxgb4: comp_vector 7, irq 210 mask 0xff00
> [ 2032.034110] iw_cxgb4: comp_vector 8, irq 211 mask 0xff00
> [ 2032.039677] iw_cxgb4: comp_vector 9, irq 212 mask 0xff00
> [ 2032.045244] iw_cxgb4: comp_vector 10, irq 213 mask 0xff00
> [ 2032.050889] iw_cxgb4: comp_vector 11, irq 214 mask 0xff00
> [ 2032.056531] iw_cxgb4: comp_vector 12, irq 215 mask 0xff00
> [ 2032.062174] iw_cxgb4: comp_vector 13, irq 216 mask 0xff00
> [ 2032.067817] iw_cxgb4: comp_vector 14, irq 217 mask 0xff00
> [ 2032.073457] iw_cxgb4: comp_vector 15, irq 218 mask 0xff00
> [ 2032.079102] blk_mq_rdma_map_queues: set->mq_map[0] queue 0 vector 0
> [ 2032.085621] blk_mq_rdma_map_queues: set->mq_map[1] queue 1 vector 1
> [ 2032.092139] blk_mq_rdma_map_queues: set->mq_map[2] queue 2 vector 2
> [ 2032.098658] blk_mq_rdma_map_queues: set->mq_map[3] queue 3 vector 3
> [ 2032.105177] blk_mq_rdma_map_queues: set->mq_map[4] queue 4 vector 4
> [ 2032.111689] blk_mq_rdma_map_queues: set->mq_map[5] queue 5 vector 5
> [ 2032.118208] blk_mq_rdma_map_queues: set->mq_map[6] queue 6 vector 6
> [ 2032.124728] blk_mq_rdma_map_queues: set->mq_map[7] queue 7 vector 7
> [ 2032.131246] blk_mq_rdma_map_queues: set->mq_map[8] queue 15 vector 15
> [ 2032.137938] blk_mq_rdma_map_queues: set->mq_map[9] queue 15 vector 15
> [ 2032.144629] blk_mq_rdma_map_queues: set->mq_map[10] queue 15 vector 15
> [ 2032.151401] blk_mq_rdma_map_queues: set->mq_map[11] queue 15 vector 15
> [ 2032.158172] blk_mq_rdma_map_queues: set->mq_map[12] queue 15 vector 15
> [ 2032.164940] blk_mq_rdma_map_queues: set->mq_map[13] queue 15 vector 15
> [ 2032.171709] blk_mq_rdma_map_queues: set->mq_map[14] queue 15 vector 15
> [ 2032.178477] blk_mq_rdma_map_queues: set->mq_map[15] queue 15 vector 15
> [ 2032.187409] nvme nvme0: Connect command failed, error wo/DNR bit: -16402
> [ 2032.194376] nvme nvme0: failed to connect queue: 9 ret=-18

queue 9 is not mapped (overlap).
please try the bellow:

diff --git a/block/blk-mq-rdma.c b/block/blk-mq-rdma.c
index 996167f..a91d611 100644
--- a/block/blk-mq-rdma.c
+++ b/block/blk-mq-rdma.c
@@ -34,14 +34,55 @@ int blk_mq_rdma_map_queues(struct blk_mq_tag_set *set,
  {
         const struct cpumask *mask;
         unsigned int queue, cpu;
+       bool mapped;

+       /* reset all CPUs mapping */
+       for_each_possible_cpu(cpu)
+               set->mq_map[cpu] = UINT_MAX;
+
+       /* Try to map the queues according to affinity */
         for (queue = 0; queue < set->nr_hw_queues; queue++) {
                 mask = ib_get_vector_affinity(dev, first_vec + queue);
                 if (!mask)
                         goto fallback;

-               for_each_cpu(cpu, mask)
-                       set->mq_map[cpu] = queue;
+               for_each_cpu(cpu, mask) {
+                       if (set->mq_map[cpu] == UINT_MAX) {
+                               set->mq_map[cpu] = queue;
+                               /* Initialy each queue mapped to 1 cpu */
+                               break;
+                       }
+               }
+       }
+
+       /* Map the unmapped queues in a naive way */
+       for (queue = 0; queue < set->nr_hw_queues; queue++) {
+               mapped = false;
+               for_each_possible_cpu(cpu) {
+                       if (set->mq_map[cpu] == queue) {
+                               mapped = true;
+                               break;
+                       }
+               }
+               if (!mapped) {
+                       for_each_possible_cpu(cpu) {
+                               if (set->mq_map[cpu] == UINT_MAX) {
+                                       set->mq_map[cpu] = queue;
+                                       mapped = true;
+                                       break;
+                               }
+                       }
+               }
+               /* This case should never happen */
+               if (WARN_ON_ONCE(!mapped))
+                       goto fallback;
+       }
+
+       /* set all the rest of the CPUs */
+       queue = 0;
+       for_each_possible_cpu(cpu) {
+               if (set->mq_map[cpu] == UINT_MAX)
+                       set->mq_map[cpu] = queue++ % set->nr_hw_queues;
         }

         return 0;
