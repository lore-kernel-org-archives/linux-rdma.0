From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 for-next 1/6] IB/ipoib: Fix ipoib_neigh hashing to
 use the correct daddr octets
Date: Tue, 12 Feb 2013 18:53:09 +0200
Message-ID: <511A7375.6000303@mellanox.com>
References: <1360079337-8173-1-git-send-email-ogerlitz@mellanox.com> <1360079337-8173-2-git-send-email-ogerlitz@mellanox.com> <1828884A29C6694DAF28B7E6B8A8237368B99DDC@ORSMSX101.amr.corp.intel.com> <511A560D.8020900@mellanox.com> <1828884A29C6694DAF28B7E6B8A8237368B9A045@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237368B9A045-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/02/2013 18:33, Hefty, Sean wrote:
> Have you run the V2 patch through sparse?

oops, I see now that the V2 patches introduced some sparse warnings, 
will fix for V3, thanks for spotting that over.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
