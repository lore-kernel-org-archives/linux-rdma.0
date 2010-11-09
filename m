From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2] opensm: bug in trap report for MC create(66) and
 delete(67) traps
Date: Tue, 9 Nov 2010 21:35:28 +0200
Message-ID: <20101109193528.GD4673@me>
References: <4B6832F8.9090200@gmail.com>
 <20100203094923.GQ26338@me>
 <4B6B0736.9010001@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B6B0736.9010001-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Koushnir <vladimirk-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 19:43 Thu 04 Feb     , Eli Dorfman (Voltaire) wrote:
> 
> Subject: [PATCH] Wrong handling of MC create and delete traps
> 
> For these traps the GID in the data details is the MGID and
> not the source port gid.
> So the SM should check that subscriber port has the pkey of the MC group.
> There was also an error in comparing the subnet prefix and guid due to
> host/network order mismatch.
> 
> Signed-off-by: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>

Rebased and applied. Thanks.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
