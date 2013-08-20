From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] Add new verb: uv_query_port_max_datagram()
Date: Tue, 20 Aug 2013 00:59:41 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CA6DF1@ORSMSX109.amr.corp.intel.com>
References: <1376942704-25270-1-git-send-email-jsquyres@cisco.com>
 <1828884A29C6694DAF28B7E6B8A8237388CA6D9F@ORSMSX109.amr.corp.intel.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F80AF3E@xmb-rcd-x01.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EF66BBEB19BADC41AC8CCF5F684F07FC4F80AF3E-nsZYYkk5h5QQ2GdVW7+PtKBKnGwkPULj@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > This breaks the libibverbs ABI.  You can't modify ibv_context_ops because it
> changes struct ibv_context.
> 
> Any suggestions on how one adds a new driver call without breaking ABI?

It could be built on the verbs extension mechanism.

Is it necessary to call into a provider library, versus simply dropping into the kernel?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
