From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags 0/6] Support HDR link speed
Date: Tue, 28 Nov 2017 17:11:32 -0500
Message-ID: <b3507cfd-4370-abe4-4dae-c62c291623e8@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add support in libibmad and infiniband-diags for HDR extended link speed
per MgtWG comments #9359-9377 and #9379.

1/6 libibmad/dump.c: Add PortInfo CapabilityMask2 bit decode for HDR support
2/6 libibmad/dump.c: Add HDR support for PortInfo LinkSpeedExt* fields
3/6 libibmad: Add support for HDRFECMode fields in PortInfoExtended attribute
4/6 ib[netdiscover portstate].c: Add HDR support
5/6 [perfquery.c ibdiag_comon.h]: Add support for HDR RS-FEC
6/6 ibdiag_common.c: In is_port_info_extended_supported, query PortInfo for port 0 when node is a switch
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
