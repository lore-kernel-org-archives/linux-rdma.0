From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 0/8] Reliably generate large request from SRP
Date: Thu, 20 Jan 2011 09:50:36 -0800
Message-ID: <adad3nrwjkj.fsf@cisco.com>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
	<aday66hxxwe.fsf@cisco.com> <4D3805C4.6010203@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D3805C4.6010203-smomgflXvOZWk0Htik3J/w@public.gmane.org> (Or Gerlitz's message of "Thu, 20
	Jan 2011 11:52:04 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Roland, I wasn't sure to follow if the usage of the FMRs ala the IB spec, 
 > which are supported by mlx4 you were suggesting came to address the bugs
 > or the features... 

I just have a general preference for using the fast mem reg through a
work queue (from BMME), since that is cleaner (eg allows deterministic
unmap with local invalidate work requests, instead of having possibly
still valid FMRs floating around until the batched invalidate happens)
and also what all future devices should support, instead of having hacks
to support the old legacy FMRs.

It's not a problem for SRP (since that's really IB-only) but also I
would expect iWARP devices to have better support for mem reg through
work queues, so anything transport agnostic is better off avoiding FMRs.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
