From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: kernel inline sending / UARs / etc
Date: Mon, 8 Nov 2010 10:31:24 +0200
Message-ID: <20101108083124.GB5921@mtldesk30>
References: <Pine.LNX.4.64.1011080936200.14213@zuben.voltaire.com>
 <E113D394D7C5DB4F8FF691FA7EE9DB443D1BB38721@MTLMAIL.mtl.com>
 <4CD7ABF4.5090305@Voltaire.com>
 <E113D394D7C5DB4F8FF691FA7EE9DB443D1BB387C7@MTLMAIL.mtl.com>
 <4CD7B463.2030402@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4CD7B463.2030402-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 08, 2010 at 10:27:15AM +0200, Or Gerlitz wrote:
> Is this correct that today all the kernels QPs use the same UAR, any
> problem with that?
> 
Yes, today all kernel consumers use the same UAR. And if you want to
use blue flame then you need to use different UARs.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
