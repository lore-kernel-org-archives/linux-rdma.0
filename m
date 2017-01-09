From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv13 0/3] rdmacg: IB/core: rdma controller support
Date: Mon, 9 Jan 2017 08:02:21 -0500
Message-ID: <20170109130221.GD10904@mtj.duckdns.org>
References: <1480705637-2986-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1480705637-2986-1-git-send-email-pandit.parav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, hch@lst.de, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com, corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 02, 2016 at 07:07:14PM +0000, Parav Pandit wrote:
> Patch is generated and tested against below Doug's linux-rdma
> git tree.
> URL: git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
> Branch: master
> 
> Patchset is also compiled and tested against below Tejun's cgroup tree
> using cgroup v2 mode.
> URL: git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
> Branch: master

Except for the minor nits, all look good to me.  Can you please
refresh on top of cgroup/for-4.11 and the rdma devel branch?  Please
note that cgroup/for-4.11 moved the cgroup source files under
kernel/cgroup/.

Thanks!

-- 
tejun
