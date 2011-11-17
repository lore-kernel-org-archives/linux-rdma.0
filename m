From: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
Subject: Re: linux-next: Tree for Nov 16 (infiniband: ib_srpt.c)
Date: Wed, 16 Nov 2011 18:34:09 -0800
Message-ID: <4EC472A1.6000407@xenotime.net>
References: <20111116133342.3eb15cac16f4c081dc6ed009@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111116133342.3eb15cac16f4c081dc6ed009-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/15/2011 06:33 PM, Stephen Rothwell wrote:
> Hi all,


When CONFIG_BUG is not enabled:

next-2011-1116/drivers/infiniband/ulp/srpt/ib_srpt.c: In function 'srpt_cm_dreq_recv':
next-2011-1116/drivers/infiniband/ulp/srpt/ib_srpt.c:2761:3: error: implicit declaration of function '__WARN'


jbd2 has a similar issue (still unpatched).  One of the comments in that thread
was that ext4 probably should use WARN_ON() instead of __WARN().

Or (Arnd said):
Hmm, my feeling is that we shouldn't do that either, and that jbd2 should
be changed. If we want a function that does what __WARN() does today, we
should probably make a conscious decision about what we want it to be called
and not have it start with "__". <end Arnd>


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
