From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: Building rdma-core from github gave an error "Unknown arguments
 specified"
Date: Fri, 12 Jan 2018 11:08:24 -0700
Message-ID: <20180112180824.GE15974@ziepe.ca>
References: <CAGXs5wUoLZLtmHhyRm3poALO5ZGSdS5u4+saKhigMgHivw-9Eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAGXs5wUoLZLtmHhyRm3poALO5ZGSdS5u4+saKhigMgHivw-9Eg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 12, 2018 at 11:35:04AM +0200, Kevin Wilson wrote:
> Hi,
> I had cloned the latest rdma-core:
> https://github.com/linux-rdma/rdma-core.git
> 
> I am trying to build it on Fedora 27 x86_64 machine.
> When I ran:
> bash build.sh
> I got the following:
> 
> CMake Error at buildlib/RDMA_BuildType.cmake:32 (if):
>   if given arguments:
> 
>     "STREQUAL" "-O2 -g -DNDEBUG"
> 
>   Unknown arguments specified
> Call Stack (most recent call first):
>   CMakeLists.txt:145 (RDMA_BuildType)

No idea.. Can't reproduce.

I wonder if some quotes are missing:

diff --git a/buildlib/RDMA_BuildType.cmake b/buildlib/RDMA_BuildType.cmake
index 0951edadeebf61..ea2bbf8e639c2f 100644
--- a/buildlib/RDMA_BuildType.cmake
+++ b/buildlib/RDMA_BuildType.cmake
@@ -29,7 +29,7 @@ function(RDMA_BuildType)
   # with the -DNDEBUG removed
   foreach (language CXX C)
     set(VAR_TO_MODIFY "CMAKE_${language}_FLAGS_RELWITHDEBINFO")
-    if (${${VAR_TO_MODIFY}} STREQUAL ${${VAR_TO_MODIFY}_INIT})
+    if ("${${VAR_TO_MODIFY}}" STREQUAL ${${VAR_TO_MODIFY}_INIT})
 	string(REGEX REPLACE "(^| )[/-]D *NDEBUG($| )"
 	  " "
 	  replacement
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
