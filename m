From: Leon Romanovsky <leon@leon.nu>
Subject: Re: [PATCH] fix return value error
Date: Wed, 14 Oct 2015 14:59:36 +0300
Message-ID: <CALq1K=+s8pD6GEV0TUwsRN1gE75xP6PWAeoicQ8W6dLnNGipRg@mail.gmail.com>
References: <1444810679-30592-1-git-send-email-os@iscas.ac.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444810679-30592-1-git-send-email-os@iscas.ac.cn>
Sender: linux-kernel-owner@vger.kernel.org
To: Heloise NH <os@iscas.ac.cn>
Cc: infinipath@intel.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, linux-rdma <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 14, 2015 at 11:17 AM, Heloise NH <os@iscas.ac.cn> wrote:
> Signed-off-by: Heloise NH <os@iscas.ac.cn>
The patch is a correct one, however can you update the subject and
description to be more informative?
Please add that new_inode() function can fail for allocation only.

> ---
>  drivers/infiniband/hw/ipath/ipath_fs.c | 2 +-
>  drivers/infiniband/hw/qib/qib_fs.c     | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/ipath/ipath_fs.c b/drivers/infiniband/hw/ipath/ipath_fs.c
> index 25422a3..da753bc 100644
> --- a/drivers/infiniband/hw/ipath/ipath_fs.c
> +++ b/drivers/infiniband/hw/ipath/ipath_fs.c
> @@ -53,7 +53,7 @@ static int ipathfs_mknod(struct inode *dir, struct dentry *dentry,
>         struct inode *inode = new_inode(dir->i_sb);
>
>         if (!inode) {
> -               error = -EPERM;
> +               error = -ENOMEM;
>                 goto bail;
>         }
>
> diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
> index 13ef22b..a4c5a6a 100644
> --- a/drivers/infiniband/hw/qib/qib_fs.c
> +++ b/drivers/infiniband/hw/qib/qib_fs.c
> @@ -55,7 +55,7 @@ static int qibfs_mknod(struct inode *dir, struct dentry *dentry,
>         struct inode *inode = new_inode(dir->i_sb);
>
>         if (!inode) {
> -               error = -EPERM;
> +               error = -ENOMEM;
>                 goto bail;
>         }
>
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
