From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] OpenSM Ignore invalid command line option -t 0
Date: Mon, 21 Mar 2011 16:03:33 +0200
Message-ID: <20110321140333.GB22502@calypso.voltaire.com>
References: <4D85A9B3.3080601@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4D85A9B3.3080601-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tamir Ronen <tamirr-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09:16 Sun 20 Mar     , Tamir Ronen wrote:
> 
> From acc805cdf65e12e2cee9bfbf360a176c55a5949f Mon Sep 17 00:00:00 2001
> From: Tamir Ronen <tamirr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Date: Thu, 17 Mar 2011 15:21:43 +0200
> Subject: [PATCH] Ignore command line option -t 0
> 
> If the timeout specified in the command line option -t equals zero,
> Print an error message and ignore it.
> ---

Applied. Thanks.

Also fixed description in the man/opensm.8.in
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
