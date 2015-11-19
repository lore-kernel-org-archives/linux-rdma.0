From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 10/10] IB/iser: Support the remote invalidation
 exception
Date: Thu, 19 Nov 2015 11:15:57 +0200
Message-ID: <564D934D.4020809@dev.mellanox.co.il>
References: <1447691861-3796-11-git-send-email-sagig@mellanox.com>
 <564ADFCC.4030109@mellanox.com> <564AF929.60209@dev.mellanox.co.il>
 <564AFB93.9010602@mellanox.com> <564B00C3.1030506@dev.mellanox.co.il>
 <CAJ3xEMjB_5pzuKyXJRXxHEvaFeHwmBLK31OFFtmA-RRY0i+82A@mail.gmail.com>
 <564C6347.3040501@dev.mellanox.co.il>
 <CAJ3xEMhxOQ-HXKiXuBOKNet0VeDbNQingphFvzUXBiLcDjCmNQ@mail.gmail.com>
 <20151118135237.GA3214@infradead.org>
 <CAJ3xEMiBwowDFPEVqjKr-DMeDiWih8qbwshP2QbaH_56aNsRDg@mail.gmail.com>
 <20151118141023.GA10198@infradead.org> <564D7653.8070101@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <564D7653.8070101-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pete Wyckoff <pw-VNBDo6LsbKA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> Sagi, do we still do IN, OUT, both or none? if not, where this stopped
> to be supported? how large would be the fix?

Or, it's hard for me to say where exactly it stopped being supported
because I've never tested it and I'm not convinced it was ever
supported.

I'm exhausted with this discussion so I'll change the tiny condition
and bidi will remain unsupported until we'll decide we want to get it
working.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
