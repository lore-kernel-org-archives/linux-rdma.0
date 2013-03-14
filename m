From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] libibmad: Fixes for failures when not all ports of HCA
 are connected
Date: Thu, 14 Mar 2013 10:07:25 +0200
Message-ID: <5141853D.6070500@mellanox.com>
References: <513F83FD.1090106@oracle.com> <CAMLCd9+a5=dnXPHJHYuoODho0aLRp8Vb35sMk0GvRxBgqvx0xQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMLCd9+a5=dnXPHJHYuoODho0aLRp8Vb35sMk0GvRxBgqvx0xQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 13/03/2013 21:36, Ira Weiny wrote:
> Furthermore, I'm reluctant to modify errno in this library.

Yep, this should be avoided unless impossible...

Or.
> It is not documented and in general is poor form.  I realize that the interface
> does not currently allow for an alternative.:-(

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
