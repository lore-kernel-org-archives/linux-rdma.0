From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: mlx4: kernel 3.4-rc1 breaks libumad
Date: Mon, 2 Apr 2012 14:20:58 +0300
Message-ID: <4F798B9A.6090309@mellanox.com>
References: <4F795880.4070306@acm.org> <4F798069.4030305@mellanox.com> <4F798A9B.7060805@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F798A9B.7060805-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/2/2012 2:16 PM, Bart Van Assche wrote:
> On 04/02/12 10:33, Or Gerlitz wrote:
>
>
> As far as I can see the link layer value is fine:
> $ cat /sys/class/infiniband/mlx4_0/ports/1/link_layer
> InfiniBand
> $ cat /sys/class/infiniband/mlx4_0/ports/2/link_layer
> InfiniBand
>

So the two ports are actually connected to IB switch? please send 
ibv_devinfo output (HCA, firmware, etc).

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
