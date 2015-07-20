From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] mlx5: Fix missing device local_dma_lkey
Date: Mon, 20 Jul 2015 20:09:57 +0300
Message-ID: <55AD2B65.4090006@mellanox.com>
References: <1437411276-22731-1-git-send-email-sagig@mellanox.com>
 <3095C235-676F-4A99-A27C-F2F332D9921F@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3095C235-676F-4A99-A27C-F2F332D9921F-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/20/2015 8:08 PM, Chuck Lever wrote:
>
> On Jul 20, 2015, at 12:54 PM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrot=
e:
>
>> The mlx5 driver exposes device capability IB_DEVICE_LOCAL_DMA_LKEY
>> but does not set the the device local_dma_lkey. This breaks
>> rpcrdma drivers.
>>
>> Query and set this lkey when creating the device resources.
>
> Wow. This suggests no-one has been testing NFS/RDMA with mlx5? I
> know I=92m not (yet). Anyway, this makes sense.

That's what I was wandering about.

I just turned it on and it blew up... gracefully though :)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
