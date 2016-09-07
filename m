From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Wed, 7 Sep 2016 20:37:23 +0530
Message-ID: <CAG53R5U9_QVOAAnbqxWG80G=ROSYjgRXrNkJU1BpcpHCfVOe8A@mail.gmail.com>
References: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
 <1472632647-1525-2-git-send-email-pandit.parav@gmail.com> <20160831093836.GC3694@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160831093836.GC3694@leon.nu>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@lst.de>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Leon,

>> Signed-off-by: Parav Pandit <pandit.parav@gmail.com>
>> +static struct rdmacg_resource_pool *
>> +get_cg_rpool_locked(struct rdma_cgroup *cg, struct rdmacg_device *device)
>> +{
>> +     struct rdmacg_resource_pool *rpool;
>> +
>> +     rpool = find_cg_rpool_locked(cg, device);
>> +     if (rpool)
>> +             return rpool;
>> +
>> +     rpool = kzalloc(sizeof(*rpool), GFP_KERNEL);
>> +     if (!rpool)
>> +             return ERR_PTR(-ENOMEM);
>> +
>> +     rpool->device = device;
>> +     set_all_resource_max_limit(rpool);
>> +
>> +     INIT_LIST_HEAD(&rpool->cg_node);
>> +     INIT_LIST_HEAD(&rpool->dev_node);
>> +     list_add_tail(&rpool->cg_node, &cg->rpools);
>> +     list_add_tail(&rpool->dev_node, &device->rpools);
>> +     return rpool;
>> +}
>
> <...>
>
>> +     for (p = cg; p; p = parent_rdmacg(p)) {
>> +             rpool = get_cg_rpool_locked(p, device);
>> +             if (IS_ERR_OR_NULL(rpool)) {
>
> get_cg_rpool_locked always returns !NULL (error, or pointer)

Can this change go as incremental change after this patch, since this
patch is close to completion?
Or I need to revise v13?

>
>> +                     ret = PTR_ERR(rpool);
>> +                     goto err;
>
> I didn't review the whole series yet.

Did you get a chance to review the series?
