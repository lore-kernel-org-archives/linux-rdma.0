From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv13 2/3] IB/core: added support to use rdma cgroup
 controller
Date: Mon, 9 Jan 2017 08:00:11 -0500
Message-ID: <20170109130011.GC10904@mtj.duckdns.org>
References: <1480705637-2986-1-git-send-email-pandit.parav@gmail.com>
 <1480705637-2986-3-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1480705637-2986-3-git-send-email-pandit.parav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, hch@lst.de, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com, corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 02, 2016 at 07:07:16PM +0000, Parav Pandit wrote:
> Added support APIs for IB core to register/unregister every IB/RDMA
> device with rdma cgroup for tracking rdma resources.
> IB core registers with rdma cgroup controller.
> Added support APIs for uverbs layer to make use of rdma controller.
> Added uverbs layer to perform resource charge/uncharge functionality.
> Added support during query_device uverb operation to ensure it
> returns resource limits by honoring rdma cgroup configured limits.
> 
> Signed-off-by: Parav Pandit <pandit.parav@gmail.com>

Looks good but the patch causes a number of conflicts.  Can you please
refresh on top of the latest rdma tree?  I can create a branch which
pulls in rdma and cgroup trees.

Thanks.

-- 
tejun
