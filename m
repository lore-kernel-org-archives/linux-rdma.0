From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: CSUM support in connected mode
Date: Thu, 30 Jul 2015 23:09:08 +0300
Message-ID: <20150730200907.GA3487@yuval-lab>
References: <1438256764-9077-1-git-send-email-yuval.shaia@oracle.com>
 <55BA531E.6060403@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55BA531E.6060403-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 30, 2015 at 09:38:54AM -0700, Bart Van Assche wrote:
> On 07/30/2015 04:46 AM, Yuval Shaia wrote:
> >  struct ipoib_cm_data {
> >  	__be32 qpn; /* High byte MUST be ignored on receive */
> >  	__be32 mtu;
> >+	__be16 sig; /* must be IPOIB_CM_PROTO_SIG */
> >+	__be16 caps; /* 4 bits proto ver and 12 bits capabilities */
> >  };
> 
> This patch modifies the private login data format that has been
> standardized by the IETF in RFC 4755. Has this modification already
> been discussed with the IETF ?
> 
> See also https://tools.ietf.org/html/rfc4755#section-6.
Yes.
I first want to check how linux community react to this proposal.

Please note that though the standard specify 64 bits of data, the actual
data the driver reads/writes is can be up to 196 bytes.
> 
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
