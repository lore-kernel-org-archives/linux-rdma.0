From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_sa_path_record.c: livelock in
 pr_rcv_get_path_parms
Date: Wed, 21 Apr 2010 13:16:42 +0300
Message-ID: <20100421101641.GD23994@me>
References: <4BCC1F3F.5080000@Sun.COM>
 <20100419153421.GB23994@me>
 <4BCCA1C5.5000904@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4BCCA1C5.5000904-UdXhSnd/wVw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Line Holen <Line.Holen-UdXhSnd/wVw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 20:32 Mon 19 Apr     , Line Holen wrote:
> >> @@ -69,6 +70,9 @@
> >>  #include <opensm/osm_prefix_route.h>
> >>  #include <opensm/osm_ucast_lash.h>
> >>  
> >> +
> >> +#define MAX_HOPS 128
> > 
> > IB spec defines maximal number of hops for a fabric which is 64. Would
> > it be netter to use this value here?
> > 
> > Sasha
> 
> The value of 128 was chosen as 2x max DR path allowing the SM to be in
> the middle of a fabric. But I have no problem lowering to 64.

The path in this calculation is between ports and SM is not part of the
game.

For me it seems that 64 would be better number. Hypothetically it could
be even unrelated to LFTs transition issue - when path exceeds 64 hops
SA can return NOT FOUND just well.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
