From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 0/9] SRP initiator patches for kernel 3.16
Date: Tue, 06 May 2014 16:26:12 +0200
Message-ID: <5368F104.90901@acm.org>
References: <5368DA5B.80609@acm.org> <5368EC54.8020802@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5368EC54.8020802-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <xjtuwjp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/06/14 16:06, Jack Wang wrote:
> On 05/06/2014 02:49 PM, Bart Van Assche wrote:
>> This patch series consists of one patch that adds fast registration
>> support to the SRP initiator and eight preparation patches:
>>
>> 0001-IB-srp-Fix-kernel-doc-warnings.patch
>> 0002-IB-srp-Introduce-an-additional-local-variable.patch
>> 0003-IB-srp-Introduce-srp_alloc_fmr_pool.patch
>> 0004-IB-srp-Introduce-srp_map_fmr.patch
>> 0005-IB-srp-Introduce-srp_finish_mapping.patch
>> 0006-IB-srp-Make-srp_alloc_req_data-reallocate-request-da.patch
>> 0007-IB-srp-Avoid-triggering-an-infinite-loop-if-memory-m.patch
>> 0008-IB-srp-Rename-FMR-related-variables.patch
>> 0009-IB-srp-Add-fast-registration-support.patch
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> The 3rd patch does not show up in the mail list, could you resend it.
> The first 2 looks clear right:)

Hello Jack,

That's strange ... anyway, thanks for the notification. I have resent
patch 3/9.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
