From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 0/6] SRP initiator patches for kernel 3.15
Date: Fri, 21 Feb 2014 13:20:09 +0100
Message-ID: <53074479.5090300@acm.org>
References: <5305DE01.7030004@acm.org> <CACaajQt5FVw-8rVhM1jwZPORGNdrAkTf-Gi3NdkKRnQaYde48Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQt5FVw-8rVhM1jwZPORGNdrAkTf-Gi3NdkKRnQaYde48Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/21/14 04:36, Vasiliy Tolstov wrote:
> 2014-02-20 14:50 GMT+04:00 Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>:
>> This patch series includes the following six patches:
>> 0001-scsi_transport_srp-Fix-two-kernel-doc-warnings.patch
>> 0002-IB-srp-Add-more-logging.patch
>> 0003-IB-srp-Fail-SCSI-commands-silently.patch
>> 0004-IB-srp-Avoid-duplicate-connections.patch
>> 0005-IB-srp-Make-writing-into-the-add_target-sysfs-attrib.patch
>> 0006-IB-srp-Avoid-that-writing-into-add_target-hangs-due-.patch
> 
> Is that possible to get some of this into stable 3.10.x?

What I understood from Documentation/stable_kernel_rules.txt is that
patches that fix a bug are acceptable for the stable kernel series but
functionality changes not. So I think patches 4, 5 and 6 would be good
candidates for the stable kernel series. Roland, do you want me to
resend this series with "stable" tags added where appropriate or are you
fine with adding this tag yourself to the last three patches ?

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
