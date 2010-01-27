From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_vl_arb_rcv.c: fix double mutex release bug
Date: Wed, 27 Jan 2010 12:33:48 +0200
Message-ID: <20100127103348.GL26338@me>
References: <4B600B39.9080100@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B600B39.9080100-UdXhSnd/wVw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Line Holen <Line.Holen-UdXhSnd/wVw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10:45 Wed 27 Jan     , Line Holen wrote:
> The sm lock might be released twice if a response was received
> for a non existent node.
> 
> Signed-off-by: Line Holen <Line.Holen-xsfywfwIY+M@public.gmane.org>

Nice catch!

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
