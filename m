From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 06/31] IB/ipoib: Avoid memory leak if neigh
 destination was changed
Date: Tue, 14 Nov 2017 23:51:09 +0200
Message-ID: <CAJ3xEMjPD-MwKHknnYVBzzhSoxCFWE2i9jOCC500yEn5pFXarg@mail.gmail.com>
References: <20171114125218.20477-1-leon@kernel.org> <20171114125218.20477-7-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-7-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 2:51 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> From: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> If from some reason the SM responses to path query request with response
> that doesn't contain the exact SGID, ipoib should warn and change that
> part of the response before push it to the path record DB.
> Otherwise, new record will be added to the path record DB with no access
> to them from the ipoib.
>
> Demonstration of the bug is as the follow:

this series contains bunch of fixes, any reason to direct them to
-next (4.16) and not -rc (4.15)

Also, in most of the cases ppl didn't provide a Fixes: line with the
offending patch, any reason to skip that?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
