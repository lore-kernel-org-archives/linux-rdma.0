From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 9/9] IB/srp: Add fast registration support
Date: Mon, 12 May 2014 15:21:41 +0200
Message-ID: <5370CAE5.2030105@acm.org>
References: <5368DA5B.80609@acm.org> <5368DC09.70608@acm.org> <536A1A3A.9090208@dev.mellanox.co.il> <536A4A68.4080605@acm.org> <536A6B2F.70807@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <536A6B2F.70807-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/07/14 19:19, Sagi Grimberg wrote:
> P.S, can we consider also skip scsi_cmnd SEND completions?
> Currently SRP asks for completion but never really arm the CQ (only for
> the first time).

Hello Sagi,

Can you clarify this further ? Removing the IB_SEND_SIGNALED flag from
send requests is not possible because that would result in the HCA only
delivering work completions for failed work requests to the SRP
initiator driver. The loop in srp_send_completion() also needs the work
completions for send work requests that succeeded. In other words, it's
not clear to me what you were referring to ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
