From: santosh.shilimkar@oracle.com
Subject: Re: [PATCH] linux-next: DOC: RDS: Fix a typo in rds.txt
Date: Wed, 12 Jun 2019 09:27:56 -0700
Message-ID: <b3fae27d-633d-e164-9f59-44eabf74ed7e@oracle.com>
References: <20190612122934.3515-1-standby24x7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190612122934.3515-1-standby24x7@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 6/12/19 5:29 AM, Masanari Iida wrote:
> This patch fixes a spelling typo in rds.txt
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>   Documentation/networking/rds.txt | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/networking/rds.txt b/Documentation/networking/rds.txt
> index 0235ae69af2a..f2a0147c933d 100644
> --- a/Documentation/networking/rds.txt
> +++ b/Documentation/networking/rds.txt
> @@ -389,7 +389,7 @@ Multipath RDS (mprds)
>     a common (to all paths) part, and a per-path struct rds_conn_path. All
>     I/O workqs and reconnect threads are driven from the rds_conn_path.
>     Transports such as TCP that are multipath capable may then set up a
> -  TPC socket per rds_conn_path, and this is managed by the transport via
> +  TCP socket per rds_conn_path, and this is managed by the transport via
>     the transport privatee cp_transport_data pointer.
>   
>     Transports announce themselves as multipath capable by setting the
> 
Thanks !!

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
