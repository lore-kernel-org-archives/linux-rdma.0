From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Fri, 18 Nov 2011 01:04:12 -0500 (EST)
Message-ID: <20111118.010412.1322115430763672469.davem@davemloft.net>
References: <20111117.210316.83327515715765011.davem@davemloft.net>
	<20111117.212847.1778246801048496855.davem@davemloft.net>
	<1321592577.354.YahooMailNeo@web24712.mail.ird.yahoo.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321592577.354.YahooMailNeo-06aSuiz6pSvyX4RqAA4FmIglqE1Y4D90QQ4Iyu8u01E@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Date: Fri, 18 Nov 2011 05:02:57 +0000 (GMT)

> Hello David!
> 
> After applying your patch I still get the errors:

Thanks for testing, while I continue to look into this please double
check to make sure you really did run a kernel with the patch applied
:-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
