From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/main.c: Handle daemon mode with guid specified as
 0 more gracefully
Date: Wed, 25 Jul 2012 10:52:39 +0300
Message-ID: <20120725075239.GD5690@calypso>
References: <4FFB119E.2090805@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4FFB119E.2090805-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Philipp Thomas <pth-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Hal,

On 13:15 Mon 09 Jul     , Hal Rosenstock wrote:
> 
> As pointed out by Philipp Thomas <pth-l3A5Bk7waGM@public.gmane.org>:
> 
> Currently opensm will silently fail if you pass '-g 0 -B'. As you can't
> ask for a port, exit with failure so admin can see the reason
> for opensm's failure.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
