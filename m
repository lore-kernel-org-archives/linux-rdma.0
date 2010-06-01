From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [ANNOUNCE] librdmacm 1.0.12
Date: Tue, 1 Jun 2010 08:18:01 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F3A63BD@orsmsx501.amr.corp.intel.com>
References: <CE35DBA4CC524BD3BDA61C7DE2BD39CD@amr.corp.intel.com>
 <4C024C35.2090703@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C024C35.2090703-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>   gcc -DHAVE_CONFIG_H -I. -I. -I. -I./include -g -Wall -D_GNU_SOURCE -O2 -g
> -pipe -m64 -MT src_librdmacm_la-acm.lo -MD -MP -MF .deps/src_librdmacm_la-
> acm.Tpo -c src/acm.c  -fPIC -DPIC -o
> .libs/src_librdmacm_la-acm.o
> In file included from src/acm.c:44:
> ./include/infiniband/ib.h:49: error: syntax error before "__be16"

At least the following definitions are missing from types.h in redhat 4.x, which is based on 2.6.9.  (These are from RH 5.x.)

158 #ifdef __CHECKER__
159 #define __bitwise__ __attribute__((bitwise))
160 #else
161 #define __bitwise__
162 #endif
163 #ifdef __CHECK_ENDIAN__
164 #define __bitwise __bitwise__
165 #else
166 #define __bitwise
167 #endif
168 
169 typedef __u16 __bitwise __le16;
170 typedef __u16 __bitwise __be16;
171 typedef __u32 __bitwise __le32;
172 typedef __u32 __bitwise __be32;
173 #if defined(__GNUC__) && !defined(__STRICT_ANSI__)
174 typedef __u64 __bitwise __le64;
175 typedef __u64 __bitwise __be64;
176 #endif

Has OFED handled a similar problem in the past?  If so, how?  (I can think of a couple ways to deal with this.)

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
