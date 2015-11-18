From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 10/10] IB/iser: Support the remote invalidation exception
Date: Wed, 18 Nov 2015 15:58:48 +0200
Message-ID: <CAJ3xEMiBwowDFPEVqjKr-DMeDiWih8qbwshP2QbaH_56aNsRDg@mail.gmail.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
	<1447691861-3796-11-git-send-email-sagig@mellanox.com>
	<564ADFCC.4030109@mellanox.com>
	<564AF929.60209@dev.mellanox.co.il>
	<564AFB93.9010602@mellanox.com>
	<564B00C3.1030506@dev.mellanox.co.il>
	<CAJ3xEMjB_5pzuKyXJRXxHEvaFeHwmBLK31OFFtmA-RRY0i+82A@mail.gmail.com>
	<564C6347.3040501@dev.mellanox.co.il>
	<CAJ3xEMhxOQ-HXKiXuBOKNet0VeDbNQingphFvzUXBiLcDjCmNQ@mail.gmail.com>
	<20151118135237.GA3214@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151118135237.GA3214-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Pete Wyckoff <pw-VNBDo6LsbKA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 18, 2015 at 3:52 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> Fortunately neither the iSER target or initiator ever support the
> nightmare called bidi commands,

I honestly don't know why you call it nightmare nor what make you
make that strong assertion. I checked with Alex N. the TGT iser
transport author and he confirmed to me that bidi's worked on TGT,
as for the Linux upstream initiator, I thought that was the case too, but
I never saw it my eyes, and Pete's paper states he had to change the code,
so on that I can't be sure.

>  and I'be happy o kill of that cruft entirely if we could.

that's beyond the scope of this thread, I guess..
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
