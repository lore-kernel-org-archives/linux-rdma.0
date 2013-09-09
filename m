From: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Strange NFS client ACK behaviour
Date: Mon, 9 Sep 2013 13:03:42 -0700
Message-ID: <CABgxfbHYMi6z-7OHgfQnMNrihHPcqcipCnXZ65q5yXDJzK7rrg@mail.gmail.com>
References: <12EF8D94C6F8734FB2FF37B9FBEDD173585722AA@EXCHANGE.collogia.de>
	<CABgxfbF6iWsDei3De0ePsrVnA-a3vYuUbD07Bog6m1Mquy6Ecw@mail.gmail.com>
	<12EF8D94C6F8734FB2FF37B9FBEDD17358574B51@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD17358574B51-Xnr6BND5kcg29+KCeZIpYi5l6jQMEky5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Markus Stockhausen <stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 8, 2013 at 11:24 AM, Markus Stockhausen
<stockhausen-FhFLwxQf9jkb1SvskN2V4Q@public.gmane.org> wrote:

>> > we observed a performance drop in our IPoIB NFS backup
>> > infrastructure since we switched to machines with newer
>> > kernels.
>

Not sure how your backup infrastructure works but the symptoms seem to
match with this discussion:
http://www.spinics.net/lists/linux-nfs/msg38980.html

If you know how to recompile nfs kmod, Trond's patch does worth a try.
Or open an Ubuntu support ticket, let them build you a test kmod.

-- Wendy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
