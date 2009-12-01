From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_vendor_mlx: fix compilation error
Date: Tue, 1 Dec 2009 18:30:44 +0200
Message-ID: <20091201163044.GV16607@me>
References: <4B13DA83.4070400@dev.mellanox.co.il>
 <20091201161716.GU16607@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091201161716.GU16607@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 18:17 Tue 01 Dec     , Sasha Khapyorsky wrote:
> On 16:45 Mon 30 Nov     , Yevgeny Kliteynik wrote:
> > Fix compilation error of that was introduced with patch
> > that added configurable transaction retries - osm_vendor_mlx
> > didn't have a definition of OSM_DEFAULT_RETRY_COUNT.

BTW as far as I understand osm_vendor_mlx is used only with ibmgtsim.
Right? If so could this be switched to osm_vendor_ibumad?

There is already libumad2sim.so (in ibsim) which catches all user_mad
calls and redirects this to where you want. Adoption of such model to
ibmgtsim would have a many advantages: it doesn't require OpenSM
rebuild, it supports not only OpenSM and osmtest, but virtually any
application which uses user_mad, it is really simple.

Finally this will leave us with only one vendor layer -
osm_vendor_ibumad. (AFAIK windows OpenSM is moving this direction too).

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
