From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv1 3/6] rdmacg: implements rdma cgroup
Date: Thu, 7 Jan 2016 10:29:36 -0500
Message-ID: <20160107152936.GE29797@mtj.duckdns.org>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
 <1452020286-9508-4-git-send-email-pandit.parav@gmail.com>
 <20160105220128.GJ5995@mtj.duckdns.org>
 <CAG53R5UjsDa+JK_afrQ5pMpiDPrc+a+yCOOH3X105pTmU_a53A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG53R5UjsDa+JK_afrQ5pMpiDPrc+a+yCOOH3X105pTmU_a53A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hello,

On Thu, Jan 07, 2016 at 05:03:07AM +0530, Parav Pandit wrote:
> Rdma resource can be allocated by parent process, used and freed by
> child process.
> Child process could belong to different rdma cgroup.
> Parent process might have been terminated after creation of rdma
> cgroup. (Followed by cgroup might have been deleted too).
> Its discussed in https://lkml.org/lkml/2015/11/2/307
> 
> In nutshell, there is process that clearly owns the rdma resource.
> So to keep the design simple, rdma resource is owned by the creator
> process and cgroup without modifying the task_struct.

So, a resource created by a task in a cgroup staying in the cgroup
when the task gets migrated is fine; however, a resource being
allocated in a previous cgroup of the task isn't fine.  Once
allocated, the resource themselves should be associated with the
cgroup so that they can be freed from the ones they're allocated from.

If I'm understanding it correctly, the code is bending basic rules
around how resource and task cgroup membership is tracked, you really
can't do that.

> > I'm pretty sure you can get away with an fixed length array of
> > counters.  Please keep it simple.  It's a simple hard limit enforcer.
> > There's no need to create a massive dynamic infrastrucure.
>
> Every resource pool for verbs resource is fixed length array. Length
> of the array is defined by the IB stack modules.
> This array is per cgroup, per device.
> Its per device, because we agreed that we want to address requirement
> of controlling/configuring them on per device basis.
> Devices appear and disappear. Therefore they are allocated dynamically.
> Otherwise this array could be static in cgroup structure.

Please see the previous response.

Thanks.

-- 
tejun
