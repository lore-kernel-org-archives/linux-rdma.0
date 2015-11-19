From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH for-next 10/10] IB/iser: Support the remote invalidation
 exception
Date: Thu, 19 Nov 2015 02:01:06 -0800
Message-ID: <20151119100106.GA24120@infradead.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <564D7653.8070101-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pete Wyckoff <pw-VNBDo6LsbKA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 19, 2015 at 09:12:20AM +0200, Or Gerlitz wrote:
> This is wrong assertion.
> 
> Look on the code throughout the iser path done from iser_send_command, we
> allowed the command associated with the
> iscsi task to be IN, OUT, both or none, when we do all the dma-mapping,
> memory registrations and such for either of the
> needed directions and same on the completion path.

Internal code structure is one thing, ever supporting bidi is another
one.  Without QUEUE_FLAG_BIDI a driver has never supported bidirectional
requests.  And iSER never had that flag set in mainline.  So even if you
spent of time supporting bidi in iSER it never was supported and all
that great support was entirely untested the last 10 years.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
