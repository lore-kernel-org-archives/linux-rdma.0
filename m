From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 FIXES for-3.11 0/4] Pkey fixes for IB core and IPoIB
Date: Thu, 1 Aug 2013 12:42:48 +0300
Message-ID: <51FA2D98.5000707@mellanox.com>
References: <1374145352-27816-1-git-send-email-ogerlitz@mellanox.com> <CAJZOPZLVQhZtWyCJLt3W-COdHZnsrBaN+KOpj83d0GyS+RY+QA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZLVQhZtWyCJLt3W-COdHZnsrBaN+KOpj83d0GyS+RY+QA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 31/07/2013 23:29, Or Gerlitz wrote:
> Roland, so what's about this series, any reason not to push it for 3.11 too
> with the other changes you have picked into the for-next branch? ditto
> for the iser patches to use fast-reg.

Roland, thanks for picking this series too, do you want to add

CC: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org  # v3.10+

on the four patches or prefer I will submit them later to -stable?

I think its perfectly OK to expect a written answer from you on the iser
patches. Are you OK with merging them for 3.11 or they will have to wait
for 3.12?

They bring in the benefit of avoiding bounce buffer when used over
ConnectX Virtual Functions or ConnectIB devices AND ONLY touch
iser code, so no risk to other kernel components.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
