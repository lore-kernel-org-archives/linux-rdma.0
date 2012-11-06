From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB: fix task hanging on error recovery
Date: Tue, 6 Nov 2012 06:30:24 +0100
Message-ID: <CAJZOPZKL-C6HPzhDPidLjPaWqEc+PbitzBU05-UASN75Xkh0Pw@mail.gmail.com>
References: <1350683896-3928-1-git-send-email-klebers@linux.vnet.ibm.com>
	<50929160.1000109@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A8237346AC5B9F@ORSMSX101.amr.corp.intel.com>
	<50981044.3010901@dev.mellanox.co.il>
	<50982799.5020500@linux.vnet.ibm.com>
	<CAJZOPZKEqAT2KPSiwagccdVOCEqssKRPdVh94DdqkuNhXsJxYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZKEqAT2KPSiwagccdVOCEqssKRPdVh94DdqkuNhXsJxYg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kleber Sacilotto de Souza <klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cascardo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <cascardo-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org" <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Mon, Nov 5, 2012 at 9:54 PM, Kleber Sacilotto de Souza
> <klebers-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
>>
>>
>> The driver is not returning the completions because during EEH (Extended
>> Error Handling) recovery on powerpc systems the PCI slot is frozen, and
>> we are not going to receive any interrupt from the adapter until we
>> remove it completely and reset it.
>>

maybe, but per Sean's comment this possible problem is irrelevant for ucm/ucma
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
