From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH -v2 09/26] infiniband: rename random32() to prandom_u32()
Date: Fri, 04 Jan 2013 11:15:52 -0600
Message-ID: <50E70E48.3010900@opengridcomputing.com>
References: <1357215562-6288-1-git-send-email-akinobu.mita@gmail.com> <1357215562-6288-10-git-send-email-akinobu.mita@gmail.com> <50E5B183.4030706@opengridcomputing.com> <CAC5umygnMMC2sH2c88P_gEWTgwM=CBCUcqBbo+NX=fOZ2rEGxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAC5umygnMMC2sH2c88P_gEWTgwM=CBCUcqBbo+NX=fOZ2rEGxw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Akinobu Mita <akinobu.mita-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm asking: why are you bothering with renaming the functions?  This 
seems like a needless change, _unless_ there are really 
non-pseudo-random services being added.

On 1/4/2013 7:45 AM, Akinobu Mita wrote:
> 2013/1/4 Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>:
>> Are there other "non pseudo-random" services that warrant this rename?
> I couldn't understand your question very well.  So I'm not sure this is
> the expected answer:
> I only renamed pseudo-random functions defined in lib/random32.c in the
> commit 496f2f93 ("random32: rename random32 to prandom").
> This patch series aims for finishing the naming transition and removing
> the backword compatibility wrapper macros.  Non pseudo-random functions
> are unrelated to this patch series.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
