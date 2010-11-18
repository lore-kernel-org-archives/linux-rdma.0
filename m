From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] mlx4: properly mask MGM entry members count
Date: Thu, 18 Nov 2010 08:51:42 +0200
Message-ID: <20101118065142.GB20369@mtldesk30>
References: <20101115140829.GA20355@mtldesk30>
 <ada62vxl046.fsf@cisco.com>
 <20101116180732.GB29132@mtldesk30>
 <ada1v6klwil.fsf@cisco.com>
 <20101117090134.GA20369@mtldesk30>
 <adasjyzkfyw.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adasjyzkfyw.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 17, 2010 at 09:38:47AM -0800, Roland Dreier wrote:
>  > > Where is the change in handling in the members_count field?  In the firmware?
>  > > 
>  > The firmware now distinguishes between differnet multicast addresses
>  > according to a protocol field located in the high MS byte which
>  > previously was reserved. The patches that Alekseys will will probably
>  > send later make use of this.
> 
> OK, so what you seem to be saying is that this patch is not fixing
> anything until we add Alekseys patches?
> 
It only keeps the code and the PRM in sync.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
