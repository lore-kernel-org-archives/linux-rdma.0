From: Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH net-next 4/4] mlx4: sizeof style usage
Date: Sun, 20 Aug 2017 13:27:14 +0300
Message-ID: <d38cac6d-77a7-e411-73b0-78adad9cbd5f@mellanox.com>
References: <20170815172919.26153-1-sthemmin@microsoft.com>
 <20170815172919.26153-5-sthemmin@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20170815172919.26153-5-sthemmin@microsoft.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>, mlindner@marvell.com, mst@redhat.com, jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, virtualization@lists.linux-foundation.org, Stephen Hemminger <sthemmin@microsoft.com>
List-Id: linux-rdma@vger.kernel.org

Thanks Stephen.
Sorry for the late reply, I was on vacation.
I know this is already accepted, but still I have one comment.

On 15/08/2017 8:29 PM, Stephen Hemminger wrote:
> The kernel coding style is to treat sizeof as a function
> (ie. with parenthesis) not as an operator.
> 
> Also use kcalloc and kmalloc_array
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
> @@ -726,7 +726,7 @@ static int mlx4_eq_int(struct mlx4_dev *dev, struct mlx4_eq *eq)
>   			}
>   			memcpy(&priv->mfunc.master.comm_arm_bit_vector,
>   			       eqe->event.comm_channel_arm.bit_vec,
> -			       sizeof eqe->event.comm_channel_arm.bit_vec);
> +			       sizeof(eqe)->event.comm_channel_arm.bit_vec);

I think the brackets here are misplaced.
Shouldn't they be as follows?

sizeof(eqe->event.comm_channel_arm.bit_vec));

>   			queue_work(priv->mfunc.master.comm_wq,
>   				   &priv->mfunc.master.comm_work);
>   			break;

Thanks,
Tariq
