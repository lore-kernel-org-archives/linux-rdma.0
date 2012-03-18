From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: races in ipathfs
Date: Sun, 18 Mar 2012 22:40:07 +0000
Message-ID: <20120318224007.GF6589@ZenIV.linux.org.uk>
References: <20120119202003.GZ23916@ZenIV.linux.org.uk>
 <20120318184547.GA6814@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120318184547.GA6814-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Mar 18, 2012 at 06:45:47PM +0000, Al Viro wrote:
> On Thu, Jan 19, 2012 at 08:20:04PM +0000, Al Viro wrote:
> > 	Use of qib_super is seriously racy.  qibfs_add() (and worse,
> > qibfs_remove()) can happen during qibfs_mount() and qibfs_kill_super().
> 
> [snip]
> 
> FWIW, I've put a completely untested patchset into
> git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git qibfs

Corresponding fix for ipathfs added to the same branch; again, completely
untested.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
