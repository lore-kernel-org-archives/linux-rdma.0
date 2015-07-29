From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH WIP 38/43] iser-target: Port to new memory registration
 API
Date: Tue, 28 Jul 2015 23:32:13 -0700
Message-ID: <20150729063213.GA10465@infradead.org>
References: <55B0C18B.4080901@dev.mellanox.co.il>
 <20150723163124.GD25174@obsidianresearch.com>
 <55B11D84.102@dev.mellanox.co.il>
 <20150723185334.GB31346@obsidianresearch.com>
 <DE0226A1-A7FC-4618-91F1-FE34347C252A@oracle.com>
 <20150724162657.GA21473@obsidianresearch.com>
 <903CDFB5-04FE-47B6-B044-E960E8A8BC4C@oracle.com>
 <8A2BC019-1DC0-4531-9659-3181EE9A4B43@oracle.com>
 <20150727172510.GD18348@obsidianresearch.com>
 <B045BAC2-0360-4D97-A220-7DB52AF90BF7@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <B045BAC2-0360-4D97-A220-7DB52AF90BF7-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 28, 2015 at 04:06:23PM -0400, Chuck Lever wrote:
> My opinion is FMR should be separate from the new API. Some have
> expressed an interest in combining all kernel registration
> mechanisms under a single API, but they seem too different from
> each other to do that successfully.

Hi Chuck,

I think we can fit FMR partially under this API, e.g. alloc and map_sg
fit in very well, but then instead of post and invalidate we'll need to
call into slightly modified existing FMR pool APIs.

I'd suggest to postponed the issue for now, I'll prepare a prototype
once we've finished the FR-side API.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
