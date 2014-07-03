From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 0/5] SRP initiator patches for kernel 3.17
Date: Thu, 03 Jul 2014 10:03:00 -0700
Message-ID: <1404406980.32754.2.camel@haswell.thedillows.org>
References: <53B55E55.5040907@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53B55E55.5040907-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2014-07-03 at 15:44 +0200, Bart Van Assche wrote:
> This patch series consists of the following five patches, of which three
> are bug fixes and two are performance optimizations:
> 
> 0001-scsi_transport_srp-Fix-fast_io_fail_tmo-dev_loss_tmo.patch
> 0002-IB-srp-Fix-deadlock-between-host-removal-and-multipa.patch
> 0003-IB-srp-Fix-residual-handling.patch
> 0004-IB-srp-Use-P_Key-cache-for-P_Key-lookups.patch
> 0005-IB-srp-Optimize-completion-queue-polling.patch

All except the last can be

Acked-by: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>

or feel free to s/Acked/Reviewed/


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
