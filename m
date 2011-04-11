From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/4] infiniband-diags: Make sure buffers are set to zero
 before calling xxx_query_via
Date: Mon, 11 Apr 2011 11:05:18 -0400
Message-ID: <BANLkTikT2LXPZBuZ1EzdKBvK_wP7O8dnuQ@mail.gmail.com>
References: <4DA0799A.7080108@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DA0799A.7080108-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aviad Yehezkel <aviadye-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Apr 9, 2011 at 11:22 AM, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>
> where xxx is smp and pma. This is a cosmetic change based on
> IBA 1.2.1 vol 1 p.725 line 9:
>
> When constructing a response MAD that contains all or part of
> the corresponding request MAD, it is acceptable to include the
> contents of reserved fields in the request MAD in the response
> MAD without regard to their content. That is, such fields need not
> be set to zero in the response MAD.

This patch stands on it's own and should've been just [PATCH] and not
[PATCH 4/4]. It was my mistake when I generated/sent these patches.

-- Hal

> Signed-off-by: Aviad Yehezkel <aviadye-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
