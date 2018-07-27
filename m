From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] net/rds/Kconfig: Correct the RDS depends
Date: Fri, 27 Jul 2018 13:19:23 -0700 (PDT)
Message-ID: <20180727.131923.1126798474002765240.davem@davemloft.net>
References: <20180727131849.18488-1-anders.roxell@linaro.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180727131849.18488-1-anders.roxell@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: anders.roxell@linaro.org
Cc: santosh.shilimkar@oracle.com, eric.dumazet@gmail.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>
Date: Fri, 27 Jul 2018 15:18:49 +0200

> Remove prefix 'CONFIG_' from CONFIG_IPV6
> 
> Fixes: ba7d7e2677c0 ("net/rds/Kconfig: RDS should depend on IPV6")
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>

Oops, applied :)
