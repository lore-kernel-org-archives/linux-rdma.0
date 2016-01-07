From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NULL pointer deref in k.o/for-4.5
Date: Thu, 7 Jan 2016 08:07:09 +0200
Message-ID: <CAJ3xEMgzREtWfA8Um5UGxjizV6B1r+7zgXq_0vQG81=SLjHPqQ@mail.gmail.com>
References: <C52C1CEA-9DC4-4594-9D7C-942C25116414@oracle.com>
	<C7F286E4-D17E-45A5-AC31-B7AC1491F72A@oracle.com>
	<CAJ3xEMiu+Tzz_abeEGjP1LXa04mmY69qeqCLZDWteMqGxQtHsQ@mail.gmail.com>
	<EE9BA880-57BB-405F-A6DB-3272BC72C86D@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EE9BA880-57BB-405F-A6DB-3272BC72C86D-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 7, 2016 at 1:31 AM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>> On Jan 6, 2016, at 5:25 PM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Wed, Jan 6, 2016 at 9:20 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

>> was reported here 2-3 times, this fixes that
>> https://patchwork.kernel.org/patch/7929551

> Confirmed, that fixes it. Thanks, I never would have
> guessed that was the fix.

tried linux-rdma mailing list search on people failing with the for-4.5 bits?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
