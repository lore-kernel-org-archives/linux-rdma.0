From: Edward Cree <ecree@solarflare.com>
Subject: Re: [PATCH] rds: ib: force endiannes annotation
Date: Mon, 29 Apr 2019 12:00:06 +0100
Message-ID: <20443fd3-bd1e-9472-8ca3-e3014e59f249@solarflare.com>
References: <1556518178-13786-1-git-send-email-hofrat@osadl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1556518178-13786-1-git-send-email-hofrat@osadl.org>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Mc Guire <hofrat@osadl.org>, Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 29/04/2019 07:09, Nicholas Mc Guire wrote:
> diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
> index 7055985..a070a2d 100644
> --- a/net/rds/ib_recv.c
> +++ b/net/rds/ib_recv.c
> @@ -824,7 +824,7 @@ static void rds_ib_cong_recv(struct rds_connection *conn,
>  	}
>  
>  	/* the congestion map is in little endian order */
> -	uncongested = le64_to_cpu(uncongested);
> +	uncongested = le64_to_cpu((__force __le64)uncongested);
>  
>  	rds_cong_map_updated(map, uncongested);
>  }
Again, a __force cast doesn't seem necessary here.  It looks like the
 code is just using the wrong types; if all of src, dst and uncongested
 were __le64 instead of uint64_t, and the last two lines replaced with
 rds_cong_map_updated(map, le64_to_cpu(uncongested)); then the semantics
 would be kept with neither sparse errors nor __force.

__force is almost never necessary and mostly just masks other bugs or
 endianness confusion in the surrounding code.  Instead of adding a
 __force, either fix the code to be sparse-clean or leave the sparse
 warning in place so that future developers know there's something not
 right.

-Ed
