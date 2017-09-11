From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx4: Add inline-receive support
Date: Mon, 11 Sep 2017 19:09:27 +0300
Message-ID: <5c3ce114-af4b-16c4-af7e-17305faaff0f@dev.mellanox.co.il>
References: <1505036749-12297-1-git-send-email-yishaih@mellanox.com>
 <20170911160508.GA32117@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170911160508.GA32117-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/11/2017 7:05 PM, Jason Gunthorpe wrote:
> On Sun, Sep 10, 2017 at 12:45:49PM +0300, Yishai Hadas wrote:
>
>> diff --git a/providers/mlx4/libmlx4.map b/providers/mlx4/libmlx4.map
>> index 0e53f83..6de4348 100644
>> +++ b/providers/mlx4/libmlx4.map
>> @@ -3,5 +3,7 @@
>>  MLX4_1.0 {
>>  	global:
>>  		mlx4dv_init_obj;
>> +		mlx4dv_query_device;
>> +		mlx4dv_create_qp;
>
> NAK please read Documentation/versioning.md and do this properly.
>

RDMA core V15 first introduced the MLX4_1.0 and its initial 
mlx4dv_init_obj API, as those APIs go to this version it should be fine.

What is wrong here ?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
