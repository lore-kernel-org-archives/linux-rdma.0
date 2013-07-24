From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] ib/mad: remove Device Mgmt from RMPP class list
Date: Wed, 24 Jul 2013 22:22:56 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237384567CA1@ORSMSX109.amr.corp.intel.com>
References: <20130724144426.5a63669ea6107c8a3e6c1867@intel.com>
 <51F04E2D.9060708@dev.mellanox.co.il>
 <2807E5FD2F6FDA4886F6618EAC48510E021B0B9D@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E021B0B9D-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > See Annex 8; DevMgt class version 2 rather than 1 is currently supported.
> 
> Could older devices still return version 1?  If so the kernel should allow
> DevMgt without RMPP, correct?

This check has been this way since 2.6.17.  I think it's reasonable to say that there aren't any devices using version 1 that are running with Linux.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
