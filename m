From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [opensm] [PATCH 1/2] Fix memleak and segfault
Date: Tue, 10 Jan 2012 18:26:01 +0200
Message-ID: <20120110162601.GB25032@calypso>
References: <1320948093.22519.337.camel@auk59.llnl.gov>
 <20111111121957.GA2968@calypso.mtl.com>
 <1321034297.22519.376.camel@auk59.llnl.gov>
 <1321034692.22519.382.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1321034692.22519.382.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Al,

On 10:04 Fri 11 Nov     , Albert Chu wrote:
> If invalid input specified by user, memory would not be freed.
> 
> On rescan with new value, data segment memory could be attempted
> to be freed.
> 
> Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> ---

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
