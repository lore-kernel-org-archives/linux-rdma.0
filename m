From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] net/mlx4_core: print firmware version during driver
 loading
Date: Fri, 14 Sep 2018 14:09:06 -0700 (PDT)
Message-ID: <20180914.140906.724918309737328254.davem@davemloft.net>
References: <20180914002514.27571-1-qing.huang@oracle.com>
        <20180914044314.GC5257@mtr-leonro.mtl.com>
        <c580ad9d-b63d-743b-2278-1c4cf3553186@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c580ad9d-b63d-743b-2278-1c4cf3553186@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: qing.huang@oracle.com
Cc: leon@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, tariqt@mellanox.com
List-Id: linux-rdma@vger.kernel.org

From: Qing Huang <qing.huang@oracle.com>
Date: Fri, 14 Sep 2018 10:15:48 -0700

> IMHO, this information is very useful and only takes up very little
> log file space. :-)

If it's critical then the log is the wrong place for it as the log
is lossy.

The proper place to obtain this information is via the fw_version
field of the ethtool_drvinfo struct.  This can be obtained at any time
and is reliable.  And if it isn't reliable or correct, we must fix
that.
