From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-2.6.38 1/2] IB/ipoib: remove LRO support
Date: Wed, 15 Dec 2010 09:42:28 -0800
Message-ID: <adalj3rgcfv.fsf@cisco.com>
References: <Pine.LNX.4.64.1012151321250.24022@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1012151321250.24022-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org> (Or
	Gerlitz's message of "Wed, 15 Dec 2010 13:24:21 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Ben Hutchings <bhutchings-s/n/eUQHGBpZroRs9YW3xA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks for doing this Or, I've been meaning to switch from LRO to GRO
myself.  One question:

 > have the declaration of restart_syscall to be imported through direct
 > inclusion of linux/sched.h

Is this because <linux/inet_lro.h> indirectly included <linux/sched.h>,
and we're losing that include?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
