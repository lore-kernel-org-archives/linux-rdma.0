From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Does the CMA support connecting UC QPs?
Date: Tue, 6 Sep 2011 15:44:14 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E59B4E@ORSMSX101.amr.corp.intel.com>
References: <CALvMawo8Os7yy0dFpZogyOriY+wcf5gU0CRm-Wv2oAkWCxse=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALvMawo8Os7yy0dFpZogyOriY+wcf5gU0CRm-Wv2oAkWCxse=Q@mail.gmail.com>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Can one connect a UC QPs using the CMA?

No, but the xrc patches should enable this.

An app may be able to create UC QPs and connect them, but the rdma_cm will treat the connection as RC.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
