From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 407/493] infiniband: remove use of __devexit
Date: Mon, 19 Nov 2012 16:17:24 -0700
Message-ID: <20121119231724.GA27526@obsidianresearch.com>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
 <1353349642-3677-407-git-send-email-wfp5p@virginia.edu>
 <20121119200921.GD1556@obsidianresearch.com>
 <20121119201938.GA5614@kroah.com>
 <20121119214922.GA5636@obsidianresearch.com>
 <20121119220632.GA1946@kroah.com>
 <20121119224845.GB5636@obsidianresearch.com>
 <20121119230006.GA2523@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121119230006.GA2523-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Bill Pemberton <wfp5p-4Ng6DfrEGID2fBVCVOL8/A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 19, 2012 at 03:00:06PM -0800, Greg KH wrote:

> I could just leave things alone, with CONFIG_HOTPLUG always enabled, but
> then people will continue to blindly use the __dev* markings, getting it
> wrong at times, but never realizing that they don't do anything anymore.

Well, I was thinking more along the lines of leaving the capability to
remove the __dev* marked functions from the link, as is today,
independent of the other stuff CONFIG_HOTPLUG controls. But reviewing
your comments from the archive makes me think a motivation is misuse
of the __dev* markings..

Thanks for the insight,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
