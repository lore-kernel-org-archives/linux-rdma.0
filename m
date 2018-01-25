From: "jianchao.wang" <jianchao.w.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] net/mlx4_en: ensure rx_desc updating reaches HW before
 prod db updating
Date: Thu, 25 Jan 2018 11:27:17 +0800
Message-ID: <532b4d71-e2eb-35f3-894e-1c3288e7bc3f@oracle.com>
References: <1515728542-3060-1-git-send-email-jianchao.w.wang@oracle.com>
 <20180112163247.GB15974@ziepe.ca> <1515775567.131759.42.camel@gmail.com>
 <a40e44f4-106b-1075-8f92-f7741508372c@oracle.com>
 <af562737-4a3e-0429-1fd6-fc25c3e3f867@mellanox.com>
 <fea0aa1c-b68e-9485-3826-2dfad7824911@oracle.com>
 <53b1ac4d-a294-eb98-149e-65d7954243da@oracle.com>
 <1516376999.3606.39.camel@gmail.com>
 <dfc02a48-7d2a-56da-dc4e-d90a9fcc559c@mellanox.com>
 <339a7156-9ef1-1f3c-30b8-3cc3558d124e@mellanox.com>
 <c8b0955b-a3fc-afe2-2c67-e655ca2ee6f6@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c8b0955b-a3fc-afe2-2c67-e655ca2ee6f6-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tariq Toukan <tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Tariq

On 01/22/2018 10:12 AM, jianchao.wang wrote:
>>> On 19/01/2018 5:49 PM, Eric Dumazet wrote:
>>>> On Fri, 2018-01-19 at 23:16 +0800, jianchao.wang wrote:
>>>>> Hi Tariq
>>>>>
>>>>> Very sad that the crash was reproduced again after applied the patch.
>> Memory barriers vary for different Archs, can you please share more details regarding arch and repro steps?

> The hardware is HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 12/27/2015
> The xen is installed. The crash occurred in DOM0.
> Regarding to the repro steps, it is a customer's test which does heavy disk I/O over NFS storage without any guest.
> 

What is the finial suggestion on this ?
If use wmb there, is the performance pulled down ?

Thanks in advance
Jianchao
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
