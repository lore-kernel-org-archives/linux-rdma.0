From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Segmentation Fault when accessing QPN of a RC Queue pair
Date: Wed, 23 Mar 2011 09:54:06 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25DC282B5C@orsmsx501.amr.corp.intel.com>
References: <4D89EDC4.4050309@desy.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D89EDC4.4050309-T5F83Mi6MZE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantin Boyanov <konstantin.boyanov-T5F83Mi6MZE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I have little to no idea why the one causes a SEGFAULT and the other
> not, after all I have created and initialized them in the same way. I am
> really getting frustrated by this, I spend the past 3 days looking for
> some cause but to no avail. If I ommit the line where the SEGFAULT
> occurs I get another later when trying to get the QP to the RTS state,
> so sonething is definetly wrong, but right now I don't have the
> slightest clue what. So please, if someone has some idea what I might be
> doing wrong, share it with me. I am really starting to hate this code,
> as there is no comprehensible description as to what are the
> requirements to create a QP for the different transport types, and also
> no examples (at least I didn't found any).

Both libibverbs and librdmacm provide sample programs, and you could also look at some of the perftest samples.  The simplest of these for RC QPs is probably the rdma_server/rdma_client samples with the librdmacm, but these make use of newer APIs.  For UC QPs, you would need to look at libibverbs.  UD QPs are setup differently, but both libibverbs and librdmacm have samples.

There wasn't enough context provided in the code snippet for me to see the cause of the crash.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
