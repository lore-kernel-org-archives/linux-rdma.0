From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] Fix the gen_chlog.sh script to support
 builds in a separate directory
Date: Fri, 16 Jun 2017 14:01:27 +0200
Message-ID: <1497614487.15929.18.camel@oracle.com>
References: <20170614104824.21599-1-knut.omang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170614104824.21599-1-knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Never mind - after some head scratching I realized my git remote reference 
had become obsolete since the last time I pulled it.

This patch was against the obsolete (but still existing)
git://git.openfabrics.org/~iraweiny/infiniband-diags.git

not the current

https://github.com/linux-rdma/infiniband-diags

Thanks,
Knut

On Wed, 2017-06-14 at 12:48 +0200, Knut Omang wrote:
> Configuring and building in a separate directory breaks
> because gen_chlog.sh assumes it runs from the git tree.
> Instead of making this assumption, rather assume the more
> generic, that the gen_chlog.sh script itself is located
> in the top sourcedir.
> 
> With this fix configuring and building in a separate
> tree from the source tree works.
> 
> Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  gen_chlog.sh | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/gen_chlog.sh b/gen_chlog.sh
> index 34dfa24..59a9e1f 100755
> --- a/gen_chlog.sh
> +++ b/gen_chlog.sh
> @@ -10,6 +10,8 @@ if [ "$1" = "--spec" ] ; then
>  	spec_format=1
>  fi
>  
> +cd `dirname $0`
> +
>  GIT_DIR=`git rev-parse --git-dir 2>/dev/null`
>  
>  test -z "$GIT_DIR" && usage
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
