From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] librdmacm: Work-around kernel bug returning uid = 0
Date: Tue, 5 Feb 2013 09:21:31 +0200
Message-ID: <5110B2FB.5050105@mellanox.com>
References: <1359789368-19641-1-git-send-email-sean.hefty@intel.com> <510E109B.8040602@mellanox.com> <510FC1A1.50608@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <510FC1A1.50608-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/02/2013 16:11, Bernd Schubert wrote:
> On 02/03/2013 08:24 AM, Or Gerlitz wrote:
>>
>> It would be also worthwhile to nail the fix to the root cause little
>> further, e.g push kernel commit 418edaaba96 to -stable
>>
>
> Agreed, I opened RHEL bugzilla #719749 (somehow marked as private, no 
> idea why) and hope RedHat is going to back port it into their kernels 
> soon.

the mainline kernel -stable process is something else... Sean I assume 
you understood what I was up to.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
