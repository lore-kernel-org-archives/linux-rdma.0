From: Kevin Wilson <wkevils-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Building rdma-core from github gave an error "Unknown arguments specified"
Date: Fri, 12 Jan 2018 11:35:04 +0200
Message-ID: <CAGXs5wUoLZLtmHhyRm3poALO5ZGSdS5u4+saKhigMgHivw-9Eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,
I had cloned the latest rdma-core:
https://github.com/linux-rdma/rdma-core.git

I am trying to build it on Fedora 27 x86_64 machine.
When I ran:
bash build.sh
I got the following:

CMake Error at buildlib/RDMA_BuildType.cmake:32 (if):
  if given arguments:

    "STREQUAL" "-O2 -g -DNDEBUG"

  Unknown arguments specified
Call Stack (most recent call first):
  CMakeLists.txt:145 (RDMA_BuildType)


-- Configuring incomplete, errors occurred!
See also "/work/down/temp/rdma-core/build/CMakeFiles/CMakeOutput.log".
See also "/work/down/temp/rdma-core/build/CMakeFiles/CMakeError.log".

Any ideas what can it be ?

More details:
As said, I am on the latest git commit, on the master branch:
git log | more
commit c4345781db3d4d24578873b612357124c6b3d1e3
Author: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Date:   Thu Jan 4 15:27:51 2018 +0100

    debian: Update changelog to include Debian uploads 16.x

Regards,
KW
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
