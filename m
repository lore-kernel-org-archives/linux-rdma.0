From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 7/7] mlx5: Export mlx5 direct verbs interface
Date: Thu, 26 Jan 2017 10:30:05 -0700
Message-ID: <20170126173005.GD16562@obsidianresearch.com>
References: <1485446182-5109-1-git-send-email-yishaih@mellanox.com>
 <1485446182-5109-8-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485446182-5109-8-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 26, 2017 at 05:56:22PM +0200, Yishai Hadas wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Install direct verbs related files into
> /usr/include/infiniband/mlx5 folder and allow
> for possible users to explicitly include them
> into their applications.
> 
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Acked-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  buildlib/provider.map                 | 13 +++++++++----
>  providers/mlx5/include/CMakeLists.txt |  6 +++++-
>  2 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/buildlib/provider.map b/buildlib/provider.map
> index e985a6f..8c7875f 100644
> +++ b/buildlib/provider.map
> @@ -1,6 +1,11 @@
> -/* The providers do not export any symbols at all. Instead they rely on
> -   attribute(constructor) to cause their init function to run at dlopen
> -   time. */
> -{
> +/* The providers usually do not export any symbols at all. Instead
> +   they rely on attribute(constructor) to cause their init function to
> +   run at dlopen time.
> +   Providers that wish to export symbols should add them below according to
> +   Documentation/versioning.md document. */
> +MLX5_1.0 {
> +	global:
> +		mlx5dv_query_device;
> +		mlx5dv_init_obj;
>  	local: *;

No, this is no longer just a provider so it doesn't get to use
provider.map

mlx5 will need its own map file and the various magic I described to
become a proper library and a plugin at once.

> +publish_headers(infiniband/mlx5
> +	dv.h
> +	dv-wqe.h
> +	dv-cqe.h
> +)

not ever dir needs a cmakefile, this is fine in the providers/mlx5
even with the include/ dir. It is easier to understand if things are
not spread out so much.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
