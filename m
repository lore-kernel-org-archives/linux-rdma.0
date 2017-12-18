From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Support for generalized use of make C={1,2} via
 a wrapper program
Date: Mon, 18 Dec 2017 14:41:23 +0100
Message-ID: <1513604483.22938.65.camel@oracle.com>
References: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
         <20171216094745.5e41ac51@xeon-e3> <1513476850.31439.108.camel@oracle.com>
         <20171218050043.GA1307@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171218050043.GA1307-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mauro Carvalho Chehab <mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Nicolas Palix <nicolas.palix-wMUr/XMoy4A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cocci-/FJkirnvOdkvYVN+rsErww@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Marek <michal.lkml-yyZNWGI4GtDR7s880joybQ@public.gmane.org>, Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>, John Haxby <john.haxby-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, =?ISO-8859-1?Q?=C5smund_=D8stvold?= <asmund.ostvold-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Ke
List-Id: linux-rdma@vger.kernel.org

On Sun, 2017-12-17 at 22:00 -0700, Jason Gunthorpe wrote:
> On Sun, Dec 17, 2017 at 03:14:10AM +0100, Knut Omang wrote:
> 
> > > I like the ability to add more checkers and keep then in the main
> > > upstream tree. But adding overrides for specific subsystems goes against
> > > the policy that all subsystems should be treated equally.
> > 
> > This is a tool to enable automated testing for as many checks as
> > possible, as soon as possible. Like any tool, it can be misused, but
> > that's IMHO an orthogonal problem that I think the maintainers will
> > be more than capable of preventing.
> > 
> > Think of this as a tightening screw: We eliminate errors class by
> > class or file by file, and in the same commit narrows in the list of
> > exceptions. That way we can fix issues piece by piece while avoiding
> > a lot of regressions in already clean parts.
> 
> Since you used drivers/infiniband as an example for this script..
> 
> I will say I agree with this idea.

> It is not that we *want* infiniband to be different from the rest of
> the kernel, it is that we have this historical situation where we
> don't have a code base that already passes the various static checker
> things.

I poked around trying make M= in different parts of the kernel to get some 
"mileage" and to get as much examples as possible, and it appears most of 
the kernel has issues of sorts. Also Joe and others keep adding more checks 
as well, and we'd want that process to coexist with the need for automatic 
regression testing in this area.

> I would like it very much if I could run 'make static checker' and see
> no warnings. 

which is just what is the result with 'make C=2 M=drivers/infiniband/core' 
and the patches #1 and #5 in this set in case not everyone got the point,

> This helps me know that I when I accept patches I am not
> introducing new problems to code that has already been cleaned up.
> 
> Today when we run checkers we get so many warnings it is too hard to
> make any sense of it.
> 
> Being able to say File X is now clean for check XYZ seems very useful
> and may motivate people to clean up the files they actualy care
> about...
> 
> > > There was discussion at Kernel Summit about how the different
> > > subsystems already have different rules. This appears to be a way
> > > to make that worse.
> > 
> > IMHO this is a tool that should help maintainers implement the
> > policies they desire.  But the tool itself does not dictate any
> > such.
> 
> Yes, again, in infiniband we like to see checkpatch be good for new
> submission, even if that clashes with surrounding code. For instance
> we have a mixture of sizeof foo and sizeof(foo) styles in the same
> file/function now.

That's one of the fixes that the excellent --fix-inplace handles so 
one of my patches here

https://github.com/torvalds/linux/compare/master...knuto:runchecks

fixes those in drivers/infiniband/core.

> I certainly don't want to tell people they need to follow some
> different style from 10 years ago when they send patches.
> 

Thanks,
Knut

> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
