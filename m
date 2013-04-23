From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ipoib: fix hard_header return value
Date: Tue, 23 Apr 2013 12:22:12 -0400
Message-ID: <5176B534.7010105@redhat.com>
References: <3fde29b99442969e59a7a9cf4f63a26858f00a0a.1364315061.git.dledford@redhat.com> <CAJZOPZKFT6QT_=bfzp0BN42hxgd4A-t0s7d_TBxD=u=Bgcuvgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZKFT6QT_=bfzp0BN42hxgd4A-t0s7d_TBxD=u=Bgcuvgw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/01/13 17:25, Or Gerlitz wrote:
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> If you have a patched up dhcp server (and dhclient),
> 
> Could you be more specific, I assume you refer to the ISC dhcp bits,
> which version and which patches?

Any version of dhcp server, and the improved-xid and lpf-ib patches
primarily.  We've carried those patches forever, but as far as I know,
they still have not been taken by ISC.  Without them, dhcp server will
only work with a cooked socket interface.  You can't use raw as the
socket type when compiling or else it won't work on IB.  With the
patches, you can enable the raw socket method, and on IB it will fall
back to use PACKET instead.

> AFAIK they don't give you access to
> their source repo but rather only to drops plus possibly patches which
> is a bit more tedious to follow, oh wel...
> 
>> they will use AF_PACKET/SOCK_DGRAM pair to send dhcp packets over IPoIB.
> 
> 
>> This has worked since forever if you use OFED kernels or one of the distribution
>> kernels.  However, when testing an upstream kernel, it has been broken
>> for a very long time (I tested 2.6.34, 2.6.38, 3.0, 3.1, 3.8, HEAD).
> 
> IMO doesn't seem relevant to the upstream commit message

I disagree.  I don't buy the whole "we are upstream, nothing else
matters or is relevant" philosophy.  The truth of the matter is that
there is essentially a fork between upstream and OFED.  I plan on
spending some time bringing some of the relevant fixes present in OFED
and not upstream back to upstream.  In the context of attempting to
manually merge some of that fork back together, I see no reason
whatsoever to ignore relevant historical information during that process.

>> It turns out that the hard_header routine in ipoib is not following
>> the API and is returning 0 even when it pushed data onto the skb.  This
>> then causes af_packet.c to overwrite the header just pushed with data
>> from user space.  This header is immediately referenced in the
>> ipoib_start_xmit routine
> 
> cool, I assume we want this fix to go for -stable after spending some
> time upstream, e.g probably by the time 3.9 is released and some more
> testing is done on the patch (I'll advocate for that @ MLNX, copied
> some folks now) get that to -stable too.

Yes, it can go to -stable.  But, given that no one has noticed before
now that it doesn't work, I'm guessing not many people are using
straight upstream (which is something that needs fixed IMO).

> Erez, in the code we use internally which is based on upstream 3.7 do
> we have DHCP/IPoIB working without this patch?
> 
>> so I'm wondering how this ever worked in
>> distro/ofed kernels that also have this bug, but fixing the bug here
>> makes things work in upstream kernels.
> 
> same for the last three lines
> 
> 
> Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/ulp/ipoib/
> ipoib_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 8534afd..31dd2a7 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -828,7 +828,7 @@ static int ipoib_hard_header(struct sk_buff *skb,
>          */
>         memcpy(cb->hwaddr, daddr, INFINIBAND_ALEN);
> 
> -       return 0;
> +       return sizeof *header;
>  }
> 
>  static void ipoib_set_mcast_list(struct net_device *dev)
> 


-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
