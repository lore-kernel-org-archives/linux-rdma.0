From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH libibverbs v2 08/11] read_config(): refuse to open
 IBV_CONFIG_DIR if it's not a directory
Date: Mon, 12 Aug 2013 13:29:43 -0600
Message-ID: <20130812192943.GD7968@obsidianresearch.com>
References: <cover.1375952089.git.ydroneaud@opteya.com>
 <64fd9c35244a9d3ed56f77b049accb00b9ec95e9.1375952089.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <64fd9c35244a9d3ed56f77b049accb00b9ec95e9.1375952089.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 08, 2013 at 09:40:51PM +0200, Yann Droneaud wrote:
> @@ -325,7 +325,7 @@ static void read_config(void)
>  	struct dirent *dent;
>  	struct stat buf;
>  
> -	conf_dirfd = open(IBV_CONFIG_DIR, O_RDONLY | O_CLOEXEC);
> +	conf_dirfd = open(IBV_CONFIG_DIR, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
>  	if (conf_dirfd == -1) {
>  		fprintf(stderr, PFX "Warning: couldn't open config directory '%s'.\n",
>  			IBV_CONFIG_DIR);

It is much better to keep the original opendir code and then use dirfd
to get the directory file no for later use with fstat/openat/etc.

glibc already knows to use non-portable things like O_DIRECTORY and
O_CLOEXEC inside opendir.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
