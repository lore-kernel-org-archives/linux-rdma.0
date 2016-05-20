From: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] libibverbs: add ARM64 memory barrier macros
Date: Fri, 20 May 2016 16:39:38 +0000
Message-ID: <9C6B67F36DCAFC479B1CF6A967258A8C7DDBB201@ORSMSX115.amr.corp.intel.com>
References: <20160520163207.B99DCE0B9D@smtp.ogc.us>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160520163207.B99DCE0B9D-/5N3P9jjx0xzbRFIqnYvSA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>The default generic barriers are not correct for ARM64. This results in data corruption.  The correct macros are lifted from the linux kernel.

Does this mean that the code you want to add to libibverbs will be tainted with GPL since they come from the Linux kernel.
I know that there are a lot of people that will not use a GPL library, since it could taint their applications with GPL if they 
link to that library. I thought that is why LGPL was invented to prevent such tainting. 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
