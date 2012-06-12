From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 03/29] IB/mlx4: Add run-time switchable error
 path debug output capability
Date: Tue, 12 Jun 2012 00:00:03 -0700
Message-ID: <CAL1RGDVpm+2ykjrt8=rHkjVtRNiiCNOQW8OTdedsg-qJNBfBag@mail.gmail.com>
References: <1339411570-4689-1-git-send-email-jackm@dev.mellanox.co.il> <1339411570-4689-4-git-send-email-jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339411570-4689-4-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 11, 2012 at 3:45 AM, Jack Morgenstein
<jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> The facility is on-off switchable at run-time
> (i.e., module-parameter controlled, off by default).

In the modern kernel, let's just use CONFIG_DYNAMIC_DEBUG for run time
control.  In other words no config option, no module parameter, just
use pr_debug.  (and you can define pr_fmt to get all the effect of the
mlx4_ib_dbg wrapper macro)

However it might make sense to come up with a wrapper that passes
through to dev_dbg so you can see which device is involved in the
debugging output (seems like it might be especially useful when you
have lots of VFs floating around).

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
