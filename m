From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH/libmlx4] Fix generation of IBV_WC_GRH
Date: Tue, 8 Mar 2011 11:32:36 -0700
Message-ID: <20110308183236.GI22729@obsidianresearch.com>
References: <20110305024546.GA29147@obsidianresearch.com>
 <AANLkTimu6dGc1NcsgP60iPqNmzGR+cmtwGHjsU_c=LWz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimu6dGc1NcsgP60iPqNmzGR+cmtwGHjsU_c=LWz-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 08, 2011 at 10:04:11AM -0800, Roland Dreier wrote:
> On Fri, Mar 4, 2011 at 6:45 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > Byte swap was erroneously using short not long, so the test always
> > returns false as 0x80000000 is greater than 16 bits.
> 
> This was fixed in libmlx4 1.0.1 a while ago.  I guess I really need
> to get that version into Debian/Ubuntu.

Hurm. OFED needs to pick up 1.0.1.. I've been using your 1.0 with an
upstream kernel because that is what OFED has labeled their
1.5.1/1.5.2 versions of libmlx4. Looks like it is actually 1.0.1
anyhow. Sigh.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
