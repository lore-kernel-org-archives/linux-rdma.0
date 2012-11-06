From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB: fix task hanging on error recovery
Date: Tue, 6 Nov 2012 18:45:46 +0100
Message-ID: <CAJZOPZ+jv7Z9PsoQ1YZa099cX-zU4DYv+-TZgw+NHgik7Tnzqw@mail.gmail.com>
References: <1350683896-3928-1-git-send-email-klebers@linux.vnet.ibm.com>
	<50929160.1000109@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237346AC5B9F@ORSMSX101.amr.corp.intel.com>
	<50981044.3010901@dev.mellanox.co.il>
	<50982799.5020500@linux.vnet.ibm.com>
	<CAJZOPZKEqAT2KPSiwagccdVOCEqssKRPdVh94DdqkuNhXsJxYg@mail.gmail.com>
	<CAJZOPZKL-C6HPzhDPidLjPaWqEc+PbitzBU05-UASN75Xkh0Pw@mail.gmail.com>
	<5098ED70.4010900@linux.vnet.ibm.com>
	<CAJZOPZ+_-VTOA45MY5rS=tNK8MYK1Kc0ssGrrV3xOUd0=w97Yg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZ+_-VTOA45MY5rS=tNK8MYK1Kc0ssGrrV3xOUd0=w97Yg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kleber Sacilotto de Souza <klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cascardo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <cascardo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 6, 2012 at 6:44 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> the other parts are OK to me.

I wanted to say that you stepped on real problem and provided a
solution, Roland's wondering is ofcourse
correct, how do we avoid use after free in very slow non pci hotunplug cases?!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
