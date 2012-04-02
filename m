From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: mlx4: kernel 3.4-rc1 breaks libumad
Date: Mon, 2 Apr 2012 13:33:13 +0300
Message-ID: <4F798069.4030305@mellanox.com>
References: <4F795880.4070306@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F795880.4070306-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/2/2012 10:42 AM, Bart Van Assche wrote:
> # uname -r
> 3.4.0-rc1
> # ls /sys/class/infiniband/mlx4_0/ports/1/rate
> /sys/class/infiniband/mlx4_0/ports/1/rate
> # cat /sys/class/infiniband/mlx4_0/ports/1/rate
> cat: /sys/class/infiniband/mlx4_0/ports/1/rate: Invalid argument
>

seems that this happens when the link layer is "wrong" e.g does 
/sys/class/infiniband/mlx4_0/ports/1/link_layer shows the actual link 
which is your hca port 1 is connected through? looking on this.

Or.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
