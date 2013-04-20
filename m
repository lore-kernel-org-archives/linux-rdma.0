From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] Ad IB_MTU_1500|9000 enums.
Date: Sat, 20 Apr 2013 23:29:59 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736FD1DD83@ORSMSX109.amr.corp.intel.com>
References: <1364994796-10642-1-git-send-email-jsquyres@cisco.com>
 <515D728B.5010202@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A823736F36B8B5@ORSMSX101.amr.corp.intel.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0156FC7B@CRSMSX102.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A823736F36B9EA@ORSMSX101.amr.corp.intel.com>
 <2807E5FD2F6FDA4886F6618EAC48510E0156FCB1@CRSMSX102.amr.corp.intel.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC43FFA8E0@xmb-rcd-x01.cisco.com>
 <1828884A29C6694DAF28B7E6B8A823736F36CCCA@ORSMSX101.amr.corp.intel.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC43FFDBA8@xmb-rcd-x01.cisco.com>
 <2807E5FD2F6FDA4886F6618EAC48510E01575317@CRSMSX102.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A823736F36D455@ORSMSX101.amr.corp.intel.com>
 <2807E5FD2F6FDA4886F6618EAC48510E015759CF@CRSMSX102.amr.corp.intel.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4401EEDD@xmb-rcd-x01.cisco.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC44042439@xmb-rcd-x01.cisco.com>
 <51721196.9040606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51721196.9040606-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> This seems reasonable, but still concerns me a bit.  The original
> version was flat out wrong because you can't re-arrange any exposed enum
> like this without requiring that all user space apps be recompiled.
> This is especially true because ibv_mtu_enum_to_int is an inline

ib_mtu_enum_to_int() is a kernel function, not user space, so I think we're fine here, unless you're concerned about drivers built out of tree.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
