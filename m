From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: isert for mellanox drivers
Date: Thu, 24 Apr 2014 23:55:08 -0600
Message-ID: <20140425055508.GB23896@obsidianresearch.com>
References: <5DD781F004516D4BBC46D51FA58794102D464FFB@CMEXMB1.ad.emulex.com>
 <5358B396.4060904@mellanox.com>
 <20140424070804.GA20442@infradead.org>
 <5358DF60.9010202@mellanox.com>
 <20140425053825.GB9435@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140425053825.GB9435@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: sagi grimberg <sagig@mellanox.com>, "tony.seo@samsung.com" <tony.seo@samsung.com>, Alex Leung <Alex.Leung@Emulex.Com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 24, 2014 at 10:38:25PM -0700, Christoph Hellwig wrote:
> On Thu, Apr 24, 2014 at 12:54:40PM +0300, sagi grimberg wrote:
> > Well, I feel the same way (although less harsh about it), I would
> > prefer to have it all inbox.
> > As I see it, OFED is useful for costumers who want to upgrade RDMA
> > functionality (or get Tech previews)
> > without upgrading their distro or wait for it to land upstream.
> 
> For that we have the compat drivers project, which could easily handle
> the rdma drivers as well.
> 
> The problem with OFED is (or was last time a looked) that it's a big
> pile that includes backports, and new features not submitted or even
> rejected upstream.

Official OFA OFED is now strictly backports from a given kernel
verison, and TBH, is not widely used now that everything is included
in the modern distros.

The vendor 'OFEDs' remain a big pile. I'm not even sure source is
proved for them.. At least it isn't readily apparent.

IMHO, the vendors should not be co-opting the OFED branding, but that
is a whole other topic....

Jason
