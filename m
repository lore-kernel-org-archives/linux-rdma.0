From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [rdma-next v1 REPOST 10/10] Documentation: Hardware tag matching
Date: Mon, 21 Aug 2017 10:04:37 -0600
Message-ID: <20170821160437.GD4401@obsidianresearch.com>
References: <20170817125212.3173-1-leon@kernel.org>
 <20170817125212.3173-11-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170817125212.3173-11-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 17, 2017 at 03:52:12PM +0300, Leon Romanovsky wrote:
> From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Add document providing definitions of terms and core explanations
> for tag matching (TM) protocols, eager and rendezvous,
> TM application header, tag list manipulations and matching process.

When adding a new common verbs it needs to be documented to a level
where someone else can implement it.

At least describe the new header format and how the matching process
must work..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
