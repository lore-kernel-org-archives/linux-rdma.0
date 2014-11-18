From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH infiniband-diags] New MAD SM:PortInfoExtended and
 changing PM:PortExtendedSpeedsCounters
Date: Tue, 18 Nov 2014 18:59:30 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CBBF4D9@CRSMSX101.amr.corp.intel.com>
References: <1416236249-31791-1-git-send-email-danby@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1416236249-31791-1-git-send-email-danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Ben Yosef <danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: Dan Ben Yosef [mailto:danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
> Sent: Monday, November 17, 2014 6:57 AM
> To: Weiny, Ira
> Cc: danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: [PATCH infiniband-diags] New MAD SM:PortInfoExtended and changing
> PM:PortExtendedSpeedsCounters
> 
> This change needed for EDR support.
> This change includes:
> 1. Adding new MAD option to smpquery: PortInfoExtended (PIE).
> 2. Changing perfquery to support PortExtendedSpeedsCounters with RSFEC
> mode active.
> 
> Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Applied with the following change:

> -static void extended_speeds_query(ib_portid_t * portid, int port, uint64_t
> ext_mask)
> +static uint8_t is_fec_mode_active(ib_portid_t * portid, int port,
> +				  uint16_t cap_mask)


Changed to is_rsfec_mode_active...

Thanks,
Ira



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
