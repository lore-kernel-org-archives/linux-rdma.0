From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] add a build.sh helper to allow for a one-stop build
Date: Mon, 10 Oct 2016 08:56:33 -0700
Message-ID: <c2d80cd4-74b8-8391-1855-3c666f611d91@acm.org>
References: <1476113282-19194-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476113282-19194-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/10/16 08:28, Christoph Hellwig wrote:
>  *build/bin* will contain the sample programs and *build/lib* will contain the
> diff --git a/build.sh b/build.sh
> new file mode 100755
> index 0000000..e3d85eb
> --- /dev/null
> +++ b/build.sh
> @@ -0,0 +1,12 @@
> +#!/bin/sh
> +
> +SRCDIR=`dirname $0`
> +BUILDDIR="$SRCDIR/build"
> +
> +if [ ! -d "$BUILDDIR" ]; then
> +    mkdir $BUILDDIR
> +fi
> +
> +cd $BUILDDIR
> +cmake -GNinja ..
> +ninja

Hello Christoph,

Have you considered to make this script stop immediately if one of the 
steps fails, e.g. as follows?

mkdir -p "$BUILDDIR" &&
cd build &&
cmake -G Ninja .. &&
ninja

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
