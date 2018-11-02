From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next v1 4/4] rdma: Document IB device renaming
 option
Date: Fri, 2 Nov 2018 10:47:16 -0600
Message-ID: <bb0836d9-6ebb-3383-3d61-8347d0d72561@gmail.com>
References: <20181031071758.6178-1-leon@kernel.org>
 <20181031071758.6178-5-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181031071758.6178-5-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org

On 10/31/18 1:17 AM, Leon Romanovsky wrote:
> diff --git a/man/man8/rdma-dev.8 b/man/man8/rdma-dev.8
> index 461681b6..b2f9964a 100644
> --- a/man/man8/rdma-dev.8
> +++ b/man/man8/rdma-dev.8
> @@ -22,6 +22,12 @@ rdmak-dev \- RDMA device configuration
>  .B rdma dev show
>  .RI "[ " DEV " ]"
>  
> +.ti -8
> +.B rdma dev set
> +.RI "[ " DEV " ]"
> +.BR name
> +.BR NEWNAME
> +
>  .ti -8
>  .B rdma dev help
>  
> @@ -33,6 +39,8 @@ rdmak-dev \- RDMA device configuration
>  - specifies the RDMA device to show.
>  If this argument is omitted all devices are listed.
>  
> +.SS rdma dev set - rename rdma device
> +

'nroff -u0 -Tlp -man man/man8/rdma-dev.8' shows that you lost the
spacing between that line and the Examples line.

   rdma dev set - rename rdma device
EXAMPLES
       rdma dev
           Shows the state of all RDMA devices on the system.

...


>  .SH "EXAMPLES"
>  .PP
>  rdma dev
> @@ -45,6 +53,11 @@ rdma dev show mlx5_3
>  Shows the state of specified RDMA device.
>  .RE
>  .PP
> +rdma dev set mlx5_3 name rdma_0
> +.RS 4
> +Renames the mlx5_3 device to be named rdma_0.

That does not read well. I suggest dropping the 'be named' to make it
"Renames the mlx5_3 device to rdma_0."

> +.RE
> +.PP
>  
>  .SH SEE ALSO
>  .BR rdma (8),
> 
