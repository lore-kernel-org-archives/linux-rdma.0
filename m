From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [FIXES for-next 3/4] mlx4_core: Adjustments to Flow Steering
 activation logic for SRIOV
Date: Sat, 8 Dec 2012 21:35:47 +0200
Message-ID: <CAJZOPZ+AAait8eH_M=ZNtp0XYOK4KyVgBv9UqAqMY+_qVmW+tA@mail.gmail.com>
References: <1354813920-27358-1-git-send-email-ogerlitz@mellanox.com>
	<1354813920-27358-4-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354813920-27358-4-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 6, 2012 at 7:11 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>
> Separate flow steering capability detection from the decision to activate.
>
> For the master (and for native), detect flow steering  capability in
> mlx4_dev_cap, but activate the appropriate steering type in a new function
> choose_flow_steering() based on detected data.
>
> For VFs, activate flow steering based on what was actually activated
> by the master, where that info is obtained via QUERY_HCA. This fixes
> the current VF detection which is wrongly based on QEURY_DEV_CAP.

Roland, there's a typo here, wanted to say QUERY_DEV_CAP, I guess you
can fix it up while merging

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
