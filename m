From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH infiniband-diags] ibportstate.c: Cosmetic changes to
 MLNX Extended PortInfo
Date: Mon, 30 Jun 2014 14:55:23 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E04BCC9EE@CRSMSX101.amr.corp.intel.com>
References: <53974D11.1030901@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53974D11.1030901-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> 
> for consistency with smpquery mepi output:
> 
> smpquery mepi 24 1
> # MLNX ext Port info: Lid 24 port 1
> StateChangeEnable:...............0x00
> LinkSpeedSupported:..............0x01
> LinkSpeedEnabled:................0x01
> LinkSpeedActive:.................0x00
> 
> and to prepare for IBTA extended PortInfo attribute

Thanks applied,
Ira

> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
