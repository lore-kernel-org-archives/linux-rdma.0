From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: Reset client reregistration when receiving
 handover
Date: Wed, 29 Feb 2012 19:12:45 +0200
Message-ID: <20120229171245.GG2662@calypso>
References: <1329418015.4779.1197.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1329418015.4779.1197.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Albert,

On 10:46 Thu 16 Feb     , Albert Chu wrote:
> When in master state and receiving a handover from another SM, reset the
> client reregistration bit while reconfguring PortInfo settings.  While
> this is normally handled only the first time a master sweep is done,
> this is a special case in which it is required, because we do not know how
> the other master SM may have configured/setup the fabric.  Most notably,
> this is needed when multicast groups are re-created and we wish for
> end nodes to re-join the multicast group of the new master SM.
> 
> Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> ---

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
