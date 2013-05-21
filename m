From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/3] read_config: skip file/directory with unsecure
 permissions
Date: Tue, 21 May 2013 14:57:13 -0600
Message-ID: <20130521205713.GB11318@obsidianresearch.com>
References: <cover.1369085762.git.ydroneaud@opteya.com>
 <0a6888edc9d7899fe3b4af249c4f25088e196422.1369085762.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0a6888edc9d7899fe3b4af249c4f25088e196422.1369085762.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, May 20, 2013 at 11:43:05PM +0200, Yann Droneaud wrote:
> libibverbs must refuse to load arbitrary shared objects.
> 
> This patch check the configuration directory and files for
> - being owned by root;
> - not being writable by others.

I really don't like this. Is there some exploit against /etc/ now that
requires this sort of checking?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
