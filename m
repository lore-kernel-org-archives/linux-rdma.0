From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv1 3/6] rdmacg: implements rdma cgroup
Date: Thu, 7 Jan 2016 15:28:18 -0500
Message-ID: <20160107202818.GF1898@mtj.duckdns.org>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
 <1452020286-9508-4-git-send-email-pandit.parav@gmail.com>
 <20160105220128.GJ5995@mtj.duckdns.org>
 <CAG53R5UjsDa+JK_afrQ5pMpiDPrc+a+yCOOH3X105pTmU_a53A@mail.gmail.com>
 <20160107152936.GE29797@mtj.duckdns.org>
 <CAG53R5Vg9jULp9EU23yd+iUqMDyTMNmUycD8ygX_j98O=JUDmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG53R5Vg9jULp9EU23yd+iUqMDyTMNmUycD8ygX_j98O=JUDmA@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hello, Parav.

On Fri, Jan 08, 2016 at 01:55:09AM +0530, Parav Pandit wrote:
...
> Above functionality is achieved, by maintaining the map this tgid and
> associated original cgroup at try_charge(), uncharge() time.

Hmmm, what happens after the following?

1. A process allocates some rdma resources and get registered on the
   hash table.

2. The process gets migrated to a different cgroup.

3. The process allocates more rdma resources.

Which cgroup would the resources from #3 be attributed to?

> In alternate method,
> Its simple to store the pointer of rdma_cgroup structure in the IB
> resource structure and hold on reference count to rdma_cgroup.
> so that when its freed, uncharge_resource can accept rdma_cgroup
> structure pointer.

That'd be a lot more in line with how other controllers behave.

Thanks.

-- 
tejun
