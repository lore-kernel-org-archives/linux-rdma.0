From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: Remove Red Hat-ism.
Date: Wed, 13 Feb 2013 14:11:13 -0800
Message-ID: <20130213141113.e73d309c172c14591b997a13@llnl.gov>
References: <1354566498-8364-1-git-send-email-jonstanley@gmail.com>
	<20121203223547.GA3410@obsidianresearch.com>
	<CALY6xnj_OYpQFiCSC4T3cY3yup6ZXXJR=QDDCaJN96gEyvFP5w@mail.gmail.com>
	<CAGH67wTvYvvgzYGggab4XDyHtT-3M3KFoojth64kLyJDeCk8=w@mail.gmail.com>
	<20121204181131.GC21196@obsidianresearch.com>
	<CAGH67wQrOFpEK4PWK858tuf3yVEzr4D9kWoPuLJCte8wocpAkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGH67wQrOFpEK4PWK858tuf3yVEzr4D9kWoPuLJCte8wocpAkw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jon Stanley <jonstanley-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 4 Dec 2012 11:48:18 -0800
Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Dec 4, 2012 at 10:11 AM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > On Tue, Dec 04, 2012 at 08:31:19AM -0800, Garrett Cooper wrote:
> >
> >> Calling ``newname=$(hostname)`` would be better (assuming that the
> >> network was setup enough where one could get this information).
> >
> > Calling hostname is always preferred to mucking about with files in
> > /etc/. hostname never requires the network, hostname -f might
> > sometimes.
> 
> Yes, but OSes don't set the hostname until a little later on in the
> boot process (FreeBSD for instance), depending upon how the system was
> first booted and the host's network configuration (DHCP*/SLAAC/etc).
> That's more of what I was driving at when I said "assuming that the
> network was setup enough where one could get this information".

set_nodedesc.sh was deprecated and moved to a compat build a while ago.

As such I think the best thing to do is use hostname as Jason says and call it good.  I believe that users attempting to set the NodeDescription within boot scripts can do so with the sysfs files.

Jon I would accept a patch if you would like to redo this one but I am going to reject the patch as it stands.

Thanks,
Ira

> 
> Thanks,
> -Garrett
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
