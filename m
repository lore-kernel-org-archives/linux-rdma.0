From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: Converting from RC to UC
Date: Fri, 11 Mar 2011 13:42:50 -0800
Message-ID: <AANLkTimM0PDiWuHFJfn3s-JVEKWHVVfL4+2Kcc4+G5C7@mail.gmail.com>
References: <loom.20110311T192125-878@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <loom.20110311T192125-878-eS7Uydv5nfjZ+VzJOa5vwg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Cook <acook-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 11, 2011 at 10:29 AM, Alan Cook
<acook-osxm6dDZNBBZx8iatJs59jGjJy/sRE9J@public.gmane.org> wrote:
> I currently have a working RDMA InfiniBand based client-server applic=
ation using
> Reliable Connection (RC) service. =A0I would like to change the appli=
cation to use
> Unreliable Connection (UC) service. =A0I am not performing RDMA reads=
, so I should
> be able to use UC.
>
> I was under the impression that the only change that would be require=
d would be
> changing the queue pair type from IBV_QPT_RC to IBV_QPT_UC.

How are you setting up the connection?

My understanding is that the RDMA CM (ie librdmacm) does not handle UC,
so if you are using that, it shouldn't work.  Sean could confirm this.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
