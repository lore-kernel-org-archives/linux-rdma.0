From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: mlx5_core Issue
Date: Sat, 6 Feb 2016 17:36:13 +0200
Message-ID: <20160206153613.GB8584@leon.nu>
References: <CAHkw+Lc3h5-0Km6J5j7xOHa0d-5gx1RO_dBRXYLfgGoyKzHkoA@mail.gmail.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHkw+Lc3h5-0Km6J5j7xOHa0d-5gx1RO_dBRXYLfgGoyKzHkoA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marc Smith <marc.smith-FHhu8y7Kp0U@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 04, 2016 at 10:09:19AM -0500, Marc Smith wrote:
> Hi,

For any reasons, I found this email in SPAM folder.

> 
> I'm using Linux 4.1.11 and trying to get Mellanox 100 Gb adapters
> working. When loading 'mlx5_core' I get the following messages (no
> usable interfaces):
> 
> --snip--
> Jan 25 12:18:08 myhost kernel: [  209.537341] mlx5_core 0000:41:00.0:
> firmware version: 12.12.1100
> Jan 25 12:18:09 myhost kernel: [  210.104954] mlx5_core 0000:41:00.1:
> firmware version: 12.12.1100
> Jan 25 12:18:09 myhost kernel: [  210.679413] mlx5_ib: Mellanox
> Connect-IB Infiniband driver v2.2-1 (Feb 2014)
> Jan 25 12:18:09 myhost kernel: [  210.692783]
> 0000:41:00.0:mlx5_core_create_qp:202:(pid 769): current num of QPs 0x0
> Jan 25 12:18:09 myhost kernel: [  210.692788] command failed, status
> bad parameter(0x3), syndrome 0x48b5c0
> Jan 25 12:18:09 myhost kernel: [  210.692799] infiniband mlx5_0:
> Couldn't create ib_mad QP0
> Jan 25 12:18:09 myhost kernel: [  210.693374] infiniband mlx5_0:
> Couldn't open port 1
> Jan 25 12:18:09 myhost kernel: [  210.693381] infiniband mlx5_0:
> ib_register_mad_agent: Invalid port
> Jan 25 12:18:09 myhost kernel: [  210.693579] infiniband mlx5_0:
> ib_register_mad_agent: Invalid port
> Jan 25 12:18:09 myhost kernel: [  210.695172] infiniband mlx5_0:
> ib_register_mad_agent: Invalid port
> Jan 25 12:18:09 myhost kernel: [  210.696323]
> 0000:41:00.0:mlx5_core_create_qp:202:(pid 769): current num of QPs 0x0
> Jan 25 12:18:09 myhost kernel: [  210.696326] command failed, status
> bad resource(0x5), syndrome 0x15a3c9
> Jan 25 12:18:09 myhost kernel: [  210.697452] infiniband mlx5_0: Port
> 1 not found
> Jan 25 12:18:09 myhost kernel: [  210.697456] infiniband mlx5_0:
> Couldn't close port 1 for agents
> Jan 25 12:18:09 myhost kernel: [  210.697460] infiniband mlx5_0: Port
> 1 not found
> Jan 25 12:18:09 myhost kernel: [  210.697463] infiniband mlx5_0:
> Couldn't close port 1
> Jan 25 12:18:09 myhost kernel: [  210.710739]
> 0000:41:00.1:mlx5_core_create_qp:202:(pid 769): current num of QPs 0x0
> Jan 25 12:18:09 myhost kernel: [  210.710742] command failed, status
> bad parameter(0x3), syndrome 0x48b5c0
> Jan 25 12:18:09 myhost kernel: [  210.710751] infiniband mlx5_0:
> Couldn't create ib_mad QP0
> Jan 25 12:18:09 myhost kernel: [  210.711171] infiniband mlx5_0:
> Couldn't open port 1
> Jan 25 12:18:09 myhost kernel: [  210.711175] infiniband mlx5_0:
> ib_register_mad_agent: Invalid port
> Jan 25 12:18:09 myhost kernel: [  210.711357] infiniband mlx5_0:
> ib_register_mad_agent: Invalid port
> Jan 25 12:18:09 myhost kernel: [  210.712729] infiniband mlx5_0:
> ib_register_mad_agent: Invalid port
> Jan 25 12:18:09 myhost kernel: [  210.713834]
> 0000:41:00.1:mlx5_core_create_qp:202:(pid 769): current num of QPs 0x0
> Jan 25 12:18:09 myhost kernel: [  210.713837] command failed, status
> bad resource(0x5), syndrome 0x15a3c9
> Jan 25 12:18:09 myhost kernel: [  210.714960] infiniband mlx5_0: Port
> 1 not found
> Jan 25 12:18:09 myhost kernel: [  210.714964] infiniband mlx5_0:
> Couldn't close port 1 for agents
> Jan 25 12:18:09 myhost kernel: [  210.714968] infiniband mlx5_0: Port
> 1 not found
> Jan 25 12:18:09 myhost kernel: [  210.714971] infiniband mlx5_0:
> Couldn't close port 1
> --snip--
> 
> Here is the Mellanox adapter information:
> 41:00.0 Network controller [0207]: Mellanox Technologies MT27620
> Family [15b3:1013]
> 41:00.1 Network controller [0207]: Mellanox Technologies MT27620
> Family [15b3:1013]
> 
> I tried using the Mellanox provided driver
> (http://www.mellanox.com/page/products_dyn?product_family=27) and it
> works fine.
> 
> Obviously the Mellanox provided driver is newer then what's in my
> kernel version (4.1.11). Is there some type of configuration issue on
> my end, or is this an issue that is fixed with newer kernel versions
> (eg, later version 4.1.x or some other branch)? Or maybe some
> firmware/driver incompatibility (eg, too new of firmware on the
> adapters for the vanilla Linux kernel driver)?
> 
> I'd prefer to use the vanilla Linux kernel provided mlx5_core driver
> and not the Mellanox third-party driver.

Can you please try 4.5-rc2 version [1]?

[1] https://git.kernel.org/cgit/linux/kernel/git/dledford/rdma.git/log/?h=k.o/for-4.5-rc

> 
> 
> Thanks for your time.
> 
> 
> --Marc
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
