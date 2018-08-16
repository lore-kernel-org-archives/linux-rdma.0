From: Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH mlx5-next] RDMA/mlx5: Don't use cached IRQ affinity mask
Date: Thu, 16 Aug 2018 13:32:27 -0500
Message-ID: <85bba372-049c-2a12-362e-adcb0931cf49@opengridcomputing.com>
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
 <47178d4d-f730-6e59-5c19-58331cc3864a@opengridcomputing.com>
 <4a13541c-db48-beca-4ee7-932528b22986@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <4a13541c-db48-beca-4ee7-932528b22986@grimberg.me>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: 'Leon Romanovsky' <leon@kernel.org>, 'Doug Ledford' <dledford@redhat.com>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'Saeed Mahameed' <saeedm@mellanox.com>, 'linux-netdev' <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



On 8/16/2018 1:26 PM, Sagi Grimberg wrote:
>
>> Let me know if you want me to try this or any particular fix.
>
> Steve, can you test this one?

Yes!  I'll try it out tomorrow. 

Stevo

> -- 
> [PATCH rfc] block: fix rdma queue mapping
>
> nvme-rdma attempts to map queues based on irq vector affinity.
> However, for some devices, completion vector irq affinity is
> configurable by the user which can break the existing assumption
> that irq vectors are optimally arranged over the host cpu cores.
>
> So we map queues in two stages:
> First map queues according to corresponding to the completion
> vector IRQ affinity taking the first cpu in the vector affinity map.
> if the current irq affinity is arranged such that a vector is not
> assigned to any distinct cpu, we map it to a cpu that is on the same
> node. If numa affinity can not be sufficed, we map it to any unmapped
> cpu we can find. Then, map the remaining cpus in the possible cpumap
> naively.
>
> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
> ---
> Steve, can you test out this patch?
>  block/blk-mq-cpumap.c  | 39 +++++++++++++-----------
>  block/blk-mq-rdma.c    | 80
> +++++++++++++++++++++++++++++++++++++++++++-------
>  include/linux/blk-mq.h |  1 +
>  3 files changed, 93 insertions(+), 27 deletions(-)
>
> diff --git a/block/blk-mq-cpumap.c b/block/blk-mq-cpumap.c
> index 3eb169f15842..34811db8cba9 100644
> --- a/block/blk-mq-cpumap.c
> +++ b/block/blk-mq-cpumap.c
> @@ -30,30 +30,35 @@ static int get_first_sibling(unsigned int cpu)
>         return cpu;
>  }
>
> -int blk_mq_map_queues(struct blk_mq_tag_set *set)
> +void blk_mq_map_queue_cpu(struct blk_mq_tag_set *set, unsigned int cpu)
>  {
>         unsigned int *map = set->mq_map;
>         unsigned int nr_queues = set->nr_hw_queues;
> -       unsigned int cpu, first_sibling;
> +       unsigned int first_sibling;
>
> -       for_each_possible_cpu(cpu) {
> -               /*
> -                * First do sequential mapping between CPUs and queues.
> -                * In case we still have CPUs to map, and we have some
> number of
> -                * threads per cores then map sibling threads to the
> same queue for
> -                * performace optimizations.
> -                */
> -               if (cpu < nr_queues) {
> +       /*
> +        * First do sequential mapping between CPUs and queues.
> +        * In case we still have CPUs to map, and we have some number of
> +        * threads per cores then map sibling threads to the same
> queue for
> +        * performace optimizations.
> +        */
> +       if (cpu < nr_queues) {
> +               map[cpu] = cpu_to_queue_index(nr_queues, cpu);
> +       } else {
> +               first_sibling = get_first_sibling(cpu);
> +               if (first_sibling == cpu)
>                         map[cpu] = cpu_to_queue_index(nr_queues, cpu);
> -               } else {
> -                       first_sibling = get_first_sibling(cpu);
> -                       if (first_sibling == cpu)
> -                               map[cpu] =
> cpu_to_queue_index(nr_queues, cpu);
> -                       else
> -                               map[cpu] = map[first_sibling];
> -               }
> +               else
> +                       map[cpu] = map[first_sibling];
>         }
> +}
> +
> +int blk_mq_map_queues(struct blk_mq_tag_set *set)
> +{
> +       unsigned int cpu;
>
> +       for_each_possible_cpu(cpu)
> +               blk_mq_map_queue_cpu(set, cpu);
>         return 0;
>  }
>  EXPORT_SYMBOL_GPL(blk_mq_map_queues);
> diff --git a/block/blk-mq-rdma.c b/block/blk-mq-rdma.c
> index 996167f1de18..d04cbb1925f5 100644
> --- a/block/blk-mq-rdma.c
> +++ b/block/blk-mq-rdma.c
> @@ -14,6 +14,61 @@
>  #include <linux/blk-mq-rdma.h>
>  #include <rdma/ib_verbs.h>
>
> +static int blk_mq_rdma_map_queue(struct blk_mq_tag_set *set,
> +               struct ib_device *dev, int first_vec, unsigned int queue)
> +{
> +       const struct cpumask *mask;
> +       unsigned int cpu;
> +       bool mapped = false;
> +
> +       mask = ib_get_vector_affinity(dev, first_vec + queue);
> +       if (!mask)
> +               return -ENOTSUPP;
> +
> +       /* map with an unmapped cpu according to affinity mask */
> +       for_each_cpu(cpu, mask) {
> +               if (set->mq_map[cpu] == UINT_MAX) {
> +                       set->mq_map[cpu] = queue;
> +                       mapped = true;
> +                       break;
> +               }
> +       }
> +
> +       if (!mapped) {
> +               int n;
> +
> +               /* map with an unmapped cpu in the same numa node */
> +               for_each_node(n) {
> +                       const struct cpumask *node_cpumask =
> cpumask_of_node(n);
> +
> +                       if (!cpumask_intersects(mask, node_cpumask))
> +                               continue;
> +
> +                       for_each_cpu(cpu, node_cpumask) {
> +                               if (set->mq_map[cpu] == UINT_MAX) {
> +                                       set->mq_map[cpu] = queue;
> +                                       mapped = true;
> +                                       break;
> +                               }
> +                       }
> +               }
> +       }
> +
> +       if (!mapped) {
> +               /* map with any unmapped cpu we can find */
> +               for_each_possible_cpu(cpu) {
> +                       if (set->mq_map[cpu] == UINT_MAX) {
> +                               set->mq_map[cpu] = queue;
> +                               mapped = true;
> +                               break;
> +                       }
> +               }
> +       }
> +
> +       WARN_ON_ONCE(!mapped);
> +       return 0;
> +}
> +
>  /**
>   * blk_mq_rdma_map_queues - provide a default queue mapping for rdma
> device
>   * @set:       tagset to provide the mapping for
> @@ -21,31 +76,36 @@
>   * @first_vec: first interrupt vectors to use for queues (usually 0)
>   *
>   * This function assumes the rdma device @dev has at least as many
> available
> - * interrupt vetors as @set has queues.  It will then query it's
> affinity mask
> - * and built queue mapping that maps a queue to the CPUs that have
> irq affinity
> - * for the corresponding vector.
> + * interrupt vetors as @set has queues.  It will then query vector
> affinity mask
> + * and attempt to build irq affinity aware queue mappings. If optimal
> affinity
> + * aware mapping cannot be acheived for a given queue, we look for
> any unmapped
> + * cpu to map it. Lastly, we map naively all other unmapped cpus in
> the mq_map.
>   *
>   * In case either the driver passed a @dev with less vectors than
>   * @set->nr_hw_queues, or @dev does not provide an affinity mask for a
>   * vector, we fallback to the naive mapping.
>   */
>  int blk_mq_rdma_map_queues(struct blk_mq_tag_set *set,
> -               struct ib_device *dev, int first_vec)
> +                struct ib_device *dev, int first_vec)
>  {
> -       const struct cpumask *mask;
>         unsigned int queue, cpu;
>
> +       /* reset cpu mapping */
> +       for_each_possible_cpu(cpu)
> +               set->mq_map[cpu] = UINT_MAX;
> +
>         for (queue = 0; queue < set->nr_hw_queues; queue++) {
> -               mask = ib_get_vector_affinity(dev, first_vec + queue);
> -               if (!mask)
> +               if (blk_mq_rdma_map_queue(set, dev, first_vec, queue))
>                         goto fallback;
> +       }
>
> -               for_each_cpu(cpu, mask)
> -                       set->mq_map[cpu] = queue;
> +       /* map any remaining unmapped cpus */
> +       for_each_possible_cpu(cpu) {
> +               if (set->mq_map[cpu] == UINT_MAX)
> +                       blk_mq_map_queue_cpu(set, cpu);;
>         }
>
>         return 0;
> -
>  fallback:
>         return blk_mq_map_queues(set);
>  }
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index d710e92874cc..6eb09c4de34f 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -285,6 +285,7 @@ int blk_mq_freeze_queue_wait_timeout(struct
> request_queue *q,
>                                      unsigned long timeout);
>
>  int blk_mq_map_queues(struct blk_mq_tag_set *set);
> +void blk_mq_map_queue_cpu(struct blk_mq_tag_set *set, unsigned int cpu);
>  void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int
> nr_hw_queues);
>
>  void blk_mq_quiesce_queue_nowait(struct request_queue *q);
> -- 
