From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: RDMA Multicasting
Date: Thu, 9 Apr 2015 09:56:21 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1504090955080.19714@gentwo.org>
References: <A1EC1DB6D8AEAF4CB8006B3653F61C5471F997F9@CMEXMB1.ad.emulex.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A1EC1DB6D8AEAF4CB8006B3653F61C5471F997F9-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Allen Andrews <Allen.Andrews-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 8 Apr 2015, Allen Andrews wrote:

> I am trying to find out if RDMA Multicasting is supported on RoCE in Linux.
> If so, is it supported above the verbs interface?

RDMA multicasting? You mean sending ud(or udp) messages via the RDMA API?
That works even without RoCE.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
