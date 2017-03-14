From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core packaging and multilib
Date: Tue, 14 Mar 2017 12:17:08 -0600
Message-ID: <20170314181708.GA25495@obsidianresearch.com>
References: <bb6b2274-a120-6a16-0025-4c0b1b090029@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <bb6b2274-a120-6a16-0025-4c0b1b090029-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 14, 2017 at 02:02:15PM -0400, Jarod Wilson wrote:

> Report from TEST_MULTILIB:
> [BAD] [ibacm] Subpackage ibacm is not multilib-clean for x86_64 vs i686: 2
> files have non-equal 32/64bit content:
>   /usr/share/man/man7/ibacm_prov.7.gz
>   /etc/rdma/ibacm_opts.cfg

Yep

> ibacm_prov.7.gz on x86_64 vs i686:
> ...
> -2. be installed under a configured directory, eg., /usr/lib64/ibacm;
> +2. be installed under a configured directory, eg., /usr/lib/ibacm;
> ...
> 
> Similar for ibacm_opts.cfg:
> 
> -# provider_lib_path /usr/lib64/ibacm
> +# provider_lib_path /usr/lib/ibacm
> 
> Not sure what the ideal resolution is for this. I'd rather not put in the
> wrong path for one arch or the other, and I think lib64 isn't used
> universally by all 64-bit distros.

cmake substitutes in the correct path string at build time.

If you want these files to be identical then we cannot include the
path names at all, just put place holders and say to run 'ib_acme -D
. -O' to learn the configured value.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
