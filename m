From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: opensm/complib: redundant redeclaration of functions
Date: Mon, 01 Feb 2010 15:05:13 +0200
Message-ID: <4B66D189.2090500@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

There are couple of places in complib headers that cause
compiler to complain:

	cl_atomic.h:73: warning: redundant redeclaration of 'cl_atomic_inc'
	cl_atomic_osd.h:58: warning: previous definition of 'cl_atomic_inc' was here

	cl_atomic.h:104: warning: redundant redeclaration of 'cl_atomic_dec'
	cl_atomic_osd.h:69: warning: previous definition of 'cl_atomic_dec' was here

	cl_atomic.h:136: warning: redundant redeclaration of 'cl_atomic_add'
	cl_atomic_osd.h:81: warning: previous definition of 'cl_atomic_add' was here

	cl_atomic.h:171: warning: redundant redeclaration of 'cl_atomic_sub'
	cl_atomic_osd.h:93: warning: previous definition of 'cl_atomic_sub' was here

	cl_thread.h:346: warning: redundant redeclaration of 'cl_is_blockable'
	cl_thread_osd.h:63: warning: previous definition of 'cl_is_blockable' was here

In general, here's the problem:

We have cl_file.h and cl_file_osd.h.
cl_file.h has include directive for cl_file_osd.h
cl_file.h has the following definition of function:
	int foo();

cl_file_osd.h has another function definition, but
this time it also has implementation:
	static inline int foo() { ..... }

Any preferable way to fix this?

Get rid of the _osd.h files and have the functions
implementation included in the usual .h file?

Define some *_HAVE_OSD flag in the _osd.h file
and enclose function declaration in the usual .h
file with #ifndef?

Any other ideas (I'd go for option 2)?

-- Yevgeny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
