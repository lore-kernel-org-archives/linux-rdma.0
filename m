From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: building rdma-core from travis
Date: Mon, 17 Oct 2016 23:53:50 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB096A7B@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'm trying to build the wonderful new build system that has infested rdma-core from another travis project.  I hit this error attempting to run build.sh from a travis.yml script.


CMake Error at CMakeLists.txt:23 (cmake_minimum_required):

  CMake 2.8.11 or higher is required.  You are running version 2.8.7


I can see that travis runs successfully against rdma-core.  Was there a magic setting used to work-around the travis version?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
