From: "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH V2] rds: ib: force endiannes annotation
Date: Mon, 29 Apr 2019 21:25:15 -0700
Message-ID: <5ba055e9-5221-bff2-fdd2-d4b837c95ce1@oracle.com>
References: <1556593977-15828-1-git-send-email-hofrat@osadl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1556593977-15828-1-git-send-email-hofrat@osadl.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Mc Guire <hofrat@osadl.org>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 4/29/19 8:12 PM, Nicholas Mc Guire wrote:
> While the endiannes is being handled correctly as indicated by the comment
> above the offending line - sparse was unhappy with the missing annotation
> as be64_to_cpu() expects a __be64 argument. To mitigate this annotation
> all involved variables are changed to a consistent __le64 and the
>   conversion to uint64_t delayed to the call to rds_cong_map_updated().
> 
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> ---
> 
> Problem located by an experimental coccinelle script to locate
> patters that make sparse unhappy (false positives):
> net/rds/ib_recv.c:827:23: warning: cast to restricted __le64
> 
> V2: Edward Cree <ecree@solarflare.com> rejected the need for using __force
>      here - instead solve the sparse issue by updating all of the involved
>      variables - which results in an identical binary as well without using
>      the __force "solution" to the sparse warning. Thanks !
> 
> Patch was compile-tested with: x86_64_defconfig + INFINIBAND=m, RDS_RDMA=m
> 
> Patch was verified not to change the binary by diffing the
> generated object code before and after applying the patch.
> 
Thanks. I was worried about this macro magic o.w

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
