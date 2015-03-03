From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH libibumad] umad.h: Remove umad_reg_flags from enum
 declaration
Date: Tue, 3 Mar 2015 20:33:59 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC4E7E3@CRSMSX101.amr.corp.intel.com>
References: <54F61829.3070903@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54F61829.3070903-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "rafiw-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <rafiw-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hal Rosenstock
> Sent: Tuesday, March 03, 2015 12:23 PM
> To: linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
> Cc: Weiny, Ira; rafiw-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
> Subject: [PATCH libibumad] umad.h: Remove umad_reg_flags from enum
> declaration
> 
> 
> This causes it to be a global variable which causes linking issues when used by
> multiple files linked together. It results in multiple definition of
> `umad_reg_flags'.
> 
> Found-by: Rafi Weiner <rafiw-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
