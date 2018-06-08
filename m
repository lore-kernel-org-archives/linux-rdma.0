From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] IB/mlx5: Fix memory leak in mlx5_ib_create_flow
Date: Fri, 8 Jun 2018 18:11:49 -0500
Message-ID: <809fbf8a-e37d-2e92-cecb-37653e38290c@embeddedor.com>
References: <20180607191915.GA9092@embeddedor.com>
 <20180608230835.GA24392@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180608230835.GA24392@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Raed Salem <raeds@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


>>   
>>   	mutex_lock(&dev->flow_db->lock);
>>   
>> @@ -3640,6 +3646,9 @@ static struct ib_flow *mlx5_ib_create_flow(struct ib_qp *qp,
>>   	kfree(ucmd);
>>   	kfree(handler);
>>   	return ERR_PTR(err);
>> +free_ucmd:
>> +	kfree(ucmd);
>> +	return ERR_PTR(err);
>>   }
> 
> This hunk is a bit wonky, can we do this instead? handle never needs
> to be freed.
> 
> destroy_ft:
> 	put_flow_table(dev, ft_prio, false);
> 	if (ft_prio_tx)
> 		put_flow_table(dev, ft_prio_tx, false);
> unlock:
> 	mutex_unlock(&dev->flow_db->lock);
> 	kfree(dst);
> free_ucmd:
> 	kfree(ucmd);
> 	return ERR_PTR(err);
> }
> 
> 

Sure thing. I'll send v2 shortly.

Thanks for the feedback.
--
Gustavo
