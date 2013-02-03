From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Intermitted "Failed to obtain HW semaphore, aborting" error
Date: Sun, 3 Feb 2013 09:11:23 +0200
Message-ID: <510E0D9B.9020907@mellanox.com>
References: <510DF227.30307@vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <510DF227.30307-PjAqaU27lzQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bharath Ramesh <bramesh-PjAqaU27lzQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 03/02/2013 07:14, Bharath Ramesh wrote:
> Intermittently a couple of nodes in our cluster throw the error 
> "Failed to obtain HW semaphore, aborting" on boot. When this error 
> occurs we are unable to use IB on those nodes, unloading and reloading 
> the module doesnt help. 

load mlx4_core with debug_level=1 and send the resulted dmesg  along 
with the lspci info of the card ("$ lspci | grep Mellanox")


> I was wondering what could be causing this error, google only brings 
> up the source code and no discussion about this error. We are using 
> OFED-1.5.4, any help in debugging and resolving this issue is greatly 
> appreciated.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
