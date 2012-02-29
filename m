From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm: Fix opensm handover/relinquish corner case
Date: Wed, 29 Feb 2012 19:11:09 +0200
Message-ID: <20120229171109.GE2662@calypso>
References: <1329178427.4779.1088.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1329178427.4779.1088.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Albert,

On 16:13 Mon 13 Feb     , Albert Chu wrote:
> When in master state and performing light sweeps, openSM ignores
> other subnet managers in master state and fails to perform
> handovers or relinquish control.  Handovers and relinquishing
> master is only performed after a heavy sweep.  This can result
> in two subnet managers being in master state, seeing each other
> SM in master state, but both choose to do nothing about it.
> 
> This patch initiates a heavy sweep when another master subnet
> manager is found during a light sweep.  This is sufficient to
> start a handover or relinquish scenario.
> 
> Signed-off-by: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
> ---

Applied. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
