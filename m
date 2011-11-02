From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osmtest/osmtest.c: inventory file parsing bugfix
Date: Wed, 2 Nov 2011 15:55:53 +0200
Message-ID: <20111102135553.GA2710@calypso.mtl.com>
References: <20111102123518.GA3118@UBU02>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111102123518.GA3118@UBU02>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Daniel,

On 14:35 Wed 02 Nov     , Daniel Klein wrote:
> Parsing of 'mkey' field from inventory file fails due to precedences.
> Instead of parsing 'mkey' field, it parsed 'mkey_violations'.
> 
> Signed-off-by: Daniel Klein <danielk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
