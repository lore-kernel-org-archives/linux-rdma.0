From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] Improved node descriptions
Date: Thu, 17 Feb 2011 21:19:50 -0800
Message-ID: <AANLkTingH5SC5OhLunF8z1URkzr=B7sd=RJV7ESo1-tr@mail.gmail.com>
References: <20110217213017.25708.95042.stgit@homer> <AANLkTim5MrHMVjaNFtHeWBy82dag4XNxdBcjBEW+d1yb@mail.gmail.com>
 <AANLkTikh-8uGccT0tumHAu6cPOBm+k8joCaQ4W-grkHd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikh-8uGccT0tumHAu6cPOBm+k8joCaQ4W-grkHd-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 17, 2011 at 8:19 PM, Hal Rosenstock
<hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> This looks like a reasonable approach to me, although of course the SM
>> has no way of knowing it should update a port's node description if a
>> hostname changes.

> It does; There's an enhanced trap for this now.

Right; sorry for being unclear but I meant that this patch does not
have a mechanism for generating this trap if the hostname changes
or if userspace changes the node description.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
