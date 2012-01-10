From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [opensm] [PATCH 1/5] Free memory from osm_subn_opt_t when
 osm_subn_t destroyed
Date: Tue, 10 Jan 2012 18:29:24 +0200
Message-ID: <20120110162924.GD25032@calypso>
References: <1321310989.5518.50.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1321310989.5518.50.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Al,

On 14:49 Mon 14 Nov     , Albert Chu wrote:
> Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> ---

Removed unneeded checks before free.

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
