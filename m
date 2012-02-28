From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/6] IB/core: fix wrong display of rate in sysfs
Date: Tue, 28 Feb 2012 08:45:10 +0200
Message-ID: <4F4C77F6.6070807@mellanox.com>
References: <alpine.LRH.2.00.1201111850330.10264@ogerlitz.voltaire.com> <alpine.LRH.2.00.1201111856160.10264@ogerlitz.voltaire.com> <1828884A29C6694DAF28B7E6B8A82373256757DB@ORSMSX101.amr.corp.intel.com> <CAJZOPZJHbuyfXbQdEQ3QZt3O+bLTdzpBJOfUmB-Rqrvi9WUXuQ@mail.gmail.com> <4F49EBD1.7030900@mellanox.com> <CAL1RGDWNh1_fFWS=gMxo8vm-n46TOTxbu+GmRNE1YEmAyuE1Tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWNh1_fFWS=gMxo8vm-n46TOTxbu+GmRNE1YEmAyuE1Tw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/27/2012 7:23 PM, Roland Dreier wrote:
> It doesn't really work if everything needs me to micromanage every 
> step... the original patch obviously made some ugly code uglier, Sean 
> pointed out an obvious way to make things cleaner. If no one has a 
> problem, I'll just go ahead with the following...

okay, got the message, I could go implementing Sean's suggestion myself, 
next time... also on the other direction, when Sean provide ack/review 
on patches, I was thinking they can be accepted without too deep 
inspection which consumes many cycles from you? I'll test this patch, 
provide ack and adjust the 1st patch on the series such that it applies 
on top of this one.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
