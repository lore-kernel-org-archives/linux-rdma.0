From: "Gustavo A. R. Silva" <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
Subject: Re: [PATCH] net/mlx5e/core/en_fs: fix pointer dereference after
 free in mlx5e_execute_l2_action
Date: Sun, 05 Nov 2017 18:45:46 -0600
Message-ID: <20171105184546.Horde.a-gZvkBaubvOCMMOf0npg62@gator4166.hostgator.com>
References: <20171105035453.GA10908@embeddedor.com>
 <CALzJLG-YW_5AH__q2XHgaQM=xeLy+31LSeQdPAs7RhS=rLpJPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALzJLG-YW_5AH__q2XHgaQM=xeLy+31LSeQdPAs7RhS=rLpJPw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Linux Netdev List <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jes Sorensen <jsorensen-b10kYP2dOMg@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Saeed,

Quoting Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>:

> On Sat, Nov 4, 2017 at 8:54 PM, Gustavo A. R. Silva
> <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org> wrote:
>> hn is being kfree'd in mlx5e_del_l2_from_hash and then dereferenced
>> by accessing hn->ai.addr
>>
>> Fix this by copying the MAC address into a local variable for its safe use
>> in all possible execution paths within function mlx5e_execute_l2_action.
>>
>> Addresses-Coverity-ID: 1417789
>> Fixes: eeb66cdb6826 ("net/mlx5: Separate between E-Switch and MPFS")
>> Signed-off-by: Gustavo A. R. Silva <garsilva-L1vi/lXTdts+Va1GwOuvDg@public.gmane.org>
>
> Acked-by: Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Looks good.
> Thank you Gustavo.
>

Glad to help.

Thanks
--
Gustavo A. R. Silva





--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
