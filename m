From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH librdmacm 3/8] autogen.sh: Use autoreconf in autogen.sh
Date: Wed, 17 Jul 2013 04:22:31 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373805AECD6@ORSMSX109.amr.corp.intel.com>
References: <cover.1374011243.git.ydroneaud@opteya.com>
 <317ae98daf0eec49ffb297a5fc59b3738366af6d.1374011243.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <317ae98daf0eec49ffb297a5fc59b3738366af6d.1374011243.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks - I pulled in these patches, but see below:

> diff --git a/autogen.sh b/autogen.sh
> index f433312..6c9233e 100755
> --- a/autogen.sh
> +++ b/autogen.sh
> @@ -1,9 +1,4 @@
>  #! /bin/sh
> 
>  set -x
> -test -d ./config || mkdir ./config

Without the above line, the build fails.  I added it back in.  If there's some other way of ensuring that this directory exists, please let me know.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
