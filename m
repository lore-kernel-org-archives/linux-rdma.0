From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V5 0/8] IP based RoCE GID Addressing
Date: Sat, 16 Nov 2013 21:52:26 +0200
Message-ID: <CAJZOPZKR=r+OP34ZaJ3PR4=SUxTkHcR60D0MB12ij0v2tic9JA@mail.gmail.com>
References: <1384381792-2023-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1384381792-2023-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 14, 2013 at 12:29 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> changes from V4:
>
>  - addressed feedback re the need to be compatible with non modified user
>    space applications/libraries, by adding code in uverbs which does address
>    resolution when dealing with Ethernet ports. This is patch #7

Does this address your concerns on compatibility so we can move
forward and merge the patches for 3.13?

>
>  - removed the patches that deal with uverbs extended commands, they will
>    added later on, such that new applications/libraries can be coded to them.
>
>  - added patch fixing mlx4_en to have correct IPv6 link local address.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
