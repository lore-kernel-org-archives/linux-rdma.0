From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: RFC: Consolidated userspace RDMA library repo
Date: Tue, 9 Aug 2016 23:34:37 -0600
Message-ID: <20160810053437.GA22257@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Matan Barak' <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Majd Dibbiny' <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello everyone,

I have gone ahead and constructed a unified user space source repo
for almost all of the user space kernel interface components. This not
very hard just fussy. The biggest issue was harmonizing the divergent
builds into one single system.

This merging will help the distros and help streamline the forthcoming
API work.

It is not quite completed, but it is good enough for people to
comment on, I have a github repo here:

https://github.com/jgunthorpe/rdma-plumbing

After the first round of comments I can post a patch series starting
from the octopus merge commit, and with a bigger cc list..

Things to note:
 - Some git-wizardry was done to preserve the repository history. This
   works OK, but git is a bit wonky when it hits the octopus merge.
   All of the tags are preserved as well, though lightly renamed.
 - I used cmake for the unified build system, the auto* stuff had
   bitrotted so badly, and was never very nice to use anyhow.

   For developers I strongly recommend using it with ninja build
   (ninja-build.org), that provides a better-than-kbuild experience.
 - There is a 'tooling' branch that has a bunch of one time use
   scripts used to build this
      make-merge.py - Can be used to reproduce the octopus merge commit
      compare-build.py - Is used to study the build results to check
                         for breakage
      docker/do_docker.py - Docker containers and scripts for build
                            testing
 - The 'make install' target produces something nearly identical to
   running 'make install' on all the sub libraries. The commit
   messages discuss the differences.
 - I haven't looked at packaging, but that usually isn't too much more
   trouble.
 - Building is tested to work on Centos 7/6, Debian 8, Ubuntu 14.05/16.04

My hope is that Doug will step up as the unified maintainer, with a
process similar to the kernel. Most of the libraries are
unchanging/unmaintained/dead.

The following 15 repos were pulled together:

      libcxgb3 git://git.openfabrics.org/~swise/libcxgb3.git 0de0392268af3a657b329874b63b6ee827109508
      libcxgb4 git://git.openfabrics.org/~swise/libcxgb4.git 15d3253dc814da28e2b93ed02a8e9a96d97f20ae
      libhfi1verbs https://github.com/01org/opa-libhfi1verbs.git 377b68888a0b885fc2a44ddf7a2ec33f2fcf217b
      libi40iw git://git.openfabrics.org/~tnikolova/libi40iw/.git 9d35609f79d6a235e23182e9ceadf3605b2682da
      libibcm git://git.openfabrics.org/~shefty/libibcm.git b04920e8bfe0689a2fe67815321dcf646fd48a7e
      libibumad git://git.openfabrics.org/~halr/libibumad.git ecda3a56b18c6a2845f3d966f8b8061941f5d447
      libibverbs git://git.kernel.org/pub/scm/libs/infiniband/libibverbs.git 0be978ea2bfaf203c35334b090bddb280de62611
      libipathverbs https://github.com/01org/libipathverbs.git 8291d485f3a5544b43974e7be88f3646f35ae07c
      libmlx4 git://git.openfabrics.org/~yishaih/libmlx4.git 162f948c4e04753a15cfb7afcdf6219dbe0bc31e
      libmlx5 git://git.openfabrics.org/~yishaih/libmlx5.git f23f9aa7b9033cd8ebbd58d67d65e9b81d0525fa
      libmthca git://git.kernel.org/pub/scm/libs/infiniband/libmthca.git 6f4dd7451ddef120247e13fa6cb8e1df69c3ddf9
      libnes git://git.openfabrics.org/~tnikolova/libnes/.git 7dc7cf2474612ec909bff251096ca2aefa9cddf1
      libocrdma git://git.openfabrics.org/~emulex/libocrdma.git 41f6bbb3fe8129678c233da439d872b3fe9f75dc
      librdmacm git://git.openfabrics.org/~shefty/librdmacm.git 032bbe60ad32d59004447e03061a9f6d632cc55f
      librxe https://github.com/SoftRoCE/librxe-dev.git 227e3c49b6e423c066e1e1887fe30c8261f63cbd

Which, I think, represents all the user space providers for the kernel
side, and all the libraries that touch kernel char devs.

I was looking at iwpm as well, but I don't know too much about what
that is..

libacm and libibmad may also be candidates, but they fall outside my
initial critiera of talking directly to the kernel.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
