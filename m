From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: rdma-core build environment enabling out-of-core providers
Date: Fri, 4 Aug 2017 08:14:38 -0500
Message-ID: <000301d30d23$a03bdad0$e0b39070$@opengridcomputing.com>
References: <007601d30b96$f2408170$d6c18450$@opengridcomputing.com> <20170802160900.GB21208@obsidianresearch.com> <019001d30bc3$cc6648e0$6532daa0$@opengridcomputing.com> <44b511c6-45fa-d5aa-4d4c-e47d2edcf604@suse.de> <008401d30c5f$3c9e2560$b5da7020$@opengridcomputing.com> <20170803144733.GA13127@obsidianresearch.com> <890f961c-7aa8-1a73-e98d-f7ce9da333d7@suse.de> <20170803170713.GD13127@obsidianresearch.com> <7cc0ba31-7a05-4db1-5807-4d971fc3d773@suse.de> <011f01d30d15$1fa92750$5efb75f0$@opengridcomputing.com> <188beb70-9776-33fc-6f72-cc00e968db73@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <188beb70-9776-33fc-6f72-cc00e968db73-l3A5Bk7waGM@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Nicolas Morey-Chaisemartin' <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> >> It shouldn't be too hard to automatically extract one of the in-tree provider
> >> and try to compile it as an out-of-tree.
> >> And this way it's always up-to-date for testing.
> >>
> > That's a good idea.  We could also have a simple "noop" type provider that at
> least registers with the core but never claims any devices.  This would at least verify
> the build/install, and provider-load by libibverbs.
> >
> > Steve.
> >
> 
> noop is good for testing. A true provider would make sure we haven't missed any
> headers.

Agreed.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
