From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 5/5] RDMA/hns: Fix the illegal memory operation
 when cross page
Date: Wed, 23 May 2018 09:17:06 +0300
Message-ID: <20180523061706.GA5729@mtr-leonro.mtl.com>
References: <1526544173-106587-1-git-send-email-xavier.huwei@huawei.com>
 <1526544173-106587-6-git-send-email-xavier.huwei@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1526544173-106587-6-git-send-email-xavier.huwei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Cc: dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, xavier.huwei@tom.com, lijun_nudt@163.com
List-Id: linux-rdma@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 17, 2018 at 04:02:53PM +0800, Wei Hu (Xavier) wrote:
> This patch fixed the potential illegal operation when using the
> extend sge buffer cross page in post send operation. The bug
> will cause the calltrace.
>
> Reported-by: Jie Chen <chenjie103@huawei.com>
> Reported-by: Xiping Zhang (Francis) <zhangxiping3@huawei.com>
> Fixes: b1c1583("RDMA/hns: Get rid of virt_to_page and vmap calls after dma_alloc_coherent")

Documentation/process/submitting-patches.rst
183 If your patch fixes a bug in a specific commit, e.g. you found an issue using
184 ``git bisect``, please use the 'Fixes:' tag with the first 12 characters of
185 the SHA-1 ID, and the one line summary.  For example::
186
187         Fixes: e21d2170f366 ("video: remove unnecessary platform_set_drvdata()")

Thanks

> Signed-off-by: Wei Hu (Xavier) <xavier.huwei@huawei.com>

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbBQdiAAoJEORje4g2clinsxIQAMAN+dwMEzxYHWqAqnFzdG96
v8Y1NcWPuy6xcQuMPVbWpiLCTV/8OUFj6AO+b0v8moAcVGKBn8JCy5FSyl+52Nm7
snLQ1vqocq/dUFKnOI51Mqw38YcpM83tVqZ+shnIBbpkUQ8KFcRxILa0UDtwPPO3
EFZV6zZZ8sQjthq2ddpZAXXrcDdxzLmgNtXeHEw0X1UjIDZLkMAjxWJfdI8pKhV1
OxlMeL+9taRmr/PDHtRTaIHvt6IRXFze5gsd1x6KukrPYR1N3GiGt/Cr3wPHzpZm
HudNU8PhEqcmpebSR0Ydn6FZUV4fPYWCd4i3i1ViZ3w8ay/ouFcSxaEr0utDaEZL
AyAmtg1rbWkljmcdeXuj/4Ooxp2k8IjH9y0lVyNQpIcTEbRkHaMLznxZCxjgZeTa
G3T5xV97wHKsouF2ipA9jz7RBgawIc+c2A6+VtKJqQvAmPCrVqujx0GL+mi58Uc/
Vl7HceomIqJ/sfBaCu5d7prNmUVCwtjesFyUrGGAKsm7WBHvyFaQdg995JDZGw54
KxnIvWIWFiQodOMQrzTg7ujDAlSOssGxEZjFvvKs9SWRXY/hRkWgeOnssDpb95MS
1WVH/QHF6IRP2N+7eFBcD0PIyhYJ6EufreQXek9ZsIYIy1MLCYqZv4MLVGomDpGP
wYpRkzgICN33p7zhLe5E
=0eOK
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
