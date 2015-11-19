From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 10/10] IB/iser: Support the remote invalidation exception
Date: Thu, 19 Nov 2015 13:17:11 +0200
Message-ID: <CAJ3xEMjfa8iAEc_Xb7W=xy62stQo9MrHUd3RvTvKpwy=4pbeew@mail.gmail.com>
References: <564AF929.60209@dev.mellanox.co.il>
	<564AFB93.9010602@mellanox.com>
	<564B00C3.1030506@dev.mellanox.co.il>
	<CAJ3xEMjB_5pzuKyXJRXxHEvaFeHwmBLK31OFFtmA-RRY0i+82A@mail.gmail.com>
	<564C6347.3040501@dev.mellanox.co.il>
	<CAJ3xEMhxOQ-HXKiXuBOKNet0VeDbNQingphFvzUXBiLcDjCmNQ@mail.gmail.com>
	<20151118135237.GA3214@infradead.org>
	<CAJ3xEMiBwowDFPEVqjKr-DMeDiWih8qbwshP2QbaH_56aNsRDg@mail.gmail.com>
	<20151118141023.GA10198@infradead.org>
	<564D7653.8070101@mellanox.com>
	<20151119100106.GA24120@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151119100106.GA24120-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Pete Wyckoff <pw-VNBDo6LsbKA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 19, 2015 at 12:01 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> Internal code structure is one thing, ever supporting bidi is another
> one.  Without QUEUE_FLAG_BIDI a driver has never supported bidirectional
> requests.  And iSER never had that flag set in mainline.  So even if you
> spent of time supporting bidi in iSER it never was supported and all
> that great support was entirely untested the last 10 years.

Christoph,

To make it clear iser's role is very well defined and strict w.r.t
supporting bidis, we should

on IO submission path

1. dma map the SC properly in, out, both or none
2. memory register what's needed
3. put in the iser header 1,2 or 0 keys

on IO completion path

4. set a pointer to the iscsi response header etc
5. memory unregister what's needed
6. dma unmap properly
7. call up to the iscsi/scsi stack with that pointer

anything else that I missed?

AFAIK steps 1..7 were supported ok in the past, probably now not, we
should fix at some point



Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
