From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC 0/8] Reliably generate large request from SRP
Date: Tue, 22 Feb 2011 15:38:35 -0800
Message-ID: <AANLkTikxDu5b=p4fXHMm8W+tF3Lru4vB7xRZEF+HDpyu@mail.gmail.com>
References: <1295411242-26148-1-git-send-email-dillowda@ornl.gov>
 <aday66hxxwe.fsf@cisco.com> <1298074037.15679.17.camel@lap75545.ornl.gov>
 <4D635974.10807@mellanox.com> <1298386190.18945.1.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1298386190.18945.1.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 22, 2011 at 6:49 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> Thanks for the note Or -- you confirmed my suspensions after testing
> last night. Looks like multiple MRs per request, then.

Multiple MRs per request, or one fast reg MR per request?

This really should be roughly the same as old-style FMRs -- in both
cases, we need one "registration" per request that might be in flight.
Old-style FMRs and new IB-spec fast reg MRs should be roughly
the same in terms of resources consumed...

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
