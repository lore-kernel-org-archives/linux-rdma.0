From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/7] Add mlx5 direct verbs
Date: Thu, 26 Jan 2017 15:02:49 -0700
Message-ID: <20170126220249.GA18626@obsidianresearch.com>
References: <1485446182-5109-1-git-send-email-yishaih@mellanox.com>
 <20170126172511.GB16562@obsidianresearch.com>
 <ac21fe37-d617-e5a8-cd67-e8fdfbd69d55@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ac21fe37-d617-e5a8-cd67-e8fdfbd69d55-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 26, 2017 at 11:54:53PM +0200, Yishai Hadas wrote:

> Correct, the link will be explicitly by the application at compile time so
> that the exported symbols will be resolved.

Okay, then you just need to make that possible.

> >Somehow libmlx needs to be in the standard ld.so search path, and
> >available for linking via gcc, as well as continuing to be a plugin..
> >The best choice might be to put it in /usr/lib/../libmlx5.so.1 and
> >symlink that file to /usr/lib/../libibverbs/libmlx5-rdmav2.so
> 
> You are pointing on same usage as done for libibverbs which has the symlink,
> correct ?


libibverbs has a symlink for a different purpose.

> Alternatively, application can use the linker flags as part of its
> Makefile to find the shared library location, isn't it ?

No, that would require applications to hardwire
/usr/lib/.../libibverbs/libmlx5-rdmav2.so as a path. Do not want that.

Make it so

gcc -libverbs_dv_mlx5 foo.c

Is all that is required.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
