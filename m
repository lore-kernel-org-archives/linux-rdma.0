From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next 2/2] IB/rxe: Cache dst in QP instead of getting it for each send
Date: Thu, 20 Apr 2017 14:28:59 -0500
Message-ID: <062f01d2ba0c$5c25ca00$14715e00$@opengridcomputing.com>
References: <20170420175556.8573-1-leon@kernel.org> <20170420175556.8573-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170420175556.8573-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'yonatanc' <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> From: yonatanc <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> In RC QP there is no need to resolve the outgoing interface
> for each packet, as this does not change during QP life cycle.
> 

It could change, right?  As the result of an ICMP routing redirect, for
example...





--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
