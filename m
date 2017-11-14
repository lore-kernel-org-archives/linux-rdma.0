From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 1/5] verbs: Introduce thread domain and its
 related verbs
Date: Tue, 14 Nov 2017 10:26:16 +0200
Message-ID: <3719edfc-282a-db5b-2474-3cf1355fb301@dev.mellanox.co.il>
References: <1510522903-6838-1-git-send-email-yishaih@mellanox.com>
 <1510522903-6838-2-git-send-email-yishaih@mellanox.com>
 <20171113195822.GD22610@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171113195822.GD22610-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/13/2017 9:58 PM, Jason Gunthorpe wrote:
> On Sun, Nov 12, 2017 at 11:41:39PM +0200, Yishai Hadas wrote:
> 
>> +struct ibv_td {
>> +	struct ibv_context     *context;
>> +};
> 
> As much as possible, I would like to see any new objects be 'opaque'
> to the application, so this should just be
> 
> struct ibv_td;
> 
> And ibv_td should be defined in driver.h or something
> 
> This avoids leaking internal details and means we don't have to commit
> to an ABI for the insides of these structs.
> 

ibv_td should expose in verbs.h the 'context' as the inline function 
ibv_alloc_td() needs it to get the verbs_context and call the driver 
function if was set. Further extensions if will come should be 'opaque' 
as you pointed.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
