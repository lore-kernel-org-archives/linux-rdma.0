From: Tariq Toukan <tariqt@mellanox.com>
Subject: Re: ethernet: mlx4: Delete an error message for a failed memory
 allocation in five functions
Date: Thu, 4 Jan 2018 11:24:56 +0200
Message-ID: <d9e4b1e7-04dd-106f-61f4-23fb1d9b88a6@mellanox.com>
References: <30191db0-4d99-0349-b66a-c7354ef90d50@users.sourceforge.net>
 <0fea8f2f-f8fc-ce2e-3d33-44227de3637a@mellanox.com>
 <alpine.DEB.2.20.1801030904290.5305@hadrien>
 <adfc3229-d3f9-afb9-00e6-9f765af0cbe8@mellanox.com>
 <d693dbdb-f3a2-5194-07e9-7c56e9ccbb2b@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d693dbdb-f3a2-5194-07e9-7c56e9ccbb2b@users.sourceforge.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, Tariq Toukan <tariqt@mellanox.com>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 03/01/2018 4:22 PM, SF Markus Elfring wrote:
>> I don't really accept this claim...
>> Short informative strings worth the tiny space they consume.
> 
> There can be different opinions for their usefulness.
> 
> 
>> In addition, some out-of-memory errors are recoverable, even though their backtrace is also printed.
> 
> How do you think about to suppress the backtrace generation for them?
> 
> 
OK, makes sense.

>> For example, in function mlx4_en_create_cq (appears in patch) we have a first allocation attempt (kzalloc_node)
> 
> Would it be helpful to pass the option “__GFP_NOWARN” there?
> 
> 

I'll prepare a patch to use it.
Will ack this patch for now.

>> and a fallback (kzalloc). I'd prefer to state a clear error message only when both have failed,
>> because otherwise the user might be confused whether the backtrace should indicate a malfunctioning interface, or not.
> 
> Can the distinction become easier by any other means?
> 
> Regards,
> Markus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
