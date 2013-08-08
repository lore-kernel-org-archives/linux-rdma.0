From: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/8] Critical bug fixes for RDMA/cxgb4
Date: Thu, 08 Aug 2013 14:01:06 +0530
Message-ID: <5203574A.5090603@chelsio.com>
References: <1375803280-7916-1-git-send-email-vipul@chelsio.com> <CAJZOPZJnxOGbRmWJiajkaDGFVhVT6NVCLq96KA72eyY=ny8AKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJnxOGbRmWJiajkaDGFVhVT6NVCLq96KA72eyY=ny8AKQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Divy Le Ray <divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Nirranjan Kirubaharan <nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 07-08-2013 01:45, Or Gerlitz wrote:
> On Tue, Aug 6, 2013 at 6:34 PM, Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org> wrote:
> 
> [...]
> 
>> The patch-series is based on Roland's infiniband tree for-next branch.
>> This series is on top of previously submitted series "Add IPv6 support for iWARP"
>> We request Roland to merge above series first and then apply this series on top of it.
> 
> [...]
> 
>> This patch series fixes critical bugs for RDMA/cxgb4. It fixes bugs in QP flush
>> path, handles newer firmware changes, deals with wrap around issue of the queue,
>> sets arp error handler etc.
> 
> Hey Vipul, its unclear if this series has fixes to bugs introduced in
> the iwarp/ipv6 series, or unrelated fixes which are just rebased on
> the other series. But this way or another, in this form it  can't work
> for the current cycle, since the iwarp/ipv6 series suits merge window
> and can't be accepted just to let few other fixes to get it. What you
> can do is wait for the iwarp/ipv6 + this series to get into 3.12-rc
> and then backport (adjust) the fixes which are really critical to 3.11
> and get them into 3.11.y (and to 3.x.y for x < 11 as well if you want
> that) through the -stable process. I think Divy/Steve should be
> familiar with all this stuff, isn't that? but anyway, just for the
> sake of you and others learning something from this little 101
> 
> Or.
> 

Thanks Or Gerlitz for the insights. This series has unrelated fixes
which are just based on IPv6 series. As you have suggested we would like
to wait for iwarp/ipv6 and this series to get merge in 3.12-rc.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
