From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core and endianness checking with sparse
Date: Tue, 21 Mar 2017 12:20:45 -0600
Message-ID: <20170321182045.GA16299@obsidianresearch.com>
References: <1490118969.2605.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1490118969.2605.1.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 21, 2017 at 05:56:23PM +0000, Bart Van Assche wrote:
> Hello Jason,
> 
> Since commit https://github.com/linux-rdma/rdma-core/commit/dceee9494bfbadf0cf16b8fef81f3c2cb5355243
> checking endianness locally with sparse is broken on my development
> setup.

I am surprised, I did check that tumbleweed worked for you on
tumbleweed..

Ah, but I see glibc 25 is out :(

As you say, it is not unexpected with this approach.

> The following error messages appear:
> 
> Patch from '/home/bart/software/infiniband/rdma-core/buildlib/sparse-include/19/netinet-in.h.diff' failed
> Patch from '/home/bart/software/infiniband/rdma-core/buildlib/sparse-include/23/netinet-in.h.diff' failed
> Traceback (most recent call last):
>   File "/home/bart/software/infiniband/rdma-core/buildlib/gen-sparse.py", line 129, in <module>
>     replace_header(I);
>   File "/home/bart/software/infiniband/rdma-core/buildlib/gen-sparse.py", line 82, in replace_header
>     raise ValueError("Unable to apply any patch to %r, tries %u"%(fn,tries));
> ValueError: Unable to apply any patch to 'netinet/in.h', tries 2
>
> I was surprised to see that merge request in the rdma-core repository although
> I had warned from beforehand that this could happen?

I would like to take small steps here. This is enough to make sparse
work in travis, and it finds bugs, so we are overall better off.

Let us find some way to make it work on more reliably on development
systems. But, I am not really that optimistic :(

I added some revisions here which use include_next where it is easy:

https://github.com/jgunthorpe/rdma-plumbing/commits/sparse

But still patches the harder things. I also fixed things up for glibc
25, so it should make it work for you on tumbleweed

I continue to think a 'cbuild make sparse' is the way to go for
desktop use..

Jason

>From 272a886ce2480adbbb993a7c597281db86efe13e Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Date: Tue, 21 Mar 2017 12:14:57 -0600
Subject: [PATCH] sparse: Improve the glibc header file mangling

- Use include_next wrappers for the very simple cases, hopefully these
  will be more robust against different glibc versions
- Check patching works on tumbleweed, C7, trusty and xenial.
- Check for patching failure from cmake and provide some guidance

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 buildlib/RDMA_Sparse.cmake                   |   7 +-
 buildlib/gen-sparse.py                       |  11 ++-
 buildlib/sparse-include/23/endian.h.diff     |  57 -------------
 buildlib/sparse-include/23/pthread.h.diff    |  11 ---
 buildlib/sparse-include/25/netinet-in.h.diff | 121 +++++++++++++++++++++++++++
 buildlib/sparse-include/endian.h             |  43 ++++++++++
 buildlib/sparse-include/pthread.h            |  12 +++
 7 files changed, 191 insertions(+), 71 deletions(-)
 delete mode 100644 buildlib/sparse-include/23/endian.h.diff
 delete mode 100644 buildlib/sparse-include/23/pthread.h.diff
 create mode 100644 buildlib/sparse-include/25/netinet-in.h.diff
 create mode 100644 buildlib/sparse-include/endian.h
 create mode 100644 buildlib/sparse-include/pthread.h

diff --git a/buildlib/RDMA_Sparse.cmake b/buildlib/RDMA_Sparse.cmake
index 0f42de6937e56e..e6bd41e22a7daa 100644
--- a/buildlib/RDMA_Sparse.cmake
+++ b/buildlib/RDMA_Sparse.cmake
@@ -20,7 +20,12 @@ int main(int argc,const char *argv[]) {return 0;}
     # Replace various glibc headers with our own versions that have embedded sparse annotations.
     execute_process(COMMAND "${BUILDLIB}/gen-sparse.py"
       "--out" "${BUILD_INCLUDE}/"
-      "--src" "${CMAKE_SOURCE_DIR}/")
+      "--src" "${CMAKE_SOURCE_DIR}/"
+      RESULT_VARIABLE retcode)
+    if(NOT "${retcode}" STREQUAL "0")
+      message(FATAL_ERROR "glibc header file patching for sparse failed. Review include/*.rej and fix the rejects, then do "
+	"${BUILDLIB}/gen-sparse.py -out ${BUILD_INCLUDE}/ --src ${CMAKE_SOURCE_DIR}/ --save")
+    endif()
   endif()
 
   # Enable endian analysis in sparse
diff --git a/buildlib/gen-sparse.py b/buildlib/gen-sparse.py
index 2116da0788d012..27c773ebcdd429 100755
--- a/buildlib/gen-sparse.py
+++ b/buildlib/gen-sparse.py
@@ -35,7 +35,7 @@ def get_buildlib_patches(dfn):
                 bn = 0;
 
             res.append((bn,os.path.join(d,I)));
-    res.sort();
+    res.sort(reverse=True);
 
     ret = collections.defaultdict(list);
     for _,I in res:
@@ -79,7 +79,10 @@ def replace_header(fn):
                        pfn,os.path.join(args.INCLUDE,fn)):
             return;
         tries = tries + 1;
-    raise ValueError("Unable to apply any patch to %r, tries %u"%(fn,tries));
+
+    print "Unable to apply any patch to %r, tries %u"%(fn,tries);
+    global failed;
+    failed = True;
 
 def save(fn,outdir):
     """Diff the header file in our include directory against the system header and
@@ -124,6 +127,10 @@ if args.save:
     for I in headers:
         save(I,outdir);
 else:
+    failed = False;
     patches = get_buildlib_patches(os.path.join(args.SRC,"buildlib","sparse-include"));
     for I in headers:
         replace_header(I);
+
+    if failed:
+        raise ValueError("Patch applications failed");
diff --git a/buildlib/sparse-include/23/endian.h.diff b/buildlib/sparse-include/23/endian.h.diff
deleted file mode 100644
index ac6f681b4f8850..00000000000000
--- a/buildlib/sparse-include/23/endian.h.diff
+++ /dev/null
@@ -1,57 +0,0 @@
---- /usr/include/endian.h	2016-11-16 15:43:37.000000000 -0700
-+++ build-sparse/include/endian.h	2017-03-15 12:43:28.732376898 -0600
-@@ -59,38 +59,23 @@
- /* Conversion interfaces.  */
- # include <bits/byteswap.h>
- 
--# if __BYTE_ORDER == __LITTLE_ENDIAN
--#  define htobe16(x) __bswap_16 (x)
--#  define htole16(x) (x)
--#  define be16toh(x) __bswap_16 (x)
--#  define le16toh(x) (x)
-+// Simple vesion for sparse with annotations
-+# include <util/compiler.h>
- 
--#  define htobe32(x) __bswap_32 (x)
--#  define htole32(x) (x)
--#  define be32toh(x) __bswap_32 (x)
--#  define le32toh(x) (x)
-+# define htobe16(x) ((__force __be16)__bswap_16 (x))
-+# define htole16(x) ((__force __le16)__bswap_16 (x))
-+# define be16toh(x) ((uint16_t)__bswap_16 ((__force uint16_t)(__be16)(x)))
-+# define le16toh(x) ((uint16_t)__bswap_16 ((__force uint16_t)(__le16)(x)))
-+
-+# define htobe32(x) ((__force __be32)__bswap_32 (x))
-+# define htole32(x) ((__force __le32)__bswap_32 (x))
-+# define be32toh(x) ((uint32_t)__bswap_32 ((__force uint32_t)(__be32)(x)))
-+# define le32toh(x) ((uint32_t)__bswap_32 ((__force uint32_t)(__le32)(x)))
-+
-+# define htobe64(x) ((__force __be64)__bswap_64 (x))
-+# define htole64(x) ((__force __le64)__bswap_64 (x))
-+# define be64toh(x) ((uint64_t)__bswap_64 ((__force uint64_t)(__be64)(x)))
-+# define le64toh(x) ((uint64_t)__bswap_64 ((__force uint64_t)(__le64)(x)))
- 
--#  define htobe64(x) __bswap_64 (x)
--#  define htole64(x) (x)
--#  define be64toh(x) __bswap_64 (x)
--#  define le64toh(x) (x)
--
--# else
--#  define htobe16(x) (x)
--#  define htole16(x) __bswap_16 (x)
--#  define be16toh(x) (x)
--#  define le16toh(x) __bswap_16 (x)
--
--#  define htobe32(x) (x)
--#  define htole32(x) __bswap_32 (x)
--#  define be32toh(x) (x)
--#  define le32toh(x) __bswap_32 (x)
--
--#  define htobe64(x) (x)
--#  define htole64(x) __bswap_64 (x)
--#  define be64toh(x) (x)
--#  define le64toh(x) __bswap_64 (x)
--# endif
- #endif
--
- #endif	/* endian.h */
diff --git a/buildlib/sparse-include/23/pthread.h.diff b/buildlib/sparse-include/23/pthread.h.diff
deleted file mode 100644
index 6ff2985840cb8e..00000000000000
--- a/buildlib/sparse-include/23/pthread.h.diff
+++ /dev/null
@@ -1,11 +0,0 @@
---- /usr/include/pthread.h	2016-11-16 15:43:59.000000000 -0700
-+++ build-sparse/include/pthread.h	2017-03-15 12:43:28.736376893 -0600
-@@ -84,7 +84,7 @@
- 
- #ifdef __PTHREAD_MUTEX_HAVE_PREV
- # define PTHREAD_MUTEX_INITIALIZER \
--  { { 0, 0, 0, 0, 0, __PTHREAD_SPINS, { 0, 0 } } }
-+  { { 0, 0, 0, 0, 0, __PTHREAD_SPINS, { } } }
- # ifdef __USE_GNU
- #  define PTHREAD_RECURSIVE_MUTEX_INITIALIZER_NP \
-   { { 0, 0, 0, 0, PTHREAD_MUTEX_RECURSIVE_NP, __PTHREAD_SPINS, { 0, 0 } } }
diff --git a/buildlib/sparse-include/25/netinet-in.h.diff b/buildlib/sparse-include/25/netinet-in.h.diff
new file mode 100644
index 00000000000000..42380875efa4bc
--- /dev/null
+++ b/buildlib/sparse-include/25/netinet-in.h.diff
@@ -0,0 +1,121 @@
+--- /usr/include/netinet/in.h	2017-03-09 00:51:29.000000000 +0000
++++ build-tumbleweed/include/netinet/in.h	2017-03-21 18:13:51.951339197 +0000
+@@ -22,12 +22,12 @@
+ #include <stdint.h>
+ #include <sys/socket.h>
+ #include <bits/types.h>
+-
++#include <linux/types.h>
+ 
+ __BEGIN_DECLS
+ 
+ /* Internet address.  */
+-typedef uint32_t in_addr_t;
++typedef __be32 in_addr_t;
+ struct in_addr
+   {
+     in_addr_t s_addr;
+@@ -116,7 +116,7 @@
+ #endif /* !__USE_KERNEL_IPV6_DEFS */
+ 
+ /* Type to represent a port.  */
+-typedef uint16_t in_port_t;
++typedef __be16 in_port_t;
+ 
+ /* Standard well-known ports.  */
+ enum
+@@ -175,36 +175,36 @@
+ #define	IN_CLASSB_HOST		(0xffffffff & ~IN_CLASSB_NET)
+ #define	IN_CLASSB_MAX		65536
+ 
+-#define	IN_CLASSC(a)		((((in_addr_t)(a)) & 0xe0000000) == 0xc0000000)
++#define	IN_CLASSC(a)		((((uint32_t)(a)) & 0xe0000000) == 0xc0000000)
+ #define	IN_CLASSC_NET		0xffffff00
+ #define	IN_CLASSC_NSHIFT	8
+ #define	IN_CLASSC_HOST		(0xffffffff & ~IN_CLASSC_NET)
+ 
+-#define	IN_CLASSD(a)		((((in_addr_t)(a)) & 0xf0000000) == 0xe0000000)
++#define	IN_CLASSD(a)		((((uint32_t)(a)) & 0xf0000000) == 0xe0000000)
+ #define	IN_MULTICAST(a)		IN_CLASSD(a)
+ 
+-#define	IN_EXPERIMENTAL(a)	((((in_addr_t)(a)) & 0xe0000000) == 0xe0000000)
+-#define	IN_BADCLASS(a)		((((in_addr_t)(a)) & 0xf0000000) == 0xf0000000)
++#define	IN_EXPERIMENTAL(a)	((((uint32_t)(a)) & 0xe0000000) == 0xe0000000)
++#define	IN_BADCLASS(a)		((((uint32_t)(a)) & 0xf0000000) == 0xf0000000)
+ 
+ /* Address to accept any incoming messages.  */
+-#define	INADDR_ANY		((in_addr_t) 0x00000000)
++#define	INADDR_ANY		((uint32_t) 0x00000000)
+ /* Address to send to all hosts.  */
+-#define	INADDR_BROADCAST	((in_addr_t) 0xffffffff)
++#define	INADDR_BROADCAST	((uint32_t) 0xffffffff)
+ /* Address indicating an error return.  */
+-#define	INADDR_NONE		((in_addr_t) 0xffffffff)
++#define	INADDR_NONE		((uint32_t) 0xffffffff)
+ 
+ /* Network number for local host loopback.  */
+ #define	IN_LOOPBACKNET		127
+ /* Address to loopback in software to local host.  */
+ #ifndef INADDR_LOOPBACK
+-# define INADDR_LOOPBACK	((in_addr_t) 0x7f000001) /* Inet 127.0.0.1.  */
++# define INADDR_LOOPBACK	((uint32_t) 0x7f000001) /* Inet 127.0.0.1.  */
+ #endif
+ 
+ /* Defines for Multicast INADDR.  */
+-#define INADDR_UNSPEC_GROUP	((in_addr_t) 0xe0000000) /* 224.0.0.0 */
+-#define INADDR_ALLHOSTS_GROUP	((in_addr_t) 0xe0000001) /* 224.0.0.1 */
+-#define INADDR_ALLRTRS_GROUP    ((in_addr_t) 0xe0000002) /* 224.0.0.2 */
+-#define INADDR_MAX_LOCAL_GROUP  ((in_addr_t) 0xe00000ff) /* 224.0.0.255 */
++#define INADDR_UNSPEC_GROUP	((uint32_t) 0xe0000000) /* 224.0.0.0 */
++#define INADDR_ALLHOSTS_GROUP	((uint32_t) 0xe0000001) /* 224.0.0.1 */
++#define INADDR_ALLRTRS_GROUP    ((uint32_t) 0xe0000002) /* 224.0.0.2 */
++#define INADDR_MAX_LOCAL_GROUP  ((uint32_t) 0xe00000ff) /* 224.0.0.255 */
+ 
+ #if !__USE_KERNEL_IPV6_DEFS
+ /* IPv6 address */
+@@ -213,8 +213,8 @@
+     union
+       {
+ 	uint8_t	__u6_addr8[16];
+-	uint16_t __u6_addr16[8];
+-	uint32_t __u6_addr32[4];
++	__be16 __u6_addr16[8];
++	__be32 __u6_addr32[4];
+       } __in6_u;
+ #define s6_addr			__in6_u.__u6_addr8
+ #ifdef __USE_MISC
+@@ -253,7 +253,7 @@
+   {
+     __SOCKADDR_COMMON (sin6_);
+     in_port_t sin6_port;	/* Transport layer port # */
+-    uint32_t sin6_flowinfo;	/* IPv6 flow information */
++    __be32 sin6_flowinfo;	/* IPv6 flow information */
+     struct in6_addr sin6_addr;	/* IPv6 address */
+     uint32_t sin6_scope_id;	/* IPv6 scope-id */
+   };
+@@ -371,12 +371,12 @@
+    this was a short-sighted decision since on different systems the types
+    may have different representations but the values are always the same.  */
+ 
+-extern uint32_t ntohl (uint32_t __netlong) __THROW __attribute__ ((__const__));
+-extern uint16_t ntohs (uint16_t __netshort)
++extern uint32_t ntohl (__be32 __netlong) __THROW __attribute__ ((__const__));
++extern uint16_t ntohs (__be16 __netshort)
+      __THROW __attribute__ ((__const__));
+-extern uint32_t htonl (uint32_t __hostlong)
++extern __be32 htonl (uint32_t __hostlong)
+      __THROW __attribute__ ((__const__));
+-extern uint16_t htons (uint16_t __hostshort)
++extern __be16 htons (uint16_t __hostshort)
+      __THROW __attribute__ ((__const__));
+ 
+ #include <endian.h>
+@@ -385,7 +385,7 @@
+ #include <bits/byteswap.h>
+ #include <bits/uintn-identity.h>
+ 
+-#ifdef __OPTIMIZE__
++#ifdef __disabled_OPTIMIZE__
+ /* We can optimize calls to the conversion functions.  Either nothing has
+    to be done or we are using directly the byte-swapping functions which
+    often can be inlined.  */
diff --git a/buildlib/sparse-include/endian.h b/buildlib/sparse-include/endian.h
new file mode 100644
index 00000000000000..ad67c1d155671f
--- /dev/null
+++ b/buildlib/sparse-include/endian.h
@@ -0,0 +1,43 @@
+/* COPYRIGHT (c) 2017 Obsidian Research Corporation. See COPYING file */
+
+#ifndef _SPARSE_ENDIAN_H_
+#define _SPARSE_ENDIAN_H_
+
+#include_next <endian.h>
+
+#include <util/compiler.h>
+
+#undef htobe16
+#undef htole16
+#undef be16toh
+#undef le16toh
+
+#undef htobe32
+#undef htole32
+#undef be32toh
+#undef le32toh
+
+#undef htobe64
+#undef htole64
+#undef be64toh
+#undef le64toh
+
+/* These do not actually work, but this trivially ensures that sparse sees all
+ * the types. */
+
+#define htobe16(x) ((__force __be16)__bswap_16 (x))
+#define htole16(x) ((__force __le16)__bswap_16 (x))
+#define be16toh(x) ((uint16_t)__bswap_16 ((__force uint16_t)(__be16)(x)))
+#define le16toh(x) ((uint16_t)__bswap_16 ((__force uint16_t)(__le16)(x)))
+
+#define htobe32(x) ((__force __be32)__bswap_32 (x))
+#define htole32(x) ((__force __le32)__bswap_32 (x))
+#define be32toh(x) ((uint32_t)__bswap_32 ((__force uint32_t)(__be32)(x)))
+#define le32toh(x) ((uint32_t)__bswap_32 ((__force uint32_t)(__le32)(x)))
+
+#define htobe64(x) ((__force __be64)__bswap_64 (x))
+#define htole64(x) ((__force __le64)__bswap_64 (x))
+#define be64toh(x) ((uint64_t)__bswap_64 ((__force uint64_t)(__be64)(x)))
+#define le64toh(x) ((uint64_t)__bswap_64 ((__force uint64_t)(__le64)(x)))
+
+#endif
diff --git a/buildlib/sparse-include/pthread.h b/buildlib/sparse-include/pthread.h
new file mode 100644
index 00000000000000..cf9de0c6064d1d
--- /dev/null
+++ b/buildlib/sparse-include/pthread.h
@@ -0,0 +1,12 @@
+/* COPYRIGHT (c) 2017 Obsidian Research Corporation. See COPYING file */
+
+#ifndef _SPARSE_PTHREAD_H_
+#define _SPARSE_PTHREAD_H_
+
+#include_next <pthread.h>
+
+/* Sparse complains that the glibc version of this has 0 instead of NULL */
+#undef PTHREAD_MUTEX_INITIALIZER
+#define PTHREAD_MUTEX_INITIALIZER {}
+
+#endif
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
