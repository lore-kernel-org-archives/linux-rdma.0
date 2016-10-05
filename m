From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: RDMA developer gatherings around Kernel Summit and Linux
 Plumbers in Santa Fe
Date: Wed, 5 Oct 2016 12:31:56 -0600
Message-ID: <20161005183156.GH18636@obsidianresearch.com>
References: <alpine.DEB.2.20.1610040344500.11122@east.gentwo.org>
 <20161004124513.GA12483@infradead.org>
 <7BAAE610-98A0-47FC-993B-77401AA32F4A@ornl.gov>
 <alpine.DEB.2.20.1610050242260.27600@east.gentwo.org>
 <20161005083218.GA16922@infradead.org>
 <BED3F60E-08E7-4C29-8A52-E7F879BE46A4@ornl.gov>
 <20161005131811.GA24546@infradead.org>
 <96C6AF13-B968-41C2-9AB3-CAB5F91D72A1@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <96C6AF13-B968-41C2-9AB3-CAB5F91D72A1-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Atchley, Scott" <atchleyes-1Heg1YXhbW8@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Coulter, Susan K" <skc-YOWKrPYUwWM@public.gmane.org>, "shewa-YOWKrPYUwWM@public.gmane.org" <shewa-YOWKrPYUwWM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 05, 2016 at 01:49:56PM +0000, Atchley, Scott wrote:

> I am trying to understand the issue from both points of view. Again,
> I ask you to help me understand how requesting dual-licensing hurts
> the adoption of RDMA technology. I can understand the vendor???s
> concerns about having to write software twice for GPL and non-GPL
> environments.

The opposing point of view is that every time an opensource project is
forked or taken propriety by a company the opensource project itself
suffers. (and this is by no means a universal view, but let us
explore it)

A good example of this harm in our community would be opensm. Many
sites are now running a build of 'opensm' that does not come with
source.

>From the OFA perspective, many of the companies using the code outside
Linux are not OFA members, do not contribute financially, and do not
contribute their bugfixes or other code. Yet, they get a 'free ride'
when the OFA encourages Linux-focused member companies to use the dual
license.

I can understand why the OFA adopted this position at the start, but
IMHO, it is time to stop. The OFA should not be spending its limited
resources to benefit the non-Linux community.

Further, it is hard to see why the OFA board should burn what little
good will it has in the Linux community by acting to the benifit of a
nebulous sub-group of non-Linux members (that may not even exist today).

In the end I hope the bylaws will be revised to allow for
GPLv2/LGPLv2-only as a legtimiate license choice for OFA projects.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
