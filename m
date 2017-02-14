From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 7/7] mlx5: Export mlx5 direct verbs interface
Date: Tue, 14 Feb 2017 11:05:49 -0700
Message-ID: <20170214180549.GB3060@obsidianresearch.com>
References: <1486909012-15064-1-git-send-email-yishaih@mellanox.com>
 <1486909012-15064-8-git-send-email-yishaih@mellanox.com>
 <20170213164944.GB25430@obsidianresearch.com>
 <20170213182121.GD6989@mtr-leonro.local>
 <20170213184250.GA12224@obsidianresearch.com>
 <20170214055219.GE6989@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170214055219.GE6989-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 14, 2017 at 07:52:19AM +0200, Leon Romanovsky wrote:

> Sorry, but I'm still missing how mlx5 installation will be handled.
> 
> The ibverbs-provider installs different *-rdmav2.so files and it should
> install libmlx5-rdmav2.so among them.

No, the symlink from -rdmav2.so needs to go to a real file not another
symlink.

> If we move libmlx5.so to libibverbs-dev, how will symlink be
> created?

libmlx5.so is the 'devel' symlink, it is only used by the compiler
during linking which is why it must be placed in the -dev package.

> What will user see after installing libibverbs + ibverbs-provider?

libmlx5-rdmav2.so should be ../libmlx5.so.1.0.13

> And what will be in case of libibverbs-dev + ibverbs-provider?

Then you get libmlx5.so -> libmlx5.so.1.0.13 and the man pages and
header files. libibverbs-dev will need to depend on the
ibverbs-provider package also.

This is all also true for RPM systems.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
