From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] libhns: Fix endian format of payload and
 immediate
Date: Wed, 15 Nov 2017 08:34:36 -0700
Message-ID: <20171115153436.GO25894@ziepe.ca>
References: <1509530440-164400-1-git-send-email-oulijun@huawei.com>
 <1509530440-164400-4-git-send-email-oulijun@huawei.com>
 <20171101161328.GB7815@ziepe.ca>
 <8dbc8305-f154-3b8c-795a-b5f1a6b53c73@huawei.com>
 <20171102150655.GD18874@ziepe.ca>
 <b2e9430c-a801-bef1-a491-8f983a525cab@huawei.com>
 <20171110211818.GH17451@ziepe.ca>
 <ef20c38b-201c-a039-c7c4-c5878fd0ee1c@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ef20c38b-201c-a039-c7c4-c5878fd0ee1c-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 15, 2017 at 06:02:23PM +0800, oulijun wrote:
> As a result, I alos re-run the cmds:
> mkdr build-sparse
> cd build-sparse
>  CC=cgcc cmake -GNinja ..
> 
> The print log is:
> ubuntu@a8d50a1f660b:~/rdma-v16/rdma-core/build-sparse$ CC=cgcc cmake -GNinja ..
> Traceback (most recent call last):
>   File "/home/ubuntu/rdma-v16/rdma-core/buildlib/gen-sparse.py", line 137, in <module>
> Patch from '/home/ubuntu/rdma-v16/rdma-core/buildlib/sparse-include/23/sys-socket.h.diff' failed
> Unable to apply any patch to 'sys/socket.h', tries 1
> Patch from '/home/ubuntu/rdma-v16/rdma-core/buildlib/sparse-include/25/netinet-in.h.diff' failed
> Patch from '/home/ubuntu/rdma-v16/rdma-core/buildlib/sparse-include/23/netinet-in.h.diff' failed
>     raise ValueError("Patch applications failed");
> ValueError: Patch applications failed
> CMake Error at buildlib/RDMA_Sparse.cmake:27 (message):
>   glibc header file patching for sparse failed.  Review include/*.rej and fix
>   the rejects, then do /home/ubuntu/rdma-v16/rdma-core/buildlib/gen-sparse.py
>   -out /home/ubuntu/rdma-v16/rdma-core/build-sparse/include/ --src
>   /home/ubuntu/rdma-v16/rdma-core/ --save
> Call Stack (most recent call first):
>   CMakeLists.txt:148 (RDMA_CheckSparse)

Okay, this is a different error, which version of ubuntu are you
using? I will fix it for you

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
