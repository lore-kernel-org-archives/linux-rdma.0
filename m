From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] Add new verb: uv_query_port_max_datagram()
Date: Mon, 19 Aug 2013 22:07:29 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CA6D6B@ORSMSX109.amr.corp.intel.com>
References: <1376942704-25270-1-git-send-email-jsquyres@cisco.com>
 <1828884A29C6694DAF28B7E6B8A8237388CA6D34@ORSMSX109.amr.corp.intel.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F80A810@xmb-rcd-x01.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EF66BBEB19BADC41AC8CCF5F684F07FC4F80A810-nsZYYkk5h5QQ2GdVW7+PtKBKnGwkPULj@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> It doesn't *break* the ABI, but it does add a new downcall into the kernel.
> That requires bumping the ABI version to 7, no?

No - adding a new command is fine.  Older kernels will return ENOSYS if that command is not supported.  In that case, you can handle things like Jason suggested.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
