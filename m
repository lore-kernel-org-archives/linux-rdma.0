From: Bhumika Goyal <bhumirks@gmail.com>
Subject: Re: [PATCH] IB/cma: make config_item_type const
Date: Thu, 12 Oct 2017 17:04:36 +0200
Message-ID: <CAOH+1jF3ma7f5ynw5OjSdH5S3NACwcRK+CTBapcrJgpJabj7jQ@mail.gmail.com>
References: <1507810800-8972-1-git-send-email-bhumirks@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507810800-8972-1-git-send-email-bhumirks@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <julia.lawall@lip6.fr>, dledford@redhat.com, sean.hefty@intel.com, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Bhumika Goyal <bhumirks@gmail.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 12, 2017 at 2:20 PM, Bhumika Goyal <bhumirks@gmail.com> wrote:
> This is a followup patch for: https://lkml.org/lkml/2017/10/11/375 and
> https://patchwork.kernel.org/patch/9999649/
>
> Make these structures const as they are either passed to the functions
> having the argument as const or stored as a reference in the "ci_type"
> const field of a config_item structure.
>
> Done using Coccienlle.
>

This patch is dependent on the patches in the links
https://lkml.org/lkml/2017/10/11/375 and
https://patchwork.kernel.org/patch/9999649/. Therefore, this patch
won't be correct unless the patches in these links gets applied.

> Signed-off-by: Bhumika Goyal <bhumirks@gmail.com>
> ---
>  drivers/infiniband/core/cma_configfs.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/infiniband/core/cma_configfs.c b/drivers/infiniband/core/cma_configfs.c
> index 54076a3..31dfee0 100644
> --- a/drivers/infiniband/core/cma_configfs.c
> +++ b/drivers/infiniband/core/cma_configfs.c
> @@ -186,7 +186,7 @@ static ssize_t default_roce_tos_store(struct config_item *item,
>         NULL,
>  };
>
> -static struct config_item_type cma_port_group_type = {
> +static const struct config_item_type cma_port_group_type = {
>         .ct_attrs       = cma_configfs_attributes,
>         .ct_owner       = THIS_MODULE
>  };
> @@ -263,7 +263,7 @@ static void release_cma_ports_group(struct config_item  *item)
>         .release = release_cma_ports_group
>  };
>
> -static struct config_item_type cma_ports_group_type = {
> +static const struct config_item_type cma_ports_group_type = {
>         .ct_item_ops    = &cma_ports_item_ops,
>         .ct_owner       = THIS_MODULE
>  };
> @@ -272,7 +272,7 @@ static void release_cma_ports_group(struct config_item  *item)
>         .release = release_cma_dev
>  };
>
> -static struct config_item_type cma_device_group_type = {
> +static const struct config_item_type cma_device_group_type = {
>         .ct_item_ops    = &cma_device_item_ops,
>         .ct_owner       = THIS_MODULE
>  };
> @@ -323,7 +323,7 @@ static struct config_group *make_cma_dev(struct config_group *group,
>         .make_group     = make_cma_dev,
>  };
>
> -static struct config_item_type cma_subsys_type = {
> +static const struct config_item_type cma_subsys_type = {
>         .ct_group_ops   = &cma_subsys_group_ops,
>         .ct_owner       = THIS_MODULE,
>  };
> --
> 1.9.1
>
