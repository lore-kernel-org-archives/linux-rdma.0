From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] Fix missing source dir in configure.ac
Date: Sat, 19 Apr 2014 22:19:56 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E04B6646A@CRSMSX101.amr.corp.intel.com>
References: <20140331070319.GA15821@r-ufm96.mtr.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140331070319.GA15821-d8864ACYL78DyJZ7l8Lk7nI+JuX82XLG@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> This fixes running configure outside the infiniband-diags dir
> 
> Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks applied,
Ira


> ---
>  configure.ac |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac index 122a029..232285f 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -190,7 +190,7 @@ fi
>  if test x$have_rst2man == xyes; then
>  	doc/generate
>  else
> -	if test -f doc/man/infiniband-diags.8.in; then
> +	if test -f $srcdir/doc/man/infiniband-diags.8.in; then
>  		echo "WARNING: 'rst2man' not found; using premade man
> pages"
>  	else
>  		echo "FAILED to find 'rst2man' required to build man pages"
> --
> 1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
