From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: mlx4: kernel 3.4-rc1 breaks libumad
Date: Mon, 2 Apr 2012 16:02:17 +0300
Message-ID: <4F79A359.2020204@mellanox.com>
References: <4F795880.4070306@acm.org> <4F798069.4030305@mellanox.com> <4F798A9B.7060805@acm.org> <4F798B9A.6090309@mellanox.com> <4F799222.3050306@acm.org> <4F79A0C5.2030805@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F79A0C5.2030805-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/2/2012 3:51 PM, Or Gerlitz wrote:
> can you add these prints and send me the output after attempting to 
> cat the rate file?

okay, on a system which has IB on port 1 and Ethernet on port 2, using 
this patch
I get these prints:
> ib_link_query_port active_speed 4
> rate_show ret 0 for ib_query_port dev mlx4_0 port 1 link 1
> eth_link_query_port active_speed 4
> rate_show ret 0 for ib_query_port dev mlx4_0 port 2 link 2

but if forcing port 2 link layer to be IB as well, which means we will 
land in ib_link_query_port for an Ethernet port, I get the below

> echo ib >  /sys/bus/pci/devices/0000:07:00.0/mlx4_port2
> ib_link_query_port active_speed 4
> rate_show ret 0 for ib_query_port dev mlx4_0 port 1 link 1
> ib_link_query_port active_speed 7
> rate_show ret 0 for ib_query_port dev mlx4_0 port 2 link 1

So when doing the MAD_IFC port info query command on Ethernet port, the 
firmware returns the
value of seven which isn't among the IB speeds and we are remained with 
rate=-1 in rate_show
of drivers/infiniband/core/sysfs.c

It should be pretty simple to come with patch to that situation, but I 
want to better understand
what happens on your system, waiting for the output...

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
