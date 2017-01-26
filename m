From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/7] Add mlx5 direct verbs
Date: Thu, 26 Jan 2017 10:25:11 -0700
Message-ID: <20170126172511.GB16562@obsidianresearch.com>
References: <1485446182-5109-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485446182-5109-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 26, 2017 at 05:56:15PM +0200, Yishai Hadas wrote:
> This patchset from Leon adds direct access to mlx5 devices.
> 
> The libibverbs API is an abstract API. It is agnostic to any underlying
> provider specific implementation. While this abstraction has the advantage of
> user applications portability it has a performance penalty. For some
> applications optimizing performance is more important than portability.
>
> The mlx5 direct verbs API introduced in this patchset is intended for such
> applications. It exposes mlx5 specific low level data path
> (send/receive/completion) operations, allowing the application to bypass the
> libibverbs data path API.

Applications need to link directly to the libraries that provide the
symbols they use - this approach you have where linking happens
implicitly at runtime is not OK.

Somehow libmlx needs to be in the standard ld.so search path, and
available for linking via gcc, as well as continuing to be a plugin..

The best choice might be to put it in /usr/lib/../libmlx5.so.1 and
symlink that file to /usr/lib/../libibverbs/libmlx5-rdmav2.so

This series also needs patches to the included packaging files to
bundle the new files. (buildlib/cbuild exists for a reason, be sure to
test the packaging)

These probably need a man page as well. It wasn't instantly obvious to
me how these were supposed to work.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
