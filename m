From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] DnUp routing Algorithm
Date: Mon, 4 Jul 2011 13:53:52 +0300
Message-ID: <20110704105352.GB6084@calypso.voltaire.com>
References: <20110628210549.9131ABB2F74@cu0login3.emsl.pnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110628210549.9131ABB2F74-3GowgxBEfRkyPe/kX8gMlWWJnu75u/By@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ken Schmidt <kenneth.schmidt-Y2zl/4KMd60@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Ken,

On 13:30 Tue 28 Jun     , Ken Schmidt wrote:
> This is an updated patch for the DnUp routing algorithm.  Any comments
> are appreciated.
> 
> This routing algorithm operates in a very similar fashion to UpDn, but
> is modified to allow optimal routing on certain network structures in
> which uplinks and CA nodes are connected to the same switch nodes. (For
> example Chinook at EMSL.) In these networks the optimal paths between
> nodes connected to a single chassis would remain within the chassis.
> However due to the uplinks being connected at the same level of the
> network as the CA nodes UpDn will not allow these paths to be used for
> communication between the CA nodes.
> 
> DnUp follows the same procedure as UpDn with a few differences.  Ranking
> is based solely on the relative distance from CA nodes, any switch node
> with a CA node directly attached is assigned a rank of 0 any switch
> node without a CA node attached is assigned a rank of one greater than
> the minimum rank of their neighbors. Transitions are also reversed;
> The initial direction is down and only one transition to up
> is allowed.  There is also an option which relaxes this restriction to
> allow communication with switches nodes similar to the functionality of
> connect_roots in UpDn.
> 
> ---

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
