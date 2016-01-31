From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv5 0/3] rdmacg: IB/core: rdma controller support
Date: Sun, 31 Jan 2016 04:46:05 -0500
Message-ID: <20160131094605.GR32380@htj.duckdns.org>
References: <1454214912-10965-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1454214912-10965-1-git-send-email-pandit.parav@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com, corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 31, 2016 at 10:05:09AM +0530, Parav Pandit wrote:
> Changes from v4:
>  * Fixed compilation errors for lockdep_assert_held reported by kbuild
>    test robot
>  * Fixed compilation warning reported by coccinelle for extra semicolon.
>  * Fixed compilation error for inclusion of linux/parser.h which cannot 
>    be included in any header file, as that triggers multiple inclusion
>    error. Instead parser.h is included in C files which intent to use it.
>  * Removed unused header file inclusion in cgroup_rdma.c
> 
> Changes from v3:
>  * (To address comments from Tejun)
>    1. Renamed cg_resource to rdmacg_resource
>    2. Merged dealloc_cg_rpool and _dealloc_cg_rpool to single function
>    3. Renamed _find_cg_rpool to find_cg_rpool_locked()
>    5. Removed RDMACG_MAX_RESOURCE_INDEX limitation
>    6. Fixed few alignments.
>    7. Improved description for RDMA cgroup configuration menu
>    8. Renamed cg_list_lock to rpool_list_lock to reflect the lock
>       is for rpools.
>    9. Renamed _get_cg_rpool to find_cg_rpool.
>    10. Made creator as int variable, instead of atomic as its not 
>       required to be atomic.
>  * Fixed freeing right rpool during query_limit error path
>  * Added copywrite for cgroup.c
>  * Removed including parser.h from cgroup.c as its included by cgroup_rdma.h
>  * Reduced try_charge functions to single function and removed duplicate
>    comments.

Please don't send out patchsets in rapid succession while design
discussion is still in progress.  It's tiring for everyone involved.

Thanks.

-- 
tejun
