From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/1] mlx4_en: remove unnecessary returned value
Date: Mon, 24 Jul 2017 16:30:09 -0700 (PDT)
Message-ID: <20170724.163009.752949426037587241.davem@davemloft.net>
References: <1500865373-32411-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1500865373-32411-1-git-send-email-yanjun.zhu@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: yanjun.zhu@oracle.com
Cc: tariqt@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, yuval.shaia@oracle.com, leon@kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>
Date: Sun, 23 Jul 2017 23:02:53 -0400

> The function mlx4_en_arm_cq always returns zero. So change the
> return type of the function mlx4_en_arm_cq to void.
> 
> CC: Joe Jin <joe.jin@oracle.com>
> CC: Junxiao Bi <junxiao.bi@oracle.com>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>

Applied to net-next, thanks.
