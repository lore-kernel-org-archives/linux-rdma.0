From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/ibnetdiscover: Fix handling of CA
 ports in recv_port_info
Date: Wed, 1 Sep 2010 16:44:22 +0300
Message-ID: <20100901134422.GD12172@me>
References: <20100825180802.GA12192@comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100825180802.GA12192-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hnrose-Wuw85uim5zDR7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 14:08 Wed 25 Aug     , Hal Rosenstock wrote:
> 
> When multiple ports on the same CA are connected to the same subnet and
> an ibnetdiscover is initiated from one of them, the discovery continues
> past the other CA port and an error occurs.
> 
> The error is:
> src/query_smp.c:188; umad (DR path slid 0; dlid 0; 0,1,20,2 Attr0x11:0) bad status 110; Connection timed out
> 
> Fix this by saving the initiating port number in the fabric structure
> and using that rather than local_port for the comparison in
> recv_port_info.
> 
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
