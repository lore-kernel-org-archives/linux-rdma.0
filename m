From: David Miller <davem@davemloft.net>
Subject: Re: [RFC PATCH linux-next] rds: rds_info_from_znotifier() can be
 static
Date: Thu, 08 Mar 2018 21:54:15 -0500 (EST)
Message-ID: <20180308.215415.619421604203164749.davem@davemloft.net>
References: <201803081946.adQaZcK5%fengguang.wu@intel.com>
        <20180308113729.GA89557@cairo>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180308113729.GA89557@cairo>
Sender: linux-kernel-owner@vger.kernel.org
To: fengguang.wu@intel.com
Cc: sowmini.varadhan@oracle.com, kbuild-all@01.org, santosh.shilimkar@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: kbuild test robot <fengguang.wu@intel.com>
Date: Thu, 8 Mar 2018 19:37:30 +0800

> Fixes: 9426bbc6de99 ("rds: use list structure to track information for zerocopy completion notification")
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>

Applied.
