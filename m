From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] ipoib: fix hard_header return value
Date: Tue, 26 Mar 2013 09:46:28 -0700
Message-ID: <CAG4TOxPa+B1=N8DUPf4E1AT-a__Yx=3d83d1xA6H5pPW=9TabA@mail.gmail.com>
References: <3fde29b99442969e59a7a9cf4f63a26858f00a0a.1364315061.git.dledford@redhat.com>
 <5151CF60.3010100@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5151CF60.3010100-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Checkpatch recommends since some time to use sizeof(e) instead of sizeof e,
> isn't it ?

I actually prefer "sizeof e" since sizeof is an operator, not a
function.  "sizeof(e)" looks just as silly as "return(e)" to me.

I'll apply this patch soon, it's a good catch.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
