From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH 07/22] IB/iwcm: Remove deprecated create_singlethread_workqueue
Date: Tue, 16 Aug 2016 13:20:26 -0500
Message-ID: <042301d1f7ea$dc7c32f0$957498d0$@opengridcomputing.com>
References: <cover.1471283717.git.bhaktipriya96@gmail.com> <7ff721d47b418328d541d6a9b9c7c776bad8ab7e.1471283717.git.bhaktipriya96@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7ff721d47b418328d541d6a9b9c7c776bad8ab7e.1471283717.git.bhaktipriya96@gmail.com>
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
To: 'Bhaktipriya Shridhar' <bhaktipriya96@gmail.com>, 'Yishai Hadas' <yishaih@mellanox.com>, 'Doug Ledford' <dledford@redhat.com>, 'Sean Hefty' <sean.hefty@intel.com>, 'Hal Rosenstock' <hal.rosenstock@gmail.com>, 'Jason Gunthorpe' <jgunthorpe@obsidianresearch.com>, 'Leon Romanovsky' <leonro@mellanox.com>, 'Chuck Lever' <chuck.lever@oracle.com>, 'Mark Bloch' <markb@mellanox.com>, 'Hans Westgaard Ry' <hans.westgaard.ry@oracle.com>, 'Christoph Lameter' <cl@linux.com>, 'Erez Shitrit' <erezsh@mellanox.com>, 'Haggai Eran' <haggaie@mellanox.com>, 'Florian Westphal' <fw@strlen.de>, 'Guy Shapiro' <guysh@mellanox.com>, 'Eli Cohen' <eli@mellanox.com>, 'Or Gerlitz' <ogerlitz@mellanox.com>, 'Faisal Latif' <faisal.latif@intel.com>, 'Matan Barak' <matanb@mellanox.com>, 'Chien Tin Tung' <chien.tin.tung@intel.com>, 'Mustafa Ismail' <mustafa.is>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 'Tejun Heo' <tj@kernel.org>
List-Id: linux-rdma@vger.kernel.org

> alloc_ordered_workqueue() with WQ_MEM_RECLAIM set, replaces
> deprecated create_singlethread_workqueue(). This is the identity
> conversion.
> 
> The workqueue "iwcm_wq" queues work item &work(maps to cm_work_handler).
> It has been identity converted.
> 
> WQ_MEM_RECLAIM has been set to ensure forward progress under
> memory pressure.
> 
> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>

Looks fine.

Reviewed-by: Steve Wise <swise@opengridcomputing.com>
