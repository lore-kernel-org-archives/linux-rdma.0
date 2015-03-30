From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1 00/10] Add network namespace support in the RDMA-CM
Date: Mon, 30 Mar 2015 19:21:18 +0300
Message-ID: <CAJ3xEMg5h+4DZUCGWY-z+QQxE4Vm6KQ3_+gHgG7GtQ-DOy7jyA@mail.gmail.com>
References: <1423667204-8807-1-git-send-email-raindel@mellanox.com>
	<54E363E7.5090507@mellanox.com>
	<550AD952.7060900@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <550AD952.7060900-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 19, 2015 at 5:12 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 2/17/2015 5:53 PM, Or Gerlitz wrote:
>> On 02/11/2015 05:06 PM, Shachar Raindel wrote:

>>> This patchset allows using network namespaces with the RDMA-CM.
>>> Each RDMA-CM and CM id is keeping a reference to a network namespace.
>> [...]

>> Hi Sean,
>> Did you had the chance to look on the patches that do the changes to the
>> cm and cma code?

> Sean, ping... you are the maintainer of the rdma-cm, these patches are here
> for many weeks,  can you please take a look and provide your feedback.

Sean, PING.  Busy as you may be, the upstream cm && rdma-cm maintainer
hat is sitting solid on your head, and makes no sense for people doing
development to submit patches touching these layers and get no
feedback from you over months, so?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
