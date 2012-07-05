From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next V1 10/29] net/mlx4_core: Implement mechanism for
 reserved qkeys
Date: Thu, 5 Jul 2012 16:26:43 -0700
Message-ID: <CAL1RGDVXTWs6Xi2JQ=7-RiZUePfc6SoUsCHHdbS9XLUQyim6UA@mail.gmail.com>
References: <1340094121-14858-1-git-send-email-jackm@dev.mellanox.co.il> <1340094121-14858-11-git-send-email-jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1340094121-14858-11-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 19, 2012 at 1:21 AM, Jack Morgenstein
<jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> For security reasons (i.e., to prevent guests from sending MADs to tunnel QPs
> belonging to other guests), each proxy-tunnel qp pair is assigned a unique,
> reserved, qkey.  These qkeys are available only for proxy and tunnel qp's --
> if the guest tries to use these qkeys with other qp's, it will fail.

How does a guest OS know which Q_Key it's allowed to use?  I understand
you stick the reserved Q_Keys in the privileged Q_Key area (MSB set) so
it's not an issue for applications but I don't understand how you can avoid
breaking unlucky guest OSes.

Part of my problem is I don't see anywhere that
MLX4_RESERVED_QKEY_MASK is actually used in this patch...

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
