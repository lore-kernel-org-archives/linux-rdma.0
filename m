From: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 1/2] IB/core: Add support for enhanced atomic operations
Date: Sun, 28 Feb 2010 13:09:29 -0800
Message-ID: <4B8ADB89.3010700@oracle.com>
References: <20100214135128.GA7607@vlad-laptop> <adaljegx4vz.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaljegx4vz.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
> I think I'd be OK adding this for 2.6.34, if there were some case made
> that this would be useful for someone working on code that used this.
> So what case can be made for adding this to 2.6.34 without an in-tree user?

Support needs to be there before anyone can use it :)

Here is a git tree of our atomics work so far:
http://www.openfabrics.org/git/?p=~agrover/ofed_1_5/linux-2.6.git;a=shortlog;h=future/20100203

Still in-development, but it should be ready very soon. We will be the
first in-kernel user of atomics, as well as masked atomics. This tree
does not support masked atomics yet because it is based on ofed 1.5.1.
When 1.5.2 is officially released, I'll rebase, add mask support, and
plan on pushing to mainline and ofed 1.6 as soon as it opens.

Regards -- Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
