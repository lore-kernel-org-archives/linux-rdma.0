From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: libmlx4 and libmlx5 git trees? Who is handling those?
Date: Mon, 28 Sep 2015 20:50:41 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A904D43C@ORSMSX109.amr.corp.intel.com>
References: <alpine.DEB.2.20.1509281036520.30603@east.gentwo.org>
 <56096033.8040000@redhat.com> <20150928171724.GF12415@obsidianresearch.com>
 <alpine.DEB.2.20.1509281220580.31260@east.gentwo.org>
 <9C6B67F36DCAFC479B1CF6A967258A8C7D250932@ORSMSX110.amr.corp.intel.com>
 <20150928173208.GA8083@infradead.org>
 <20150928174215.GB1623@obsidianresearch.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7D25098A@ORSMSX110.amr.corp.intel.com>
 <20150928190024.GB8358@obsidianresearch.com> <5609A19A.806@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373A904D40B@ORSMSX109.amr.corp.intel.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7D250AFC@ORSMSX110.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9C6B67F36DCAFC479B1CF6A967258A8C7D250AFC-8oqHQFITsIHTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >The issue is that basically no one tests the releases of the packages.
> 
> We assume that the maintainer of the package tests it before they release
> it :)

No one has access to that many pieces of hardware and system configurations.  The "community" can't dump the responsibility for testing onto a single person.

OFA has always had the problem of testing long after the fact -- months, if not years, after changes are merged upstream (kernel or user space).

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
