From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 7/7] libhns: Add consolidated repo for
 userspace library of hns
Date: Wed, 26 Oct 2016 10:33:54 -0600
Message-ID: <20161026163354.GG24898@obsidianresearch.com>
References: <1477487048-62256-1-git-send-email-oulijun@huawei.com>
 <1477487048-62256-8-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477487048-62256-8-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 26, 2016 at 09:04:08PM +0800, Lijun Ou wrote:
> +CHECK_C_SOURCE_COMPILES("
> +#ifndef __ARM64__
> +#error Failed
> +#endif
> + int main(int argc,const char *argv[]) { return 1; }"
> + HAVE_ARCH_ARM64)
> +
> +if (HAVE_ARCH_ARM64)

I don't see a compilation problem on x86, so please do not do
this. For maintainability we need all providers to compile on x86.

For now just drop in a '# FIXME: Kernel driver only builds on ARM64'
and maybe we can optimize things someday to always build but not
install the .so

> +rdma_provider(hns
> +  hns_roce_u_buf.c
> +  hns_roce_u.c
> +  hns_roce_u_hw_v1.c
> +  hns_roce_u_verbs.c

List should be sorted

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
