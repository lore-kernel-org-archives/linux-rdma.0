From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] cbuild: use rpmspec for macro replacement
Date: Wed, 9 Aug 2017 15:15:36 -0600
Message-ID: <20170809211536.GA10191@obsidianresearch.com>
References: <27366048-d80f-3711-c6cd-93c87809650e@suse.de>
 <8ad0438f-b4a5-aec9-1e44-a9c9dc1ca17b@suse.de>
 <20170808230459.GF29372@obsidianresearch.com>
 <b3993b0c-0b9d-a917-cbf8-22f68c1d2a97@suse.de>
 <20170809155532.GC15586@obsidianresearch.com>
 <f42a6eaa-79f9-1063-b58a-08da363d09e7@suse.de>
 <20170809201932.GA7363@obsidianresearch.com>
 <5c4de783-ce62-2b8d-78aa-ee2f181fe719@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5c4de783-ce62-2b8d-78aa-ee2f181fe719-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 09, 2017 at 11:08:34PM +0200, Nicolas Morey-Chaisemartin wrote:

> > And drop a symlink to fix it up.

> Yes this should work. It feels a little bit dirty to have a tarball
> name with unreplaced macro but it's a temporay state so I can live
> with this :)

It is a bit strange, but this trivially delegates parsing the .tar.xx
to git archive which understands all the formats..

Here is the patches, should I send them?

https://github.com/jgunthorpe/rdma-plumbing/tree/cbuild

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
