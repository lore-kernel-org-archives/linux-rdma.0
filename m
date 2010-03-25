From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] [PATCH 5/22 v2] [for 2.6.36] rdma/cm: update port
	reservation to support AF_IB
Date: Thu, 25 Mar 2010 14:29:24 -0600
Message-ID: <20100325202924.GO29129@obsidianresearch.com>
References: <2F3826558E79459EAD2A457A604221C1@amr.corp.intel.com> <012F7D9E5E97445E9100EF170212AEE7@amr.corp.intel.com> <7451BD1514874F3E987E55040776EECC@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7451BD1514874F3E987E55040776EECC-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 25, 2010 at 12:05:33PM -0700, Sean Hefty wrote:
> +	case AF_IB:
> +		((struct sockaddr_ib *) addr)->sib_sid =
> +			cpu_to_be64(((u64) id_priv->id.ps << 16) + ntohs(port));
> +		break;
> +	}

Could you elaborate a bit on how you are mixing the port space and the
SID?

IMHO, after thinking about it for a bit, I would prefer to see the
port space be unused from a user-space perspective when used with
AF_IB.

If a ps is needed in the kernel then it should pick the ps based on
the SID prefix that user space provided.. I guess prior to adding the
mask bits this wouldn't have made sense, but now that they are in it
seems like the way to go.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
