From: Arthur Kepner <akepner-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [PATCH/RFC] mlx4_core: module param to limit msix vec
	allocation
Date: Mon, 14 Jun 2010 08:23:47 -0700
Message-ID: <20100614152347.GX22247@sgi.com>
References: <20100610165921.GF22247@sgi.com> <20100613065324.GA2408@eli-vm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100613065324.GA2408@eli-vm>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 13, 2010 at 09:53:24AM +0300, Eli Cohen wrote:
> ....
> how many CPU cores are in your system? What kernel version did you
> use?

I'm almost certain that it was a 2048 core system (it's not available 
right now for me to verify).

We used 2.6.32.12 (sles11 sp1).

-- 
Arthur
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
