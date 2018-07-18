From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH mlx5-next] RDMA/mlx5: Don't use cached IRQ affinity mask
Date: Wed, 18 Jul 2018 14:38:25 +0300
Message-ID: <0834cae6-33d6-3526-7d85-f5cae18c5487@grimberg.me>
References: <20180716083012.15410-1-leon@kernel.org>
 <0cf29652-9034-6283-ef36-95de4588980f@grimberg.me>
 <20180716103046.GJ3152@mtr-leonro.mtl.com>
 <1cb63259-9fb6-59b0-3a34-0659973228ea@mellanox.com>
 <d8f375d7-8a1f-39f5-5fd6-0bdc781f1465@grimberg.me>
 <40d49fe1-c548-31ec-7daa-b19056215d69@mellanox.com>
 <243215dc-2b06-9c99-a0cb-8a45e0257077@opengridcomputing.com>
 <3f827784-3089-2375-9feb-b3c1701d7471@mellanox.com>
 <01cd01d41dce$992f4f30$cb8ded90$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <01cd01d41dce$992f4f30$cb8ded90$@opengridcomputing.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, 'Max Gurtovoy' <maxg@mellanox.com>, 'Leon Romanovsky' <leon@kernel.org>
Cc: 'Doug Ledford' <dledford@redhat.com>, 'Jason Gunthorpe' <jgg@mellanox.com>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'Saeed Mahameed' <saeedm@mellanox.com>, 'linux-netdev' <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


>> IMO we must fulfil the user wish to connect to N queues and not reduce
>> it because of affinity overlaps. So in order to push Leon's patch we
>> must also fix the blk_mq_rdma_map_queues to do a best effort mapping
>> according the affinity and map the rest in naive way (in that way we
>> will *always* map all the queues).
> 
> That is what I would expect also.   For example, in my node, where there are
> 16 cpus, and 2 numa nodes, I observe much better nvmf IOPS performance by
> setting up my 16 driver completion event queues such that each is bound to a
> node-local cpu.  So I end up with each nodel-local cpu having 2 queues bound
> to it.   W/O adding support in iw_cxgb4 for ib_get_vector_affinity(), this
> works fine.   I assumed adding ib_get_vector_affinity() would allow this to
> all "just work" by default, but I'm running into this connection failure
> issue.
> 
> I don't understand exactly what the blk_mq layer is trying to do, but I
> assume it has ingress event queues and processing that it trying to align
> with the drivers ingress cq event handling, so everybody stays on the same
> cpu (or at least node).   But something else is going on.  Is there
> documentation on how this works somewhere?

Does this (untested) patch help?
--
diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
index 3eb169f15842..dbe962cb537d 100644
--- a/block/blk-mq-cpumap.c
+++ b/block/blk-mq-cpumap.c
@@ -30,29 +30,34 @@ static int get_first_sibling(unsigned int cpu)
         return cpu;
  }

-int blk_mq_map_queues(struct blk_mq_tag_set *set)
+void blk_mq_map_queue(struct blk_mq_tag_set *set, unsigned int cpu)
  {
         unsigned int *map = set->mq_map;
         unsigned int nr_queues = set->nr_hw_queues;
-       unsigned int cpu, first_sibling;
+       unsigned int first_sibling;

-       for_each_possible_cpu(cpu) {
-               /*
-                * First do sequential mapping between CPUs and queues.
-                * In case we still have CPUs to map, and we have some 
number of
-                * threads per cores then map sibling threads to the 
same queue for
-                * performace optimizations.
-                */
-               if (cpu < nr_queues) {
+       /*
+        * First do sequential mapping between CPUs and queues.
+        * In case we still have CPUs to map, and we have some number of
+        * threads per cores then map sibling threads to the same queue for
+        * performace optimizations.
+        */
+       if (cpu < nr_queues) {
+               map[cpu] = cpu_to_queue_index(nr_queues, cpu);
+       } else {
+               first_sibling = get_first_sibling(cpu);
+               if (first_sibling == cpu)
                         map[cpu] = cpu_to_queue_index(nr_queues, cpu);
-               } else {
-                       first_sibling = get_first_sibling(cpu);
-                       if (first_sibling == cpu)
-                               map[cpu] = cpu_to_queue_index(nr_queues, 
cpu);
-                       else
-                               map[cpu] = map[first_sibling];
-               }
+               else
+                       map[cpu] = map[first_sibling];
         }
+}
+EXPORT_SYMBOL_GPL(blk_mq_map_queue);
+
+int blk_mq_map_queues(struct blk_mq_tag_set *set)
+{
+       for_each_possible_cpu(cpu)
+                blk_mq_map_queue(set, cpu);

         return 0;
  }
diff --git a/block/blk-mq-rdma.c b/block/blk-mq-rdma.c
index 996167f1de18..5e91789bea5b 100644
--- a/block/blk-mq-rdma.c
+++ b/block/blk-mq-rdma.c
@@ -35,6 +35,10 @@ int blk_mq_rdma_map_queues(struct blk_mq_tag_set *set,
         const struct cpumask *mask;
         unsigned int queue, cpu;

+       /* reset all to  */
+       for_each_possible_cpu(cpu)
+               set->mq_map[cpu] = UINT_MAX;
+
         for (queue = 0; queue < set->nr_hw_queues; queue++) {
                 mask = ib_get_vector_affinity(dev, first_vec + queue);
                 if (!mask)
@@ -44,6 +48,11 @@ int blk_mq_rdma_map_queues(struct blk_mq_tag_set *set,
                         set->mq_map[cpu] = queue;
         }

+       for_each_possible_cpu(cpu) {
+               if (set->mq_map[cpu] == UINT_MAX)
+                       blk_mq_map_queue(set, cpu);
+       }
+
         return 0;

  fallback:
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index e3147eb74222..7a9848a82475 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -283,6 +283,7 @@ int blk_mq_freeze_queue_wait_timeout(struct 
request_queue *q,
                                      unsigned long timeout);

  int blk_mq_map_queues(struct blk_mq_tag_set *set);
+void blk_mq_map_queue(struct blk_mq_tag_set *set, unsigned int cpu);
  void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int 
nr_hw_queues);

  void blk_mq_quiesce_queue_nowait(struct request_queue *q);
