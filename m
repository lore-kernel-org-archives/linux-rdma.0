From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/7] libibumad: Provide MAD definitions with libibumad
Date: Wed, 20 Feb 2013 16:29:58 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736F34E976@ORSMSX101.amr.corp.intel.com>
References: <1359409135-559-1-git-send-email-sean.hefty@intel.com>
 <5124F212.2060503@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A823736F34E958@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736F34E958-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I need to check the kernel code, but I believe that the RMPP header is exposed.

I looked at copy_recv_mad(), and it copies the entire 256-byte MAD to user space, which includes any RMPP header, followed by any additional segmented data.  So most of the RMPP definitions are relevant, the exceptions possibly being UMAD_RMPP_TYPE_[ACK | STOP | ABORT].  IMO - I would keep those for completeness.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
