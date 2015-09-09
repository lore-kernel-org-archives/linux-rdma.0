From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCH 0/7] devcg: device cgroup extension for rdma resource
Date: Wed, 9 Sep 2015 09:27:40 +0530
Message-ID: <CAG53R5VnYJ9+VEKtbnFO1HntSp=O=ZGiknucbQ-QLuEk_UP44w@mail.gmail.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
	<20150908152340.GA13749@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150908152340.GA13749@mtj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Haggai Eran <haggaie@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 8, 2015 at 8:53 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Parav.
>
> On Tue, Sep 08, 2015 at 02:08:16AM +0530, Parav Pandit wrote:
>> Currently user space applications can easily take away all the rdma
>> device specific resources such as AH, CQ, QP, MR etc. Due to which other
>> applications in other cgroup or kernel space ULPs may not even get chance
>> to allocate any rdma resources.
>
> Is there something simple I can read up on what each resource is?
> What's the usual access control mechanism?
>
Hi Tejun,
This is one old white paper, but most of the reasoning still holds true on RDMA.
http://h10032.www1.hp.com/ctg/Manual/c00257031.pdf

More notes on RDMA resources and summary:
RDMA allows data transport from one system to other system where RDMA
device implements OSI layers 4 to 1 typically in hardware, drivers.
RDMA device provides data path semantics to perform data transfer in
zero copy manner from one to other host, very similar to local dma
controller.
It also allows data transfer operation from user space application of
one to other system.
In order to do so, all the resources are created using trusted kernel
space which also provides isolation among applications.
These resources include are-  QP (queue pair) to transfer data, CQ
(Completion queue) to indicate completion of data transfer operation,
MR (memory region) to represent user application memory as source or
destination for data transfer.
Common resources are QP, SRQ (shared received queue), CQ, MR, AH
(Address handle), FLOW, PD (protection domain), user context etc.

>> This patch-set allows limiting rdma resources to set of processes.
>> It extend device cgroup controller for limiting rdma device limits.
>
> I don't think this belongs to devcg.  If these make sense as a set of
> resources to be controlled via cgroup, the right way prolly would be a
> separate controller.
>

In past there has been similar comment to have dedicated cgroup
controller for RDMA instead of merging with device cgroup.
I am ok with both the approach, however I prefer to utilize device
controller instead of spinning of new controller for new devices
category.
I anticipate more such need would arise and for new device category,
it might not be worth to have new cgroup controller.
RapidIO though very less popular and upcoming PCIe are on horizon to
offer similar benefits as that of RDMA and in future having one
controller for each of them again would not be right approach.

I certainly seek your and others inputs in this email thread here whether
(a) to continue to extend device cgroup (which support character,
block devices white list) and now RDMA devices
or
(b) to spin of new controller, if so what are the compelling reasons
that it can provide compare to extension.

Current scope of the patch is limited to RDMA resources as first
patch, but for fact I am sure that there are more functionality in
pipe to support via this cgroup by me and others.
So keeping atleast these two aspects in mind, I need input on
direction of dedicated controller or new one.

In future, I anticipate that we might have sub directory to device
cgroup for individual device class to control.
such as,
<sys/fs/cgroup/devices/
     /char
     /block
     /rdma
     /pcie
     /child_cgroup..1..N
Each controllers cgroup access files would remain within their own
scope. We are not there yet from base infrastructure but something to
be done as it matures and users start using it.

> Thanks.
>
> --
> tejun
