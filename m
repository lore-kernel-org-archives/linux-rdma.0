From: "Bob Pearson" <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: mlx4 verbs question
Date: Tue, 6 Mar 2012 16:22:05 -0600
Message-ID: <013401ccfbe7$968f69a0$c3ae3ce0$@systemfabricworks.com>
References: <006501ccfb4b$703c49e0$50b4dda0$@systemfabricworks.com> <4F564649.5080301@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F564649.5080301-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Tziporet Koren' <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> -----Original Message-----
> From: Or Gerlitz [mailto:ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
> Sent: Tuesday, March 06, 2012 11:16 AM
> To: Bob Pearson
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Tziporet Koren
> Subject: Re: mlx4 verbs question
> 
> On 3/6/2012 5:44 AM, Bob Pearson wrote:
> >  From the RTS state issuing a modify qp with qp_attr_mask only set to
state
> to the SQD state
> >
> 
> AFAIK SQD isn't supported by connectx

But the ibv_modify_qp to SQD works doesn't return an error?! That is where I
was led astray.

> 
> Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
