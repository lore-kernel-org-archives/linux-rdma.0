From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] librdmacm 1.0.12
Date: Fri, 21 May 2010 16:06:04 -0700
Message-ID: <CE35DBA4CC524BD3BDA61C7DE2BD39CD@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I've pushed out release 1.0.12 of librdmacm.  This incorporates several new APIs
that should make connecting and transferring data over RDMA devices simpler for
user applications, plus adds support for user space path record caching.

New APIs include simple wrappers for common verbs operations, such as memory
registration, posting of work requests, and retrieving completions.  Support for
synchronous connection establishment was added, along with newer calls that
combine the work done using multiple existing calls.  To help address MPI
scaling issues, this release provides support for IB ACM path record caching
capabilities, enabled through the use of a compile time option.  New client and
server test applications were also added to demonstrate the use of the new APIs.

(Note that the source code includes changes for AF_IB support, but AF_IB has
been disabled in the code to avoid potential ABI compatibility issues until the
kernel changes have been accepted upstream.)  This version wants the soon to be
released version of libibverbs, but will work with older versions installed.

Please pull this release into OFED 1.5.2.  I will provide a set of release notes
next week.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
