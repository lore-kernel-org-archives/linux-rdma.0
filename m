From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 41/47] IB/qib: Suppress gcc 7 fall-through complaints
Date: Tue, 10 Oct 2017 13:56:50 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC3442AA1D@fmsmsx120.amr.corp.intel.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
 <20171006213333.6721-42-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-42-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH 41/47] IB/qib: Suppress gcc 7 fall-through complaints
> 
> Avoid that gcc 7 reports the following warning when building with W=1:
> 
> warning: this statement may fall through [-Wimplicit-fallthrough=]
> 

Bart,

I'm ok with this but...

I'm curious if there is a documentation change in the kernel on a common tree wide approach for gcc 7.

I saw a patch to add the attribute based method of getting rid of the warning, but it doesn't appear to have been merged.

This error probably runs through all of our drivers.

Acked-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
