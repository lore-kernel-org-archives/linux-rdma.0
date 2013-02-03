From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: Add better error output when parsing node name
 maps
Date: Sun, 3 Feb 2013 19:52:34 +0200
Message-ID: <20130203175234.GF2534@calypso.mtl.com>
References: <1352498124.25353.139.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1352498124.25353.139.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Albert,

On 13:55 Fri 09 Nov     , Albert Chu wrote:
> Presently, any error in opening a node name map file leads
> to a generic:
> 
> "WARNING failed to open node name map"
> 
> error.  This patch adds better error output when the issue
> is specifically parsing errors in the file.  The user
> will get:
> 
> "WARNING failed to parse node name map"
> 
> and an output of the line with the particular issue.
> 
> Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> ---

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
