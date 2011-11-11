From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: libibverbs: Added the man page verbs.7
Date: Fri, 11 Nov 2011 08:50:51 +0100
Message-ID: <CAO+b5-pDo9C4+SZ=wbV9HwKE+yX_-i8EK6oeFSckJwtdFzOE_w@mail.gmail.com>
References: <201111101103.41673.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201111101103.41673.dotanb-g2bIKuvJtcQanlnWow0HJg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 10, 2011 at 10:03 AM, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> +This library is thread safe library and verbs can be called from every thread in the process (the same resource can even be handled from different threads, for example: ibv_poll_cq can be called from more than one thread).

I had one more remark myself: if a novice reads the above, she or he
might start wondering whether the above statement about calling
ibv_poll_cq() from more than one thread refers to calling that
function with different or with identical cq arguments.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
