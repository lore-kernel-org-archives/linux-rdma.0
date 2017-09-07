From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/3] mlx5: Add support for managing QP with a
 given source QP number
Date: Wed, 6 Sep 2017 23:50:15 -0700
Message-ID: <20170907065015.GA29974@ca-dev46.us.oracle.com>
References: <1504708729-15249-1-git-send-email-yishaih@mellanox.com>
 <1504708729-15249-3-git-send-email-yishaih@mellanox.com>
 <20170906151222.GA23532@yuvallap>
 <1387444b-7c9d-d26c-d089-83b0d4b047d9@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1387444b-7c9d-d26c-d089-83b0d4b047d9-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 06, 2017 at 06:56:29PM +0300, Yishai Hadas wrote:
> On 9/6/2017 6:12 PM, Yuval Shaia wrote:
> >On Wed, Sep 06, 2017 at 05:38:48PM +0300, Yishai Hadas wrote:
> >>Add support to create a QP with source QPN (e.g. IPoIB QPN) over UD QP.
> >
> >Sorry, i missed the kernel patches.
> >Is this UD limitation is for mlx5 only? Asking as i see no limitation in
> >the verb layer (patch 1/3).
> 
> From API point of view as was introduced by the verbs patch there is
> no limitation. The mlx5 driver implements the use case for UD QP to
> accelerate IPoIB packets.
> 
> >If no, any plans for CM?
> No plan for CM at the moment, however, it may be considered in the
> future based on demand/use case.

I can give you use case - migration.

> 
> Thanks for looking at.
> Yishai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
