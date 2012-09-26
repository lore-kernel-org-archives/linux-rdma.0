From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mlx4_core: Fix crash on uninitialized priv->cmd.slave_sem
Date: Tue, 25 Sep 2012 21:46:32 -0700
Message-ID: <CAL1RGDUm4Zxnoby5O2RkoahbPUtYBL5UPxAFiwDnNNv4pdy7vA@mail.gmail.com>
References: <1348634552-21047-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348634552-21047-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

By the way, I still get a steady stream of

mlx4_core 0000:05:00.0: Unknown command:0x4d accepted from slave:0
mlx4_core 0000:05:00.0: Sense command failed for port: 1

once I load the driver... it seems SENSE_PORT is a wrapped command
but there's no entry in cmd_info[] for it?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
