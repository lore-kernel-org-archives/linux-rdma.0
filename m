From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core] cbuild: Add Fedora 27 container
Date: Fri, 12 Jan 2018 11:08:55 -0700
Message-ID: <20180112180855.GF15974@ziepe.ca>
References: <20180112115209.17437-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180112115209.17437-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 12, 2018 at 01:52:09PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Add Fedora 27 to the list of cbuild targets.
> 
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>  buildlib/cbuild | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/buildlib/cbuild b/buildlib/cbuild
> index 3f659bf8..0ef80b60 100755
> +++ b/buildlib/cbuild
> @@ -141,6 +141,20 @@ class fc26(Environment):
>              " ".join(sorted(self.pkgs))));
>          return res;
> 
> +class fc27(Environment):
> +    docker_parent = "fedora:27";
> +    pkgs = (centos7.pkgs - {"make"}) | {"ninja-build"};
> +    name = "fc27";
> +    specfile = "redhat/rdma-core.spec";
> +    ninja_cmd = "ninja-build";
> +    is_rpm = True;
> +
> +    def get_docker_file(self):
> +        res = DockerFile(self.docker_parent);
> +        res.lines.append("RUN dnf install -y %s && dnf clean all"%(
> +            " ".join(sorted(self.pkgs))));
> +        return res;
> +
>  # -------------------------------------------------------------------------
> 
>  class APTEnvironment(Environment):
> @@ -337,6 +351,7 @@ environments = [centos6(),
>                  jessie(),
>                  stretch(),
>                  fc26(),
> +                fc27(),

I've been keeping only 1 fc container, no need to test old fedora.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
