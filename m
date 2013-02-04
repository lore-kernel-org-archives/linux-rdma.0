From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: Re: [PATCH] librdmacm: Work-around kernel bug returning uid = 0
Date: Mon, 04 Feb 2013 15:11:45 +0100
Message-ID: <510FC1A1.50608@itwm.fraunhofer.de>
References: <1359789368-19641-1-git-send-email-sean.hefty@intel.com> <510E109B.8040602@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <510E109B.8040602-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/03/2013 08:24 AM, Or Gerlitz wrote:
> On 02/02/2013 09:16, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
>> Older kernels have a bug where it can report an event with the
>> uid set to 0.  The librdmacm crashes when casting the uid to
>> an rdma_cm_id and dereferencing the NULL pointer.
>>
>> There are a limited number of events where this can occur and
>> in most cases it's safe to simply discard the event.  (This is
>> what the kernel does anyway.)  However, it's possible for us
>> to process an RDMA_CM_EVENT_ESTABLISHED event with the uid
>> set to 0.  (See kernel commit 418edaaba96e58112b15c82b4907084e2a9caf42.)
>
> Hi Sean,
>
> It would be also worthwhile to nail the fix to the root cause little
> further, e.g push
> kernel commit 418edaaba96 to -stable
>

Agreed, I opened RHEL bugzilla #719749 (somehow marked as private, no 
idea why) and hope RedHat is going to back port it into their kernels soon.


Cheersm,
Bernd
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
