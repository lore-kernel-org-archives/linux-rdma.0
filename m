From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Different signatures to ibv_open_xrcd - branch issue?
Date: Tue, 26 Mar 2013 15:56:35 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736F36825D@ORSMSX101.amr.corp.intel.com>
References: <51502C30.2000806@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A823736F367AB8@ORSMSX101.amr.corp.intel.com>
 <515173F2.4030506@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <515173F2.4030506-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I understand that currently I can't do RDMA using XRC, is that the case?
> How complicated are the required modifications needed to make librdmacm
> complies to the libibverbs changes?

The changes needed for the librdmacm to support XRC aren't huge.  The complication is getting XRC merged with libibverbs.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
