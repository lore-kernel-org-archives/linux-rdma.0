From: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] librdmacm/mcraw: Add a new test application for
 user-space IBV_QPT_RAW_ETH QP type
Date: Tue, 22 Jun 2010 12:48:53 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801E9851BD@irsmsx503.ger.corp.intel.com>
References: <BE2BFE91933D1B4089447C64486040801E7635F7@irsmsx503.ger.corp.intel.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF259E0EB554@orsmsx501.amr.corp.intel.com>
 <BE2BFE91933D1B4089447C64486040801E87423E@irsmsx503.ger.corp.intel.com>
 <4C1F4A2F.4060701@Voltaire.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C1F4A2F.4060701-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks Moni, 

I treated them as accepted. 

Sean,
response for your question is that changes with RAW_QP patches should be accepted first to have that application working.

Mirek


-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Moni Shoua
Sent: Monday, June 21, 2010 1:17 PM
To: Walukiewicz, Miroslaw
Cc: Hefty, Sean; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [PATCH] librdmacm/mcraw: Add a new test application for user-space IBV_QPT_RAW_ETH QP type

Walukiewicz, Miroslaw wrote:
> No, no more changes are necessary. It is a standalone application.
> 
> Mirek
> 
Are you sure?
AFAIK, patches to kernel and libibverbs are required which were not accepted yet.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
