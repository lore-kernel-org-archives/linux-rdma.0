From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: mlx4: kernel 3.4-rc1 breaks libumad
Date: Mon, 02 Apr 2012 11:16:43 +0000
Message-ID: <4F798A9B.7060805@acm.org>
References: <4F795880.4070306@acm.org> <4F798069.4030305@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F798069.4030305-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 04/02/12 10:33, Or Gerlitz wrote:

> On 4/2/2012 10:42 AM, Bart Van Assche wrote:
>> # uname -r
>> 3.4.0-rc1
>> # ls /sys/class/infiniband/mlx4_0/ports/1/rate
>> /sys/class/infiniband/mlx4_0/ports/1/rate
>> # cat /sys/class/infiniband/mlx4_0/ports/1/rate
>> cat: /sys/class/infiniband/mlx4_0/ports/1/rate: Invalid argument
> 
> seems that this happens when the link layer is "wrong" e.g does
> /sys/class/infiniband/mlx4_0/ports/1/link_layer shows the actual link
> which is your hca port 1 is connected through? looking on this.


As far as I can see the link layer value is fine:
$ cat /sys/class/infiniband/mlx4_0/ports/1/link_layer
InfiniBand
$ cat /sys/class/infiniband/mlx4_0/ports/2/link_layer
InfiniBand

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
