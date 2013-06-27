From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 for-next 1/4] IB/core: Add receive Flow Steering support
Date: Fri, 28 Jun 2013 01:05:09 +0300
Message-ID: <CAJZOPZKBJqn0dNRha7zaS7eLnDhR7j4NVvKxgH5CiJrJD8HnfA@mail.gmail.com>
References: <1372251464-13394-1-git-send-email-ogerlitz@mellanox.com>
	<1372251464-13394-2-git-send-email-ogerlitz@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A823736FD36FF3@ORSMSX109.amr.corp.intel.com>
	<CAJZOPZK_FkCJZxjyxEdk4WOTvbo8DQpcpqmuPUsqV=bZmU5W_w@mail.gmail.com>
	<51CB5E47.7090404@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51CB5E47.7090404-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 27, 2013 at 12:33 AM, Steve Wise
<swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> On 6/26/2013 4:13 PM, Or Gerlitz wrote:
>> On Wed, Jun 26, 2013 at 10:56 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

>>>> Steering rules processing order is according to rules priority. The user
>>>> sets the 12 low-order bits from the priority field and the remaining
>>>> 4 high-order bits are set by the kernel according to a domain the
>>>> application or the layer that created the rule belongs to. Lower
>>>> priority numerical value means higher priority.

>>> Why are bit fields being exposed to the user in this way?

>> Yes, this is probably not general enough. So what would you suggest,
>> use a more integral division? e.g 16 bits for priority and 16 bits for location?

> If the kernel driver is setting the "location", whatever that is, why would
> the application need access to it?  IE isn't a priority field enough to
> allow the application provide an ordering/prioritization to the rules?

I wasn't accurate, the idea is that per domain we allow the app to set
the rule priority, but the actual priority towards the HW is made of
the provided prioriry X domain, where different domains have different
priorities along the order set by the verbs header file see enum
ib_flow_domain
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
