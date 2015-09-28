From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: libmlx4 and libmlx5 git trees? Who is handling those?
Date: Mon, 28 Sep 2015 20:33:50 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A904D40B@ORSMSX109.amr.corp.intel.com>
References: <alpine.DEB.2.20.1509281036520.30603@east.gentwo.org>
 <56096033.8040000@redhat.com> <20150928171724.GF12415@obsidianresearch.com>
 <alpine.DEB.2.20.1509281220580.31260@east.gentwo.org>
 <9C6B67F36DCAFC479B1CF6A967258A8C7D250932@ORSMSX110.amr.corp.intel.com>
 <20150928173208.GA8083@infradead.org>
 <20150928174215.GB1623@obsidianresearch.com>
 <9C6B67F36DCAFC479B1CF6A967258A8C7D25098A@ORSMSX110.amr.corp.intel.com>
 <20150928190024.GB8358@obsidianresearch.com> <5609A19A.806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5609A19A.806-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Anyway, I had intended, and I've started on, making a change in how
> libibverbs is done anyway.  The idea that a new release is just a scr=
ipt
> that throws a version on and we go is naive.  I *will* be doing
> pre-release rc tarballs and there will be testing and there will be a
> release process that helps to make sure we don't see things like what=
 we
> saw with librdmacm (sorry to pick on you Sean): 1.0.17/1.0.17.1,
> 1.0.18/1.0.18.1, and 1.0.19/1.0.19.1.

I don=92t feel picked on.  :)

The issue is that basically no one tests the releases of the packages. =
 They only test the OFED bundle, and OFED doesn't want to pick up anyth=
ing that's not already a release.=20
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
