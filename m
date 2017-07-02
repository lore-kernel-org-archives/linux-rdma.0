From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rfc 0/3] Expose cpu mapping hints to a nvme target port
Date: Sun, 2 Jul 2017 19:30:33 +0300
Message-ID: <b77be367-6cbc-c12c-8135-eddff0aec90e@mellanox.com>
References: <1499007694-7231-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1255"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499007694-7231-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 7/2/2017 6:01 PM, Sagi Grimberg wrote:
> I've heard feedback from folks on several occasions that we can
> improve in a multi-socket target array configuration.
>
> Today, rdma transport simply spread IO threads accross all system cpus
> without any specific configuration in mind (same for fc). It isn't really
> possible to exclude a nvmet port IO threads affinity to a specific
> numa socket which can be useful to reduce the inter-socket DMA traffic.
>
> This can make sense if the user wants to expose a set of backend devices
> via a nvme target port (HBA port) which are connected to the same
> numa-socket in order to optimize NUMA locality and minimize the inter-socket
> DMA traffic.
>
> This RFC exposes a cpu mapping to a specific nvmet port. The user can choose
> to provide a affinity hint a to nvme target port that will contain IO threads
> to specific cpu cores and the transport will _try_ to enforce it (if it knows
> how to). We default to the online cpumap.
>
> Note, this is based on the nvme and rdma msix affinity mapping patches pending
> to 4.13.
>
> Feedback is welcome!

Hi Sagi,
Very interesting patchset. You give a lot of power to the user here, we 
need to hope that he will use it right :).
Do you have some fio numbers to compare w/w.o this series ? also cpu 
utilization measures are interesting too..

>
> Sagi Grimberg (3):
>   nvmet: allow assignment of a cpulist for each nvmet port
>   RDMA/core: expose cpu affinity based completion vector lookup
>   nvmet-rdma: assign cq completion vector based on the port allowed cpus
>
>  drivers/infiniband/core/verbs.c | 41 ++++++++++++++++++++++
>  drivers/nvme/target/configfs.c  | 75 +++++++++++++++++++++++++++++++++++++++++
>  drivers/nvme/target/nvmet.h     |  4 +++
>  drivers/nvme/target/rdma.c      | 40 +++++++++++++++-------
>  include/rdma/ib_verbs.h         |  3 ++
>  5 files changed, 151 insertions(+), 12 deletions(-)
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
