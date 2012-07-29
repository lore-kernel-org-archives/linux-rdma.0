From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2] opensm/perfmgr: add logging of error counters
Date: Sun, 29 Jul 2012 17:01:02 +0300
Message-ID: <20120729140102.GC5195@calypso>
References: <20120717114041.88bd67854d40f20cad3fe856@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120717114041.88bd67854d40f20cad3fe856-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Ira,

On 11:40 Tue 17 Jul     , Ira Weiny wrote:
> NOTE: the following applies after previous Performance Manager patches posted to the list.
> 
> The initial performance manager only logged Symbol Error, Receive errors, and
> xmit discards.  Additional errors from PortCounters should be logged.
> 
>    - Change error codes to use 4C3X, allows future expansion
>    - Add perfmgr_log_errors flag (default true), allows users to reduce log
>      spamming if they are using an alternate method to collect perfmgr data.
> 
> Changes since V1:
> 	Add help message within generated opensm.conf
> 
> Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> ---

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
