From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] net/rds/Kconfig: Correct the RDS depends
Date: Fri, 27 Jul 2018 08:03:42 -0700
Message-ID: <3872d906-99fe-b310-7d5e-ff0ef31de1e2@gmail.com>
References: <20180727131849.18488-1-anders.roxell@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180727131849.18488-1-anders.roxell@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Anders Roxell <anders.roxell@linaro.org>, santosh.shilimkar@oracle.com, davem@davemloft.net, eric.dumazet@gmail.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 07/27/2018 06:18 AM, Anders Roxell wrote:
> Remove prefix 'CONFIG_' from CONFIG_IPV6
> 
> Fixes: ba7d7e2677c0 ("net/rds/Kconfig: RDS should depend on IPV6")
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> ---

SGTM, thanks !

Reviewed-by: Eric Dumazet <edumazet@google.com>
