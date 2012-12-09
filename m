From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH] [RFC] osm_log printing incorrectly assumes that
 pthread_t is not opaque type
Date: Sun, 9 Dec 2012 17:43:13 +0000
Message-ID: <75EE638CB68A864F90627D3D06A189A859350715@MTRDAG01.mtl.com>
References: <alpine.BSF.2.00.1212090125590.64779@toaster.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.BSF.2.00.1212090125590.64779-Fqwm7F1mg36Nj9Bq2fkWzw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Garrett,

> Hi,
>  	When porting a newer version of OFED to FreeBSD and running the
> compile against clang with all of the warnings enabled, I ran into build
> failures because osm_log, etc assumes that pthread_t is an integral type
> (which is valid on Linux, but not necessarily correct on other platforms). The
> fix I implemented was attached, but that doesn't necessarily seem correct
> either, so I was wondering what was trying to be gained by printing out the
> thread ID (especially because syslog(9) isn't necessarily an asynch safe
> syscall [1]).

One reason to use "sort of thread id" would be to determine specific flows,
when looking through the log. Why it's important to use async-safe functions
in that case?

I think that instead of using pthread_self(), it's better to use gettid() in Linux
case. Is there any equivalent for this in BSD?


-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
