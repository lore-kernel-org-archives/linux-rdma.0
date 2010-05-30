From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ANNOUNCE] librdmacm 1.0.12
Date: Sun, 30 May 2010 14:29:57 +0300
Message-ID: <4C024C35.2090703@dev.mellanox.co.il>
References: <CE35DBA4CC524BD3BDA61C7DE2BD39CD@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CE35DBA4CC524BD3BDA61C7DE2BD39CD-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sean Hefty wrote:
> I've pushed out release 1.0.12 of librdmacm.  This incorporates several new APIs
> that should make connecting and transferring data over RDMA devices simpler for
> user applications, plus adds support for user space path record caching.
> 
> New APIs include simple wrappers for common verbs operations, such as memory
> registration, posting of work requests, and retrieving completions.  Support for
> synchronous connection establishment was added, along with newer calls that
> combine the work done using multiple existing calls.  To help address MPI
> scaling issues, this release provides support for IB ACM path record caching
> capabilities, enabled through the use of a compile time option.  New client and
> server test applications were also added to demonstrate the use of the new APIs.
> 
> (Note that the source code includes changes for AF_IB support, but AF_IB has
> been disabled in the code to avoid potential ABI compatibility issues until the
> kernel changes have been accepted upstream.)  This version wants the soon to be
> released version of libibverbs, but will work with older versions installed.
> 
> Please pull this release into OFED 1.5.2.  I will provide a set of release notes
> next week.
> 
> - Sean
> 


Sean,
librdmacm 1.0.12 compilation fails on RHEL4.x:

  gcc -DHAVE_CONFIG_H -I. -I. -I. -I./include -g -Wall -D_GNU_SOURCE -O2 -g -pipe -m64 -MT src_librdmacm_la-acm.lo -MD -MP -MF .deps/src_librdmacm_la-acm.Tpo -c src/acm.c  -fPIC -DPIC -o 
.libs/src_librdmacm_la-acm.o
In file included from src/acm.c:44:
./include/infiniband/ib.h:49: error: syntax error before "__be16"
./include/infiniband/ib.h:49: warning: no semicolon at end of struct or union
./include/infiniband/ib.h:49: warning: no semicolon at end of struct or union
./include/infiniband/ib.h:50: warning: type defaults to `int' in declaration of `uib_addr32'
./include/infiniband/ib.h:50: warning: data definition has no type or storage class
./include/infiniband/ib.h:51: error: syntax error before "uib_addr64"
./include/infiniband/ib.h:51: warning: type defaults to `int' in declaration of `uib_addr64'
./include/infiniband/ib.h:51: warning: data definition has no type or storage class
./include/infiniband/ib.h:52: error: syntax error before '}' token
./include/infiniband/ib.h:52: warning: type defaults to `int' in declaration of `ib_u'
./include/infiniband/ib.h:52: warning: data definition has no type or storage class
./include/infiniband/ib.h:60: error: syntax error before '}' token
./include/infiniband/ib.h: In function `ib_addr_any':
./include/infiniband/ib.h:64: error: dereferencing pointer to incomplete type
./include/infiniband/ib.h:64: error: dereferencing pointer to incomplete type
./include/infiniband/ib.h: In function `ib_addr_loopback':
./include/infiniband/ib.h:69: error: dereferencing pointer to incomplete type
./include/infiniband/ib.h:69: error: dereferencing pointer to incomplete type
./include/infiniband/ib.h:70: error: dereferencing pointer to incomplete type
./include/infiniband/ib.h:70: error: dereferencing pointer to incomplete type
./include/infiniband/ib.h: At top level:
./include/infiniband/ib.h:74: error: syntax error before "__be32"
./include/infiniband/ib.h: In function `ib_addr_set':
./include/infiniband/ib.h:76: error: `addr' undeclared (first use in this function)
./include/infiniband/ib.h:76: error: (Each undeclared identifier is reported only once
./include/infiniband/ib.h:76: error: for each function it appears in.)
./include/infiniband/ib.h:76: error: `w1' undeclared (first use in this function)
./include/infiniband/ib.h:77: error: `w2' undeclared (first use in this function)
./include/infiniband/ib.h:78: error: `w3' undeclared (first use in this function)
./include/infiniband/ib.h:79: error: `w4' undeclared (first use in this function)
./include/infiniband/ib.h: In function `ib_addr_cmp':
./include/infiniband/ib.h:84: error: invalid application of `sizeof' to incomplete type `ib_addr'
./include/infiniband/ib.h: At top level:
./include/infiniband/ib.h:89: error: syntax error before "__be16"
./include/infiniband/ib.h:89: warning: no semicolon at end of struct or union
./include/infiniband/ib.h:90: warning: type defaults to `int' in declaration of `sib_flowinfo'
./include/infiniband/ib.h:90: warning: data definition has no type or storage class
./include/infiniband/ib.h:92: error: syntax error before "sib_sid"
./include/infiniband/ib.h:92: warning: type defaults to `int' in declaration of `sib_sid'
./include/infiniband/ib.h:92: warning: data definition has no type or storage class
./include/infiniband/ib.h:93: error: syntax error before "sib_sid_mask"
./include/infiniband/ib.h:93: warning: type defaults to `int' in declaration of `sib_sid_mask'
./include/infiniband/ib.h:93: warning: data definition has no type or storage class
./include/infiniband/ib.h:95: error: syntax error before '}' token
./include/infiniband/ib.h:91: error: storage size of `sib_addr' isn't known

Regards,
Vladimir

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
