From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_dump.c: dump SL2VL tables
Date: Thu, 25 Mar 2010 10:44:28 -0600
Message-ID: <1269535468.4618.159.camel@sale659.sandia.gov>
References: <4BAB879E.30203@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BAB879E.30203-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Hi Yevgey,

On Thu, 2010-03-25 at 09:56 -0600, Yevgeny Kliteynik wrote:
> Hi Sasha,
> 
> Dumping SL2VL tables in ROUTING verbosity level when QoS is on.
> This is needed for SL2VL tables analysis in general, and for
> routing engines that are using IB VLs in particular, such as
> torus-2QoS.
> 

Very cool.  Thanks.

-- Jim

> Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> ---
>  opensm/opensm/osm_dump.c |   61 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 60 insertions(+), 1 deletions(-)



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
