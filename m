From: "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH 1/2] net: rds: drop VLA in rds_for_each_conn_info()
Date: Mon, 12 Mar 2018 00:06:01 -0700
Message-ID: <9f197147-c050-dd70-23ea-ec880d205201@oracle.com>
References: <1520802470-17374-1-git-send-email-s.mesoraca16@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520802470-17374-1-git-send-email-s.mesoraca16@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>, linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Kees Cook <keescook@chromium.org>
List-Id: linux-rdma@vger.kernel.org

On 3/11/18 2:07 PM, Salvatore Mesoraca wrote:
> Avoid VLA[1] by using an already allocated buffer passed
> by the caller.
> 
> [1] https://lkml.org/lkml/2018/3/7/621
> 
> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
> ---
Thanks for both VLA fixes Salvatore.

FWIW, Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
