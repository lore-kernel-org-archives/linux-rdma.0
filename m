From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 1/1] RDMA/core: Fixes for port mapper client registration
Date: Thu, 16 Oct 2014 18:18:47 -0500
Message-ID: <54405257.3060709@opengridcomputing.com>
References: <20141016161954.GA23268@TENIKOLO-MOBL2> <005101cfe979$edec8890$c9c599b0$@opengridcomputing.com> <13AA599688F47243B14FCFCCC2C803BB0D97D2CF@fmsmsx104.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <13AA599688F47243B14FCFCCC2C803BB0D97D2CF-96pTJSsuoYQ64kNsxIetb7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Roland Dreier' <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Lacombe, John S" <john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/16/2014 5:19 PM, Nikolova, Tatyana E wrote:
> Hello Steve,
>
>>> Doesn't this feature require provider support?  It seems like this patch really doesn't do anything yet.
> It is a fix for the client registration logic. When the user space port mapper is restarted, the IWPM_PREV_REG_CLIENTs send their mapping information to the port mapper, afterwards they are allowed to send remove mapping requests and they should be.
>
> If you look at the remove mapping request logic, you see that only registered clients are allowed to make a remove mapping request.
> In other words, without this fix there are just registered and non-registered clients. IWPM_PREV_REG_CLIENTs are handled like non-registered clients, so their remove mapping requests aren't allowed to go the port mapper, when the rdma application closes the connections in use.
>
> No provider support is necessary.

Thanks for clarifying.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
