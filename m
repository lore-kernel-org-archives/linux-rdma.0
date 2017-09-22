From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH v2] IB/mlx5: fix debugfs cleanup
Date: Fri, 22 Sep 2017 13:18:00 -0400
Message-ID: <1506100680.5172.7.camel@redhat.com>
References: <1505734128-21708-1-git-send-email-sudip.mukherjee@codethink.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1505734128-21708-1-git-send-email-sudip.mukherjee@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-09-18 at 12:28 +0100, Sudip Mukherjee wrote:
> From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> 
> If delay_drop_debugfs_init() fails in any of the operations to create
> debugfs, it is calling delay_drop_debugfs_cleanup() as part of its
> cleanup. But delay_drop_debugfs_cleanup() checks for 'dbg' and since
> we have not yet pointed 'dbg' to the debugfs we need to cleanup, the
> cleanup fails and we are left with stray debugfs elements and also a
> memory leak.
> 
> Fixes: 4a5fd5d2965c ("IB/mlx5: Add necessary delay drop assignment")
> Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>

Thanks, applied to rc.

-- 
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
