From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: mlx4: kernel 3.4-rc1 breaks libumad
Date: Mon, 02 Apr 2012 13:35:32 +0000
Message-ID: <4F79AB24.2090200@acm.org>
References: <4F795880.4070306@acm.org> <4F798069.4030305@mellanox.com> <4F798A9B.7060805@acm.org> <4F798B9A.6090309@mellanox.com> <4F799222.3050306@acm.org> <4F79A0C5.2030805@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F79A0C5.2030805-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 04/02/12 12:51, Or Gerlitz wrote:

> On 4/2/2012 2:48 PM, Bart Van Assche wrote:
>> The two ports are connected back-to-back to another mlx4 HCA. I
>> noticed this behavior change since opensm stopped working after
>> rebooting into 3.4-rc1.
> 
> can you add these prints and send me the output after attempting to cat
> the rate file?


Some additional info:
- This issue only occurs if the back-to-back connected system is down,
  not if it is running.
- The output I get with the other system down is:

# cat /sys/class/infiniband/mlx4_0/ports/1/link_layer
InfiniBand
# dmesg -c >/dev/null
# cat /sys/class/infiniband/mlx4_0/ports/1/rate
cat: /sys/class/infiniband/mlx4_0/ports/1/rate: Invalid argument
# dmesg -c
ib_link_query_port active_speed 7
rate_show ret 0 for ib_query_port dev mlx4_0 port 1 link 1

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
