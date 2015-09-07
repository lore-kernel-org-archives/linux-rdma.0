From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Tue, 8 Sep 2015 02:25:20 +0530
Message-ID: <CAG53R5UX42BN_V+AG51UeKB5vCkyHt4d3b-mkO+W+gGqEf6ADA@mail.gmail.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, Doug Ledford <dledford@redhat.com>
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, Haggai Eran <haggaie@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org, Parav Pandit <pandit.parav@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Hi Doug, Tejun,

This is from cgroups for-4.3 branch.
linux-rdma trunk will face compilation error as its behind Tejun's
for-4.3 branch.
Patch has dependency on the some of the cgroup subsystem functionality
for fork().
Therefore its required to merge those changes first to linux-rdma trunk.

Parav


On Tue, Sep 8, 2015 at 2:08 AM, Parav Pandit <pandit.parav@gmail.com> wrote:
> Currently user space applications can easily take away all the rdma
> device specific resources such as AH, CQ, QP, MR etc. Due to which other
> applications in other cgroup or kernel space ULPs may not even get chance
> to allocate any rdma resources.
>
> This patch-set allows limiting rdma resources to set of processes.
> It extend device cgroup controller for limiting rdma device limits.
>
> With this patch, user verbs module queries rdma device cgroup controller
> to query process's limit to consume such resource. It uncharge resource
> counter after resource is being freed.
>
> It extends the task structure to hold the statistic information about process's
> rdma resource usage so that when process migrates from one to other controller,
> right amount of resources can be migrated from one to other cgroup.
>
> Future patches will support RDMA flows resource and will be enhanced further
> to enforce limit of other resources and capabilities.
>
> Parav Pandit (7):
>   devcg: Added user option to rdma resource tracking.
>   devcg: Added rdma resource tracking module.
>   devcg: Added infrastructure for rdma device cgroup.
>   devcg: Added rdma resource tracker object per task
>   devcg: device cgroup's extension for RDMA resource.
>   devcg: Added support to use RDMA device cgroup.
>   devcg: Added Documentation of RDMA device cgroup.
>
>  Documentation/cgroups/devices.txt     |  32 ++-
>  drivers/infiniband/core/uverbs_cmd.c  | 139 +++++++++--
>  drivers/infiniband/core/uverbs_main.c |  39 +++-
>  include/linux/device_cgroup.h         |  53 +++++
>  include/linux/device_rdma_cgroup.h    |  83 +++++++
>  include/linux/sched.h                 |  12 +-
>  init/Kconfig                          |  12 +
>  security/Makefile                     |   1 +
>  security/device_cgroup.c              | 119 +++++++---
>  security/device_rdma_cgroup.c         | 422 ++++++++++++++++++++++++++++++++++
>  10 files changed, 850 insertions(+), 62 deletions(-)
>  create mode 100644 include/linux/device_rdma_cgroup.h
>  create mode 100644 security/device_rdma_cgroup.c
>
> --
> 1.8.3.1
>
