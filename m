From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] libibumad: document the setting of errno for umad_send
 and umad_recv
Date: Tue, 2 Apr 2013 15:10:44 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E01568021@CRSMSX102.amr.corp.intel.com>
References: <20130329112119.1bb9ee1f7e687fc40c7a841d@intel.com>
 <515AA29B.6000800@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <515AA29B.6000800-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> 
> Hi Hal, Ira,
> 
> Just wondered why are you setting errno in the mad libraries? so far we
> managed to avoid doing so in libibverbs, librdmacm, libmlx4 ones.

Turns out umad has been doing so since ~2007.  I don't know if any users are depending on it but that is the current interface so I think it should be documented.

For libibmad there is just no other way to get errors to the users without doing so.  I don't like it but after a long discussion between Jason, Brandon, and myself this was the only path to take.  With libibmad I don't think the impact is quite as bad as I don't think there are as many users.

Ira

> 
> Or.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
