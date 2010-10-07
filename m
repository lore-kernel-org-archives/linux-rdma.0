From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Maximum size for memory registration (ibv_reg_mr)
Date: Thu, 7 Oct 2010 12:13:16 +0200
Message-ID: <20101007101316.GA9605@mtldesk30>
References: <036401cb5c35$85829220$9087b660$@edu>
 <adar5giahvd.fsf@cisco.com>
 <037101cb5c39$b98036f0$2c80a4d0$@edu>
 <adamxr6ahd3.fsf@cisco.com>
 <4CAD9572.5060507@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4CAD9572.5060507-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Bharath Ramesh <bramesh-PjAqaU27lzQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 07, 2010 at 11:40:02AM +0200, Or Gerlitz wrote:
> Roland Dreier wrote:
> >> max_mr_size returned by calling ibv_devinfo is 0xffffffffffffffff. Does this mean the size is unlimited?
> > It means that the query function might be returning bad data.  What adapter is it?
> 
> Yep, mlx4_ib_query_device does props->max_mr_size = ~0ull ... 
> 
> Jack, what would it take to fix that? I took a look and other settings are taken from 
> dev->dev->caps.xxx where caps is of type mlx4_caps which is in turn filled @ drivers/net/mlx4/main.c 
> :: mlx4_dev_cap I wasn't sure what field/computation would exactly account for later setting max_mr_size
> 
It is not that trivial to calculate this value.
If you create a MR in kernel, it covers the entire address space and
the HCA does not pose any limit since you do not consume MTTs.
And if you use MTTs then the page size is a parameter in this
calculation - huge page, regular page etc.

Do leaving it as is seems to be the most accurate thing...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
