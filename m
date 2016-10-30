From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v4 05/10] IB/isert: Replace semaphore sem with completion
Date: Sun, 30 Oct 2016 23:12:43 +0200
Message-ID: <a267cc5e-4d4f-368e-a159-3eecc2187969@grimberg.me>
References: <1477551554-30349-1-git-send-email-binoy.jayan@linaro.org>
 <1477551554-30349-6-git-send-email-binoy.jayan@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477551554-30349-6-git-send-email-binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> The semaphore 'sem' in isert_device is used as completion, so convert
> it to struct completion. Semaphores are going away in the future.

Umm, this is 100% *not* true. np->sem is designed as a counting to
sync the iscsi login thread with the connect requests coming from the
initiators. So this is actually a reliable bug insertion :(

NAK from me...

Also, I would appreciate if you include get_maintainer.pl in your
patch submissions so I won't need to fish these in the Linux-rdma
patch traffic.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
