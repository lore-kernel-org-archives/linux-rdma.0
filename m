From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv2] opensm/osm_vendor_ibumad: Use OSM_UMAD_MAX_AGENTS
 rather than UMAD_CA_MAX_AGENTS
Date: Fri, 30 Oct 2009 04:58:57 +0200
Message-ID: <20091030025857.GV20136@me>
References: <20091022134300.GA28208@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20091022134300.GA28208-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09:43 Thu 22 Oct     , Hal Rosenstock wrote:
> 
> This define controls an array in the OpenSM umad vendor layer. Moving
> this define to the vendor layer aids in Windows porting. See thread
> which "ends" with:
> http://lists.openfabrics.org/pipermail/ofw/2009-October/005819.html
> 
> Signed-off-by: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
