From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC PATCH 00/16] ib_mad: Add support for Intel Omni-Path
 Architecture (OPA) MAD processing.
Date: Mon, 1 Dec 2014 22:33:30 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CBCD52F@CRSMSX101.amr.corp.intel.com>
References: <1415908465-24392-1-git-send-email-ira.weiny@intel.com>
 <54750DCF.90308@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54750DCF.90308-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eitan Zahavi <eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'll get back to you on the IBTA questions when I can but I wanted to address this question.

> 
> Has regression testing yet been done with these changes in terms of IBTA MAD
> support in terms of agents, SMs, and diagnostics to be sure that things still work
> properly ?
> 

Yes.  I have tested OpenSM and infiniband-diags running on qib and mlx4 hardware.  I don't have access to mlx5 or the older ehca and mthca cards.

-- Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
