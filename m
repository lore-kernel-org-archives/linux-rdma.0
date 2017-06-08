From: Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3 for-4.13 2/6] mlx5: move affinity hints assignments to
 generic code
Date: Thu, 8 Jun 2017 12:28:54 +0300
Message-ID: <CALzJLG_h8ig97uzz9S_4n-DhcFFi1e+WcUwLejM4cHUFd1MozA@mail.gmail.com>
References: <1496644560-28923-1-git-send-email-sagi@grimberg.me>
 <1496644560-28923-3-git-send-email-sagi@grimberg.me> <CALzJLG-SQj2OsOOjhHsMaD8gKC0JKD068L=ZjYRPBG=iwf9r8Q@mail.gmail.com>
 <20170607083156.GB24876@lst.de> <9332ed02-9711-0196-14d9-e9641c4dc932@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9332ed02-9711-0196-14d9-e9641c4dc932-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 7, 2017 at 12:48 PM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
>
>>> I am not sure the new assignment will match what we tried to do before
>>> this patch, and i would like to preserve that behavior
>>> from before we simply spread comp vectors to the close numa cpus first
>>> then to other cores uniformly.
>>> i.e prefer first IRQs to go to close numa cores.
>>>
>>> for example if you have 2 numa nodes each have 4 cpus, and the device
>>> is on 2nd numa,
>>> Numa 1 cpus: 0 1 2 3
>>> Numa 2 cpus: 4 5 6 7
>>>
>>> this should be the affinity:
>>>
>>> IRQ[0] -> cpu[4] (Numa 2)
>>> IRQ[1] -> cpu[5]
>>> IRQ[2] -> cpu[6]
>>> IRQ[3] -> cpu[7]
>>>
>>> IRQ[4] -> cpu[0] (Numa 1)
>>> IRQ[5] -> cpu[1]
>>> IRQ[6] -> cpu[2]
>>> IRQ[7] -> cpu[3]
>>>
>>> looking at irq_create_affinity_masks, and it seems not to be the case !
>>> "nodemask_t nodemsk = NODE_MASK_NONE;" it doesn't seem to prefer any numa
>>> node.
>>
>>
>> nodemsk is set up by get_nodes_in_cpumask.  The mask you should
>> get with the new code is:
>>
>> IRQ[0] -> cpu[0] (Numa 1)
>> IRQ[1] -> cpu[1]
>> IRQ[2] -> cpu[2]
>> IRQ[3] -> cpu[3]
>>
>> IRQ[4] -> cpu[4] (Numa 2)
>> IRQ[5] -> cpu[5]
>> IRQ[6] -> cpu[6]
>> IRQ[7] -> cpu[7]
>>
>> is there any reason you want to start assining vectors on the local
>> node?  This is doable, but would complicate the code quite a bit
>> so it needs a good argument.
>
>
> My interpretation is that mlx5 tried to do this for the (rather esoteric
> in my mind) case where the platform does not have enough vectors for the
> driver to allocate percpu. In this case, the next best thing is to stay
> as close to the device affinity as possible.
>

No, we did it for the reason that mlx5e netdevice assumes that
IRQ[0]..IRQ[#num_numa/#cpu_per_numa]
are always bound to the numa close to the device. and the mlx5e driver
choose those IRQs to spread
the RSS hash only into them and never uses other IRQs/Cores

which means with the current mlx5e code
(mlx5e_build_default_indir_rqt), there is a good chance the driver
will only use
cpus/IRQs on the far numa for it's RX traffic.

one way to fix this is to change mlx5e_build_default_indir_rqt to not
have this assumption and spread the RSS hash across
all the IRQs.

But this will increase the risk of conflicting with current net-next,
is Doug ok with this ? did we merge test ?

>>> I am sure that there is a way to force our mlx5 affinity strategy and
>>> override the default one with the new API.
>>
>>
>> No, there is not.  The whole point is that we want to come up with
>> a common policy instead of each driver doing their own weird little
>> thing.
>
>
> Agreed.
>
>

I can live with that, but please address the above, since it will be a
regression.

>>>> -static int mlx5e_get_cpu(struct mlx5e_priv *priv, int ix)
>>>> -{
>>>> -       return cpumask_first(priv->mdev->priv.irq_info[ix].mask);
>>>> -}
>>>>
>>>
>>> let's keep this abstraction, even let's consider moving this to a
>>> helper function in the mlx5_core dirver main.c,
>>> it is not right when mlx5_ib and mlx5e netdev know about internal mdev
>>> structures and implementations of stuff.
>>>
>>> I suggest to move mlx5_ib_get_vector_affinity from patch #4 into
>>> drivers/net/ethernet/../mlx5/core/main.c
>>> and rename it to mlx5_get_vector_affinity and use it from both rdma
>>> and netdevice
>>>
>>> and change the above function to:
>>>
>>> static int mlx5e_get_cpu(struct mlx5e_priv *priv, int ix)
>>> {
>>>         return cpumask_first(mlx5_get_vector_affinity(priv->mdev, ix));
>>> }
>>
>>
>> Take a look at my comment to Sagi's repost.  The driver never
>> actually cares about this weird cpu value - it cares about a node
>> for the vectors and PCI layer provides the pci_irq_get_node helper
>> for that.  We could wrap this with a mlx5e helper, but that's not
>> really the normal style in the kernel.
>>
>>>>          int err;
>>>>
>>>> -       c = kzalloc_node(sizeof(*c), GFP_KERNEL, cpu_to_node(cpu));
>>>> +       c = kzalloc_node(sizeof(*c), GFP_KERNEL,
>>>> +               pci_irq_get_node(priv->mdev->pdev, MLX5_EQ_VEC_COMP_BASE
>>>> + ix));
>>>
>>>
>>> this might yield different behavior of what originally intended we
>>> want to get the node of the CPU and not of the IRQ's, maybe there is
>>> no difference but
>
>
> There is no difference, the node of the CPU _is_ the node of the IRQs
> (it originates from irq affinity).
>
>>> let's keep mlx5e_get_cpu abstraction as above.
>>
>>
>> It's a completely bogus abstraction.
>
>
> I tend to agree, but can easily change it.

at least change to to mlx5e_get_node ! As i said i don't want to
pepper the mlx5e code with stuff like
(priv->mdev->pdev, MLX5_EQ_VEC_COMP_BASE + ix) just call
mlx5e_get_channel_node(priv, channel_ix);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
