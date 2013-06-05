From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] libibverbs: A possible solution for allowing arbitrary
 MTU values.
Date: Wed, 5 Jun 2013 10:46:39 -0600
Message-ID: <20130605164639.GA30184@obsidianresearch.com>
References: <1370437223-14171-1-git-send-email-jsquyres@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1370437223-14171-1-git-send-email-jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 05, 2013 at 06:00:23AM -0700, Jeff Squyres wrote:
> Set the IBV_MTU_* enums equal to their values (e.g., IBV_MTU_1024 =
> 1024), and then pass MTU values around as int's.  Legacy applications
> will use the enum values, but newer applications can use any int for
> values that do not currently exist in the enum set (e.g., 1500, 9000).
> 
> The obvious drawback is that this will break ABI; applications will
> need to be recompiled.

No, this too big of an ABI break, and silent at that..

The IBA values have to continue to be accepted and exported in all
cases so the ABI stays the same, which is what I thought was agreed
on??

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
