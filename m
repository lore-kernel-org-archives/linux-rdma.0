From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: ARCH_HAS_PREFETCH in (x86)asm/processor.h?
Date: Wed, 9 Nov 2011 13:30:20 -0800
Message-ID: <35AAF1E4A771E142979F27B51793A48888437760BC@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Does anyone know any reason what this is only set on 32 bit x86 platforms and not on x86_64 platforms?

#ifdef CONFIG_X86_32
# define BASE_PREFETCH          ASM_NOP4
# define ARCH_HAS_PREFETCH                           <--------------------
#else
# define BASE_PREFETCH          "prefetcht0 (%1)"
#endif

I wanted to get rid of some explicit prefetches in a driver I maintain and use prefetch_range(void *, size_t) but it only does something when ARCH_HAS_PREFETCH is defined.

The asm/processor.h uses the alternative_input() stuff to select between the default prefetcht0 and prefetchnta based on module load patching and the xmm feature (most cpus!), so this is exactly what I need except for the missing define.

Mike

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
