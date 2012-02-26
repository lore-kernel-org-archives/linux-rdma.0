From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/6] IB/core: fix wrong display of rate in sysfs
Date: Sun, 26 Feb 2012 10:22:41 +0200
Message-ID: <4F49EBD1.7030900@mellanox.com>
References: <alpine.LRH.2.00.1201111850330.10264@ogerlitz.voltaire.com> <alpine.LRH.2.00.1201111856160.10264@ogerlitz.voltaire.com> <1828884A29C6694DAF28B7E6B8A82373256757DB@ORSMSX101.amr.corp.intel.com> <CAJZOPZJHbuyfXbQdEQ3QZt3O+bLTdzpBJOfUmB-Rqrvi9WUXuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJHbuyfXbQdEQ3QZt3O+bLTdzpBJOfUmB-Rqrvi9WUXuQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/11/2012 9:45 PM, Or Gerlitz wrote:
> Yep, this function is surely not programming state of the art.. 
> however, except for SDR, the above line doing rate = rate * 
> ib_width_enum_to_int(attr.active_width) would hold for all the speeds 
> and all the widths (1X, 4X, 12X), if we just set rate (possibly as a 
> string value) one time in each switch case, we would need to repeat 
> that multiplication there... I'm okay with that, would you recommend 
> to go that way? Roland any preference? Or. 

Hi Roland,

Could you please let me know if you want a change in this patch, or this 
fix can go in using the current form for 3.4?

thanks,

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
