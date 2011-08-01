From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv2 1/3] opensm/osm_helper: Add rate related routines
Date: Mon, 1 Aug 2011 20:11:32 +0300
Message-ID: <20110801171132.GA1980@calypso.mtl.com>
References: <4E32A95F.4050200@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4E32A95F.4050200-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08:36 Fri 29 Jul     , Hal Rosenstock wrote:
> 
> for proper comparison and selector operation
> 
> Rate enum was never is ascending order of actual underlying rates
> but even worse with newly added extended link speeds.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> Changes since v1:
> In find_ordered_rate, changed hard coded constant (2) into define (IB_MIN_RATE)
> Added asserts to ib_path_compare_rates, ib_path_rate_get_prev, and
> ib_path_rate_get_next 
> 

Applied all 4 patches. Thanks.

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
