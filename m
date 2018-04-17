From: Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [PATCH 1/1] net/mlx4_core: avoid resetting HCA when accessing an
 offline device
Date: Tue, 17 Apr 2018 10:05:09 +0300
Message-ID: <ca105394-8168-6896-9c0b-b335de39154e@mellanox.com>
References: <1523840527-22746-1-git-send-email-yanjun.zhu@oracle.com>
 <20180416.125110.1875435797136179428.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180416.125110.1875435797136179428.davem@davemloft.net>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>, yanjun.zhu@oracle.com
Cc: tariqt@mellanox.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, haakon.bugge@oracle.com
List-Id: linux-rdma@vger.kernel.org



On 16/04/2018 7:51 PM, David Miller wrote:
> From: Zhu Yanjun <yanjun.zhu@oracle.com>
> Date: Sun, 15 Apr 2018 21:02:07 -0400
> 
>> While a faulty cable is used or HCA firmware error, HCA device will
>> be offline. When the driver is accessing this offline device, the
>> following call trace will pop out.
>   ...
>> In the above call trace, the function mlx4_cmd_poll calls the function
>> mlx4_cmd_post to access the HCA while HCA is offline. Then mlx4_cmd_post
>> returns an error -EIO. Per -EIO, the function mlx4_cmd_poll calls
>> mlx4_cmd_reset_flow to reset HCA. And the above call trace pops out.
>>
>> This is not reasonable. Since HCA device is offline when it is being
>> accessed, it should not be reset again.
>>
>> In this patch, since HCA is offline, the function mlx4_cmd_post returns
>> an error -EINVAL. Per -EINVAL, the function mlx4_cmd_poll directly returns
>> instead of resetting HCA.
>>
>> CC: Srinivas Eeda <srinivas.eeda@oracle.com>
>> CC: Junxiao Bi <junxiao.bi@oracle.com>
>> Suggested-by: Håkon Bugge <haakon.bugge@oracle.com>
>> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> 
> Tariq, I'm assuming you'll take this in and send it to me later.
> 
> Thanks.

Yes, I will review and send if all is OK.

Thanks,
Tariq

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
