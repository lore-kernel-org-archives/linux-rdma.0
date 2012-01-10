From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [opensm] [PATCH 2/2] Do not load configs from the default config
 file and specified config file
Date: Tue, 10 Jan 2012 18:26:35 +0200
Message-ID: <20120110162635.GC25032@calypso>
References: <1320948100.22519.338.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1320948100.22519.338.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Al,

On 10:01 Thu 10 Nov     , Albert Chu wrote:
> If a config file is specified on the command line, only that config file should
> be used, it should not be parsed in addition to the default.
> 
> Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> ---

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
