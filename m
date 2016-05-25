From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC] rdma/uverbs: Sketch for an ioctl framework
Date: Wed, 25 May 2016 22:24:19 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB050A85@ORSMSX109.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB04FB7F@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB141819B27F9AAA360DCB420FB14F0@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <11b6d9c1-0b20-f929-c896-ca084fe18192@redhat.com>
 <20160524214137.GA6760@obsidianresearch.com> <5745E9AE.6020700@redhat.com>
 <20160525190039.GA5525@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB050907@ORSMSX109.amr.corp.intel.com>
 <20160525205156.GB5525@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB050A07@ORSMSX109.amr.corp.intel.com>
 <20160525221340.GB6207@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160525221340.GB6207-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Are you hearing people object to number of fds? I've never thought of
> it as such a big deal, epoll makes it very painless to deal with.. Do
> people have scaling issues?

This was an item brought up in the ofiwg requirement gathering phase.  Epoll is nice, and it's what libfabric uses internally to hide multiple fd's, but there are still more resources involved, plus additional overhead processing the events.  Exascale is one big scaling issue, and large core count systems exacerbate the problems.

- Sean 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
