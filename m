From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Support for generalized use of make C={1,2} via a
 wrapper program
Date: Mon, 18 Dec 2017 10:46:04 -0700
Message-ID: <20171218174604.GA19056@ziepe.ca>
References: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
 <20171216094745.5e41ac51@xeon-e3>
 <1513476850.31439.108.camel@oracle.com>
 <20171218050043.GA1307@ziepe.ca>
 <1513576817.31581.58.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1513576817.31581.58.camel-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mauro Carvalho Chehab <mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nicolas Palix <nicolas.palix-wMUr/XMoy4A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cocci-/FJkirnvOdkvYVN+rsErww@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Marek <michal.lkml-yyZNWGI4GtDR7s880joybQ@public.gmane.org>, Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>, John Haxby <john.haxby-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, =?utf-8?Q?=C3=85smund_=C3=98stvold?= <asmund.ostvold-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Masahiro
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 17, 2017 at 10:00:17PM -0800, Joe Perches wrote:

> > Today when we run checkers we get so many warnings it is too hard to
> > make any sense of it.
> 
> Here is a list of the checkpatch messages for drivers/infiniband
> sorted by type.
> 
> Many of these might be corrected by using
> 
> $ ./scripts/checkpatch.pl -f --fix-inplace --types=<TYPE> \
>   $(git ls-files drivers/infiniband/)

How many of these do you think it is worth to fix?

We do get a steady trickle of changes in this topic every cycle.

Is it better to just do a big number of them all at once? Do you have
an idea how disruptive this kind of work is to the whole patch flow
eg new patches no longer applying to for-next, backports no longer
applying, merge conflicts?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
