From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ewg] [PATCHv8 03/11] IB/umad: Enable support only for IB ports
Date: Mon, 17 May 2010 16:11:11 +0300
Message-ID: <20100517131111.GD663@mtldesk030.lab.mtl.com>
References: <20100218172354.GD12286@mtls03>
	<adazl0eatj6.fsf@roland-alpha.cisco.com>
	<20100506104848.GA29792@mtldesk030.lab.mtl.com>
	<4BEF80D9.5060200@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4BEF80D9.5060200-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, May 16, 2010 at 08:21:29AM +0300, Or Gerlitz wrote:
> Eli, any reason not to let reading (e.g perfquery) the HCA/port
> traffic counters with  IBoE?
> 
RoCE assumes Eth management practices (including performance
management). But this is an interesting idea that we can consider for
the future.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
