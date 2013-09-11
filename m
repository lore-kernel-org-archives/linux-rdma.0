From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH krping 0/2] krping fixes to work with latest kernels
Date: Wed, 11 Sep 2013 09:50:23 -0500
Message-ID: <5230832F.6020502@opengridcomputing.com>
References: <1378909224-27399-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378909224-27399-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, alext-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 9/11/2013 9:20 AM, Or Gerlitz wrote:
> Hi Steve,
>
> This little series from Alex makes krping from git://git.openfabrics.org/~swise/krping.git
> usable for latest upstream kernels, something we find very useful for testing
> the upstream RDMA stack when developing variuos features.
>
> Or.
>
> Alex Tabachnik (2):
>    Fixes and changes to support latest kernels
>    Update Makefile
>
>   Makefile |   33 +++------------------------------
>   krping.c |   33 +++++++++++++++++++--------------
>   2 files changed, 22 insertions(+), 44 deletions(-)

Applied, thanks!

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
