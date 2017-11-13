From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core] Documentation: add documentation about stable
 branches
Date: Mon, 13 Nov 2017 12:46:58 -0700
Message-ID: <20171113194658.GA22610@ziepe.ca>
References: <44465a29-bbfc-83ae-8bd4-7d6c11590f2a@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <44465a29-bbfc-83ae-8bd4-7d6c11590f2a-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 13, 2017 at 06:03:39PM +0100, Nicolas Morey-Chaisemartin wrote:
> Add doc file to detail the stable- process: release, submission.

I'm fine with this doc file

> + * It must fix a real bug that bothers people (not a, â€œThis could be a problem...â€? type thing).
                                                         ^^^^^

Can you fix your mailer? It is sending UTF-8 but setting

Content-Type: text/plain; charset=windows-1252

Which results in mangled patches..

https://superuser.com/questions/288571/how-can-i-change-the-default-encoding-type-thunderbird-uses-when-composing-a-new

Maybe please send this patch as a PR to make sure it doesn't get
mangled?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
