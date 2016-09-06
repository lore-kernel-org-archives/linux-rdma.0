From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Tue, 6 Sep 2016 09:59:48 -0400
Message-ID: <bb889a58-331c-8ba8-920d-e3a79072dce4@dev.mellanox.co.il>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471889618-1605-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/22/2016 2:13 PM, Jason Gunthorpe wrote:
> Hello Everyone,
> 
> Here is the patch series for the consolidation. This is based on the special
> merge commit created by the buildlib/make-merge.py script. See my prior
> message (http://www.spinics.net/lists/linux-rdma/msg39026.html) for details.
> 
> The first 7 patches change/fix various things in the original packages to
> build consistently, patch 8 has cmake and all the auto* co-exist, and can be
> used to do build compares (see buildlib/compare-build.py)
> 
> The next batch of patches removes the old build stuff, packaging, merges
> COPYING files and lightly simplifies the directory structure.
> 
> https://github.com/jgunthorpe/rdma-plumbing
> 
> This has been rebased since my last posting with feedback from Steve.
> 
> The following 15 repositories were pulled together.
> 
>       libcxgb3 git://git.openfabrics.org/~swise/libcxgb3.git 0de0392268af3a657b329874b63b6ee827109508
>       libcxgb4 git://git.openfabrics.org/~swise/libcxgb4.git 15d3253dc814da28e2b93ed02a8e9a96d97f20ae
>       libhfi1verbs https://github.com/01org/opa-libhfi1verbs.git 377b68888a0b885fc2a44ddf7a2ec33f2fcf217b
>       libi40iw git://git.openfabrics.org/~tnikolova/libi40iw/.git 9d35609f79d6a235e23182e9ceadf3605b2682da
>       libibcm git://git.openfabrics.org/~shefty/libibcm.git b04920e8bfe0689a2fe67815321dcf646fd48a7e
>       libibumad git://git.openfabrics.org/~halr/libibumad.git ecda3a56b18c6a2845f3d966f8b8061941f5d447
>       libibverbs git://git.kernel.org/pub/scm/libs/infiniband/libibverbs.git 0be978ea2bfaf203c35334b090bddb280de62611
>       libipathverbs https://github.com/01org/libipathverbs.git 8291d485f3a5544b43974e7be88f3646f35ae07c
>       libmlx4 git://git.openfabrics.org/~yishaih/libmlx4.git 162f948c4e04753a15cfb7afcdf6219dbe0bc31e
>       libmlx5 git://git.openfabrics.org/~yishaih/libmlx5.git f23f9aa7b9033cd8ebbd58d67d65e9b81d0525fa
>       libmthca git://git.kernel.org/pub/scm/libs/infiniband/libmthca.git 6f4dd7451ddef120247e13fa6cb8e1df69c3ddf9
>       libnes git://git.openfabrics.org/~tnikolova/libnes/.git 7dc7cf2474612ec909bff251096ca2aefa9cddf1
>       libocrdma git://git.openfabrics.org/~emulex/libocrdma.git 41f6bbb3fe8129678c233da439d872b3fe9f75dc
>       librdmacm git://git.openfabrics.org/~shefty/librdmacm.git 032bbe60ad32d59004447e03061a9f6d632cc55f
>       librxe https://github.com/SoftRoCE/librxe-dev.git 227e3c49b6e423c066e1e1887fe30c8261f63cbd

It would be nice if history from the original repos was
preserved/propagated into this combined repo. Is there a reason that
wasn't done ?

> Steve suggests that iwpm be included as well, which makes sense..
> 
> My hope is that Doug will step up as the unified maintainer, with a process
> similar to the kernel. Most of the libraries are unchanging/unmaintained/dead.

What is the anticipated process here ? Will the submaintainers need to
go through the uber-maintainer ?

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
