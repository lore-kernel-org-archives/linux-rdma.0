From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: completions for unsignalled WRs following rdma_disconnect
Date: Mon, 27 Aug 2012 22:12:32 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A8B4AF@ORSMSX101.amr.corp.intel.com>
References: <BD76C1FD2DEA4802893C6E5BE6B413F6@us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BD76C1FD2DEA4802893C6E5BE6B413F6-HZWafpOgb61l57MIdRCFDg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ian Druch <Ian.Druch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Could someone confirm that rdma_disconnect is supposed to generate
> completion event(s) for all posted work requests, whether signaled or not?

rdma_disconnect transitions the QP into the error state, which should flush all posted work requests.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
