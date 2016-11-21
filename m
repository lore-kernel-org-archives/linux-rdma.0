From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v5 2/9] IB/core: Replace semaphore sm_sem with an atomic
 wait
Date: Mon, 21 Nov 2016 08:57:52 -0800
Message-ID: <20161121165752.GA12866@infradead.org>
References: <1479708496-9828-1-git-send-email-binoy.jayan@linaro.org>
 <1479708496-9828-3-git-send-email-binoy.jayan@linaro.org>
 <CA+55aFxGjaqduhRCyk0mVxEA7aqQ-omdG8SBreZ=x5cW2ovngQ@mail.gmail.com>
 <4374986.OFD8bCgUa1@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4374986.OFD8bCgUa1@wuerfel>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tatyana E Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise@opengridc>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 21, 2016 at 05:52:27PM +0100, Arnd Bergmann wrote:
> I think a mutex would't work here, since fops->open() and fops->close()
> are not called from the same context and lockdep will complain
> about that.
> 
> Version of the series had replaced the semaphore with a completion
> here, which worked correctly, but one reviewer suggested using
> the wait_event() instead since it's confusing to have a completion
> starting out in 'completed' state.

On the other hand the existing semaphore works perfectly fine, and
is way easier to understand than any of the other models, which also
don't provide any benefit at all.

Please stop messing with perfectly fine semaphores now - there are
plenty that are much better replaced with mutexes or completions,
but this (and various others are not).  Leave them alone and do
something useful instead.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
